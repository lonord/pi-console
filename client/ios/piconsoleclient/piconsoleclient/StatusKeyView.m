//
//  StatusKeyView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "KeyboardView.h"

@implementation StatusKeyView {
    id keySwitchListener;
    SEL keySwitchSelector;
    
    UIView* switchIndicator;
    
    NSTimer* timer;
    
    BOOL doubleTap;
}

- (id)init {
    self = [super init];
    if (self) {
        btnLabel.textAlignment = NSTextAlignmentLeft;
        
        switchIndicator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        switchIndicator.layer.cornerRadius = 3;
        switchIndicator.layer.masksToBounds = YES;
        [btnView addSubview:switchIndicator];
        
        [self setSwitchStatus:KeySwitchOff];
        doubleTap = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    switchIndicator.frame = CGRectMake(btnView.frame.size.width - switchIndicator.frame.size.height - 4, 4, switchIndicator.frame.size.width, switchIndicator.frame.size.height);
}

- (void)setKeySwitchListener:(id)listener selector:(SEL)sel {
    keySwitchListener = listener;
    keySwitchSelector = sel;
}

- (void)setSwitchStatus:(KeySwitch)sw {
    _switchStatus = sw;
    switch (sw) {
        case KeySwitchOn:
            btnLabel.textColor = [UIColor blackColor];
            btnView.backgroundColor = [UIColor whiteColor];
            switchIndicator.backgroundColor = [UIColor blackColor];
            break;
        case KeySwitchOnLock:
            btnLabel.textColor = [UIColor blackColor];
            btnView.backgroundColor = [UIColor whiteColor];
            switchIndicator.backgroundColor = [UIColor orangeColor];
            break;
        default:
            btnLabel.textColor = [UIColor whiteColor];
            btnView.backgroundColor = [UIColor blackColor];
            switchIndicator.backgroundColor = [UIColor whiteColor];
            break;
    }
}

#pragma mark - private methods

- (void)setLabelFrame {
    btnLabel.frame = CGRectMake(6, btnView.frame.size.height - 16 - 4, btnView.frame.size.width, 16);
}

- (void)changeStatus:(KeySwitch)sw {
    [self setSwitchStatus:sw];
    if ([keySwitchListener respondsToSelector:keySwitchSelector]) {
        [keySwitchListener performSelector:keySwitchSelector withObject:[NSNumber numberWithInteger:sw]];
    }
}

- (void)setDoubleTap:(BOOL)d {
    @synchronized (self) {
        doubleTap = d;
    }
}

- (BOOL)isDoubleTap {
    @synchronized (self) {
        return doubleTap;
    }
}

- (void)onKeyDown {
    switchIndicator.backgroundColor = [UIColor blackColor];
    popLabel.text = btnLabel.text;
    popView.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
}

- (void)onKeyUp {
    switchIndicator.backgroundColor = [UIColor whiteColor];
    if (_switchStatus == KeySwitchOff) {
        [self changeStatus:KeySwitchOn];
        [timer invalidate];
        [self setDoubleTap:YES];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.4 repeats:NO block:^(NSTimer * _Nonnull timer) {
            [self setDoubleTap:NO];
        }];
    }
    else if (_switchStatus == KeySwitchOn) {
        if ([self isDoubleTap]) {
            [self changeStatus:KeySwitchOnLock];
            popView.backgroundColor = [UIColor orangeColor];
        }
        else {
            [self changeStatus:KeySwitchOff];
        }
    }
    else if (_switchStatus == KeySwitchOnLock) {
        [self changeStatus:KeySwitchOff];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popView removeFromSuperview];
    });
}

@end
