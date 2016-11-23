//
//  SysInfoItem.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/18.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataPackHandlerDelegate.h"

@interface SysInfoItem : UIView<DataPackHandlerDelegate>

- (id)initWithHeight:(CGFloat)height;

@end
