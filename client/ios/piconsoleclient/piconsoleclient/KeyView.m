//
//  KeyView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "KeyboardView.h"

@implementation KeyView

- (id)init {
    self = [super init];
    if (self) {
        btnView = [[UIView alloc] init];
        btnView.layer.cornerRadius = 4;
        btnView.layer.masksToBounds = YES;
        btnView.layer.borderWidth = 1.5;
        btnView.layer.borderColor = [UIColor whiteColor].CGColor;
        [btnView setBackgroundColor:[UIColor blackColor]];
        [btnView setUserInteractionEnabled:NO];
        [self addSubview:btnView];
        
        btnLabel = [[UILabel alloc] init];
        btnLabel.textColor = [UIColor whiteColor];
        btnLabel.textAlignment = NSTextAlignmentCenter;
        btnLabel.font = [UIFont systemFontOfSize:14];
        [btnView addSubview:btnLabel];
        
        popView = [[UIView alloc] init];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 4;
        popView.layer.masksToBounds = YES;
        popView.userInteractionEnabled = NO;
        
        popLabel = [[UILabel alloc] init];
        popLabel.textColor = [UIColor blackColor];
        popLabel.font = [UIFont systemFontOfSize:20];
        popLabel.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:popLabel];
        
        [self addTarget:self action:@selector(onKeyDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(onKeyUp) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    btnView.frame = CGRectMake(KEY_MARGIN, KEY_MARGIN, frame.size.width - KEY_MARGIN * 2, frame.size.height - KEY_MARGIN * 2);
    [self setLabelFrame];
    CGSize popViewSize = CGSizeMake(btnView.frame.size.width * 1.5, btnView.frame.size.height * 1.5);
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGRect frameInWindow = [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
    if (frameInWindow.origin.y - popViewSize.height - 8 - 4 > 0) {
        CGFloat y = frameInWindow.origin.y - popViewSize.height - 8;
        CGFloat x = frameInWindow.origin.x - frameInWindow.size.width * 0.25;
        if (x < 4) {
            x = 4;
        }
        if (x + popViewSize.width > winSize.width - 4) {
            x = winSize.width - popViewSize.width - 4;
        }
        popView.frame = CGRectMake(x, y, popViewSize.width, popViewSize.height);
    }
    else {
        popView.frame = CGRectMake(winSize.width, 0, popViewSize.width, popViewSize.height);
    }
    popLabel.frame = CGRectMake(0, 0, popViewSize.width, popViewSize.height);
}

- (void)setTitle:(NSString*)title {
    btnLabel.text = title;
}

- (void)setTapEventCompleteListener:(id)target selector:(SEL)sel {
    keyUpListener = target;
    keyUpSelector = sel;
}

- (void)setLabelFrame {
    btnLabel.frame = CGRectMake(0, (btnView.frame.size.height - 16) / 2, btnView.frame.size.width, 16);
}

- (void)onKeyDown {
    btnLabel.textColor = [UIColor blackColor];
    btnView.backgroundColor = [UIColor whiteColor];
    popLabel.text = btnLabel.text;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
}

- (void)onKeyUp {
    btnLabel.textColor = [UIColor whiteColor];
    btnView.backgroundColor = [UIColor blackColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView removeFromSuperview];
    });
    if ([keyUpListener respondsToSelector:keyUpSelector]) {
        [keyUpListener performSelector:keyUpSelector withObject:self];
    }
}

@end
