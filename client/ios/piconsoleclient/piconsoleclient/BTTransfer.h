//
//  BTService.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/6.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define SERVICE_UUID    @"FFE0"
#define CHAR_UUID       @"FFE1"

@interface BTPackage : NSObject

@property(nonatomic,assign) unsigned char tag;

@property(nonatomic,readonly) int len;

@property(nonatomic,retain) NSData* data;

- (id)initWithTag:(unsigned char)tag data:(NSData*)data;

@end

@protocol BTServiceDelegate <NSObject>

- (void)connectingDevice:(NSString*)deviceName;

- (void)didConnectDevice;

- (void)deviceReady;

- (void)didDisconnectDevice;

- (void)scanning;

- (void)didScanFoundDevice:(CBPeripheral*)device;

- (void)didReceiveDataPack:(BTPackage*)package;

- (void)serviceDisabled;

@end

@interface BTService : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>

@property(nonatomic,assign) id<BTServiceDelegate> delegate;

+ (BTService*)shareBTService;

- (void)setupBTService;

- (void)connectDevice:(CBPeripheral*)dev;

- (void)disconnectDevice;

- (void)sendDataPack:(BTPackage*)package;

- (void)pauseDeviceConn;

- (void)resumeDeviceConn;

@end
