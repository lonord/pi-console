//
//  PopTextView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/6.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "PopView.h"

#define MAIN_HEIGHT 80.0
#define MAIN_WIDTH 400.0

@implementation PopTextView {
    UIView* backView;
    UIView* mainView;
    UILabel* titleLabel;
}

- (id)init {
    self = [super init];
    if (self) {
        backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [self addSubview:backView];
        
        mainView = [[UIView alloc] init];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.layer.masksToBounds = YES;
        mainView.layer.cornerRadius = 4;
        [self addSubview:mainView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, MAIN_WIDTH - 40, 40)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:titleLabel];
        
        [self resizeViews:[UIScreen mainScreen].bounds.size];
    }
    return self;
}

- (void)resizeViews:(CGSize)winSize {
    self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    backView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    mainView.frame = CGRectMake((winSize.width - MAIN_WIDTH) / 2, (winSize.height - MAIN_HEIGHT) / 2, MAIN_WIDTH, MAIN_HEIGHT);
}

- (void)show:(NSString*)text {
    titleLabel.text = text;
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setText:(NSString*)text {
    [UIView animateWithDuration:0.2 animations:^{
        titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        titleLabel.text = text;
        [UIView animateWithDuration:0.2 animations:^{
            titleLabel.alpha = 1;
        }];
    }];
}

@end
