//
//  DateHandler.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/19.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "DateHandler.h"

#define TAG 0xA2

@implementation DateHandler {
    void(^callback)(unsigned char tag, NSData* data);
}

#pragma mark - DataPackHandler delegate methods

- (BOOL)acceptTag:(unsigned char)tag {
    return tag == TAG;
}

- (void)putData:(unsigned char)tag data:(NSData*)data {
}

- (void)setDataCallback:(void(^)(unsigned char tag, NSData* data))cb {
    callback = cb;
}

- (void)notifyBTConnected {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int stamp = (int)[NSDate date].timeIntervalSince1970;
        unsigned char bytes[4];
        bytes[0] = (stamp >> 24) & 0xFF;
        bytes[1] = (stamp >> 16) & 0xFF;
        bytes[2] = (stamp >> 8) & 0xFF;
        bytes[3] = stamp & 0xFF;
        NSData* d = [[NSData alloc] initWithBytes:bytes length:4];
        callback(TAG, d);
    });
}

@end
