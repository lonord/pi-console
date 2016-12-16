//
// Created by lonord on 2016/12/15.
// Copyright (c) 2016 lonord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataPackHandlerDelegate.h"


@interface PowerHandler : NSObject<DataPackHandlerDelegate>

- (void)sendShutdownCmd;

- (void)sendRestartCmd;

@end