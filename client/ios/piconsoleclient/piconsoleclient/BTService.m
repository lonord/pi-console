//
//  BTService.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/6.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "BTTransfer.h"

#define KNOWN_DEVICE @"knownDevice"

@implementation BTService {
    CBPeripheral* device;
    CBPeripheral* devicePause;
    CBPeripheral* connectingDevice;
    CBCentralManager* manager;
    CBCharacteristic* transferChar;
    NSMutableData *recvData;
    NSUserDefaults* defaults;
    
    BOOL deviceAvalible;
}

#pragma mark - public methods

+ (BTService*)shareBTService {
    static BTService* service = nil;
    if (service == nil) {
        service = [[BTService alloc] init];
    }
    return service;
}

- (id)init {
    self = [super init];
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
        recvData = [[NSMutableData alloc] initWithCapacity:0];
        deviceAvalible = NO;
    }
    return self;
}

- (void)setupBTService {
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)connectDevice:(CBPeripheral*)dev {
    device = nil;
    [self setKnownDeviceId:nil];
    [self stopScan];
    connectingDevice = dev;
    [manager connectPeripheral:dev options:nil];
    [self.delegate connectingDevice:dev.name];
}

- (void)disconnectDevice {
    if (device == nil) {
        return;
    }
    [manager cancelPeripheralConnection:device];
    [self setKnownDeviceId:nil];
}

- (void)sendDataPack:(BTPackage*)package {
    if (manager.state != CBCentralManagerStatePoweredOn || device == nil || transferChar == nil) {
        return;
    }
    unsigned char head[3];
    head[0] = package.tag;
    head[1] = (unsigned char) (package.len / 256);
    head[2] = (unsigned char) (package.len % 256);
    NSMutableData *sendData = [[NSMutableData alloc] initWithCapacity:3];
    [sendData appendBytes:head length:3];
    [sendData appendData:package.data];
    while (YES) {
        if ([sendData length] > 20) {
            NSData* sub = [sendData subdataWithRange:NSMakeRange(0, 20)];
//            [self logData:sub];
            [device writeValue:sub forCharacteristic:transferChar type:CBCharacteristicWriteWithoutResponse];
            [sendData replaceBytesInRange:NSMakeRange(0, 20) withBytes:NULL length:0];
        }
        else
        {
//            [self logData:sendData];
            [device writeValue:sendData forCharacteristic:transferChar type:CBCharacteristicWriteWithoutResponse];
            break;
        }
    }
}

- (void)pauseDeviceConn {
    if (device == nil) {
        return;
    }
    devicePause = device;
    [manager cancelPeripheralConnection:device];
}

- (void)resumeDeviceConn {
    if (devicePause == nil) {
        return;
    }
    [self stopScan];
    connectingDevice = devicePause;
    [manager connectPeripheral:devicePause options:nil];
    [self.delegate connectingDevice:devicePause.name];
}

#pragma mark - private methods

- (void)scan {
    [manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:SERVICE_UUID]] options:nil];
    [self.delegate scanning];
}

- (void)stopScan {
    [manager stopScan];
}

- (void)appendRecvData:(NSData*)data {
    if (!deviceAvalible) {
        return;
    }
    [recvData appendData:data];
    while (YES) {
//        [self logData:recvData];
        if (recvData.length < 3) {
            break;
        }
        unsigned char* chs = (unsigned char*)recvData.bytes;
        unsigned char tag = chs[0];
        int len = chs[1] * 256 + chs[2];
        if (recvData.length < len + 3) {
            break;
        }
        BTPackage* package = [[BTPackage alloc] initWithTag:tag data:[recvData subdataWithRange:NSMakeRange(3, len)]];
        [recvData replaceBytesInRange:NSMakeRange(0, len + 3) withBytes:NULL length:0];
        [self.delegate didReceiveDataPack:package];
    }
//    NSLog(@"data recv queue left count: %lu", (unsigned long)recvData.length);
}

- (NSString*)getKnownDeviceId {
    NSString* devId = [defaults stringForKey:KNOWN_DEVICE];
    if (devId == nil) {
        return @"";
    }
    else {
        return devId;
    }
}

- (void)setKnownDeviceId:(NSString*)devId {
    [defaults setObject:devId forKey:KNOWN_DEVICE];
    [defaults synchronize];
}

#pragma mark - CBCentralManager delegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if ([central state] != CBCentralManagerStatePoweredOn) {
        [self.delegate serviceDisabled];
        return;
    }
    [self scan];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    [self.delegate didScanFoundDevice:peripheral];
    NSString* knownDeviceId = [self getKnownDeviceId];
    if (knownDeviceId != nil && [knownDeviceId isEqualToString:peripheral.identifier.UUIDString]) {
        [self connectDevice:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    device = peripheral;
    connectingDevice = nil;
    [self setKnownDeviceId:peripheral.identifier.UUIDString];
    [self.delegate didConnectDevice];
    [peripheral setDelegate:self];
    [peripheral discoverServices:@[[CBUUID UUIDWithString:SERVICE_UUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    device = nil;
    transferChar = nil;
    connectingDevice = nil;
    recvData = [[NSMutableData alloc] init];
    deviceAvalible = NO;
    if (devicePause == nil) {
        [self.delegate didDisconnectDevice];
        [self scan];
    }
}

#pragma mark - CBPeripheral delegate methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (peripheral != device) {
        return;
    }
    for (CBService* service in peripheral.services) {
        if ([service.UUID.UUIDString isEqualToString:SERVICE_UUID]) {
            [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:CHAR_UUID]] forService:service];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (peripheral != device || ![service.UUID.UUIDString isEqualToString:SERVICE_UUID]) {
        return;
    }
    for (CBCharacteristic* ch in service.characteristics) {
        if ([ch.UUID.UUIDString isEqualToString:CHAR_UUID]) {
            transferChar = ch;
            [self.delegate deviceReady];
            deviceAvalible = YES;
            [peripheral setNotifyValue:YES forCharacteristic:ch];
            break;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (peripheral != device || ![characteristic.service.UUID.UUIDString isEqualToString:SERVICE_UUID] || ![characteristic.UUID.UUIDString isEqualToString:CHAR_UUID]) {
        return;
    }
//    [self logData:characteristic.value];
    [self appendRecvData:characteristic.value];
}

@end
