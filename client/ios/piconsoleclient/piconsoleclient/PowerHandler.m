//
// Created by lonord on 2016/12/15.
// Copyright (c) 2016 lonord. All rights reserved.
//

#import "PowerHandler.h"

#define TAG 0xA3

@implementation PowerHandler {
    void(^callback)(unsigned char tag, NSData* data);
}

#pragma mark - public methods

- (void)sendShutdownCmd {
    unsigned char bytes[1];
    bytes[0] = 1;
    NSData* d = [[NSData alloc] initWithBytes:bytes length:1];
    callback(TAG, d);
}

- (void)sendRestartCmd {
    unsigned char bytes[1];
    bytes[0] = 2;
    NSData* d = [[NSData alloc] initWithBytes:bytes length:1];
    callback(TAG, d);
}

#pragma mark - DataPackHandler delegate methods

- (BOOL)acceptTag:(unsigned char)tag {
    return tag == TAG;
}

- (void)setDataCallback:(void (^)(unsigned char tag, NSData *data))cb {
    callback = cb;
}

@end