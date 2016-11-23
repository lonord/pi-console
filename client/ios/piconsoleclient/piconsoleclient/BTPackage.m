//
//  BTPackage.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "BTTransfer.h"

@implementation BTPackage

- (id)initWithTag:(unsigned char)tag data:(NSData*)data {
    self = [self init];
    if (self) {
        _tag = tag;
        _data = data;
    }
    return self;
}

- (int)len {
    return (int)_data.length;
}

@end
