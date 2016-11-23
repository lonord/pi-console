//
//  PopNotifyView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/16.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "PopView.h"
#import "ViewUtil.h"

#define BORDER_WIDTH 10.0
#define TEXT_LABEL_HEIGHT 30.0
#define MIN_TEXT_LABEL_WIDTH 40.0
#define FONT_SIZE 16.0
#define OFFSET 80.0

@implementation PopNotifyView {
    UILabel* label;
}

PopNotifyView* thisPopNotifyView;

+ (void)toast:(NSString*)text {
    if (thisPopNotifyView == nil) {
        thisPopNotifyView = [[PopNotifyView alloc] init];
    }
    CGSize textSize = [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:text];
    if (textSize.width < MIN_TEXT_LABEL_WIDTH) {
        textSize.width = MIN_TEXT_LABEL_WIDTH;
    }
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    thisPopNotifyView->label.text = text;
    thisPopNotifyView->label.frame = CGRectMake(BORDER_WIDTH, BORDER_WIDTH, textSize.width + BORDER_WIDTH * 2, TEXT_LABEL_HEIGHT);
    CGFloat width = textSize.width + BORDER_WIDTH * 4;
    thisPopNotifyView.frame = CGRectMake((winSize.width - width) / 2, OFFSET, width, TEXT_LABEL_HEIGHT + BORDER_WIDTH * 2);
    [thisPopNotifyView show];
}

- (id)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        label = [[UILabel alloc] init];
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.layer.borderWidth = 2;
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor orangeColor];
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self addSubview:label];
    }
    return self;
}

- (void)show {
    self.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
