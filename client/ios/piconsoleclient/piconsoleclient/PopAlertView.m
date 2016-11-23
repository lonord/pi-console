//
//  PopAlertView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/20.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "PopView.h"
#import "ViewUtil.h"

#define MAX_LABEL_HEIGHT 260.0
#define LABEL_WIDTH 420.0
#define MARGIN 10.0
#define FONT_SIZE 16.0
#define OK_BTN_TEXT @"确定"
#define CANCEL_BTN_TEXT @"取消"

@implementation PopAlertView {
    UIView* backView;
    UIView* mainView;
    UILabel* label;
    UIButton* cancelBtn;
    UIButton* okBtn;
    UIView* sep;
    
    void(^callback)(BOOL isOK);
}

PopAlertView* thisPopAlertView;

+ (void)showWithText:(NSString*)text callback:(void(^)(BOOL isOK))cb {
    if (thisPopAlertView == nil) {
        thisPopAlertView = [[PopAlertView alloc] init];
    }
    thisPopAlertView->callback = cb;
    [thisPopAlertView calculateSize:text];
    thisPopAlertView->label.text = text;
    [thisPopAlertView show];
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
        
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:FONT_SIZE];
        label.numberOfLines = 0;
        [mainView addSubview:label];
        
        sep = [[UIView alloc] init];
        sep.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
        [mainView addSubview:sep];
        
        okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [okBtn setTitle:OK_BTN_TEXT forState:UIControlStateNormal];
        [okBtn setTintColor:[UIColor orangeColor]];
        [okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:okBtn];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelBtn setTitle:CANCEL_BTN_TEXT forState:UIControlStateNormal];
        [cancelBtn setTintColor:[UIColor colorWithWhite:0.3 alpha:1]];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cancelBtn];
    }
    return self;
}

- (void)calculateSize:(NSString*)text {
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    backView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    CGFloat mainViewWidth = LABEL_WIDTH + MARGIN * 2;
    CGFloat textHeight = [ViewUtil calculateHeightByConstraintWidth:LABEL_WIDTH fontSize:FONT_SIZE string:text];
    label.frame = CGRectMake(MARGIN, MARGIN, LABEL_WIDTH, textHeight);
    sep.frame = CGRectMake(0, textHeight + MARGIN * 2, mainViewWidth, 0.5);
    CGFloat okBtnWidth = [ViewUtil calculateSizeByConstraintFontSize:[UIFont systemFontSize] string:OK_BTN_TEXT].width + MARGIN * 2;
    okBtn.frame = CGRectMake(mainViewWidth - okBtnWidth - MARGIN, textHeight + MARGIN * 2, okBtnWidth, 40);
    CGFloat cancelBtnWidth = [ViewUtil calculateSizeByConstraintFontSize:[UIFont systemFontSize] string:CANCEL_BTN_TEXT].width + MARGIN * 2;
    cancelBtn.frame = CGRectMake(mainViewWidth - okBtnWidth - cancelBtnWidth - MARGIN, textHeight + MARGIN * 2, cancelBtnWidth, 40);
    CGFloat mainViewHeight = okBtn.frame.origin.y + okBtn.frame.size.height;
    mainView.frame = CGRectMake((winSize.width - mainViewWidth) / 2, (winSize.height - mainViewHeight) / 2, mainViewWidth, mainViewHeight);
}

- (void)okBtnClick {
    [self hide];
    callback(YES);
}

- (void)cancelBtnClick {
    [self hide];
    callback(NO);
}

- (void)show {
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
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

@end
