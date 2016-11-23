//
//  ViewUtil.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/18.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "ViewUtil.h"

@implementation ViewUtil

+ (CGSize)calculateSizeByConstraintFontSize:(CGFloat)size string:(NSString*)str {
    UIFont* font = [UIFont systemFontOfSize:size];
    return [str sizeWithAttributes:@{NSFontAttributeName: font}];
}

+ (CGFloat)calculateHeightByConstraintWidth:(CGFloat)width fontSize:(CGFloat)fontSize string:(NSString*)str {
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}

@end
