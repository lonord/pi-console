//
//  StatusView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/18.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "StatusView.h"

@implementation StatusView {
    NSMutableArray* itemViewArray;
}

- (id)init {
    self = [super init];
    if (self) {
        self.alpha = 0.7;
        self.userInteractionEnabled = NO;
        
        itemViewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat leftMargin = 0;
    for (int i = (int)itemViewArray.count - 1; i >= 0; i--) {
        UIView* v = itemViewArray[i];
        v.frame = CGRectMake(leftMargin, 0, v.frame.size.width, v.frame.size.height);
        if (v.superview == nil) {
            [self addSubview:v];
        }
        leftMargin += v.frame.size.width;
    }
}

- (void)appendItem:(UIView*)item {
    if ([itemViewArray containsObject:item]) {
        return;
    }
    [itemViewArray addObject:item];
    CGFloat selfNewWidth = [self calculateItemsWidth];
    CGRect selfNewRect = CGRectMake(self.frame.origin.x + self.frame.size.width - selfNewWidth, self.frame.origin.y, selfNewWidth, self.frame.size.height);
    [self setFrame:selfNewRect];
}

#pragma mark - private methods

- (CGFloat)calculateItemsWidth {
    CGFloat w = 0;
    for (UIView* v in itemViewArray) {
        w += v.frame.size.width;
    }
    return w;
}

@end
