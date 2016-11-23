//
//  ViewUtil.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/18.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ViewUtil : NSObject

+ (CGSize)calculateSizeByConstraintFontSize:(CGFloat)size string:(NSString*)str;

+ (CGFloat)calculateHeightByConstraintWidth:(CGFloat)width fontSize:(CGFloat)fontSize string:(NSString*)str;

@end
