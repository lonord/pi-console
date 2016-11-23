//
//  NormalKeyView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "KeyboardView.h"

@implementation NormalKeyView {
    NSMutableDictionary* keyStatusDictionary;
    NSString* normalTitle;
    NSString* normalKeyCode;
    NSUInteger keyStatus;
    NSString* currentKeyCode;
    id listener;
    SEL selector;
    NSTimer* timer;
    NSInteger timerCount;
}

- (id)init {
    self = [super init];
    if (self) {
        keyStatusDictionary = [[NSMutableDictionary alloc] init];
        normalTitle = @"";
        normalKeyCode = @"";
        currentKeyCode = normalKeyCode;
    }
    return self;
}

- (void)setTitle:(NSString*)title keyName:(NSString*)key forStatus:(KeyStatus)status {
    if (status == KeyStatusNormal) {
        normalTitle = title;
        normalKeyCode = key;
        currentKeyCode = normalKeyCode;
        [self setTitle:title];
        return;
    }
    NSNumber* k = [NSNumber numberWithUnsignedInteger:status];
    NSDictionary* v = @{@"title": (title != nil) ? title : normalTitle, @"key": key};
    [keyStatusDictionary setObject:v forKey:k];
}

- (void)setStatus:(KeyStatus)status {
    keyStatus = status;
    [self refreshTitleAndKeyCode];
}

- (void)setKeyListener:(id)target selector:(SEL)sel {
    listener = target;
    selector = sel;
}

#pragma mark - private methods

- (void)refreshTitleAndKeyCode {
    for (NSNumber* s in keyStatusDictionary) {
        if ([s unsignedIntegerValue] == keyStatus) {
            NSDictionary* d = keyStatusDictionary[s];
            [self setTitle:d[@"title"]];
            currentKeyCode = d[@"key"];
            return;
        }
    }
    NSUInteger v = 0;
    NSDictionary* vd = nil;
    for (NSNumber* s in keyStatusDictionary) {
        NSUInteger t = [s unsignedIntegerValue] & keyStatus;
        if (t > 0) {
            if (v == 0) {
                v = t;
                vd = keyStatusDictionary[s];
                continue;
            }
            if (t < v) {
                v = t;
                vd = keyStatusDictionary[s];
            }
        }
    }
    if (v == 0) {
        [self setTitle:normalTitle];
        currentKeyCode = normalKeyCode;
        return;
    }
    [self setTitle:vd[@"title"]];
    currentKeyCode = vd[@"key"];
}

- (void)fireKey {
    if ([listener respondsToSelector:selector]) {
        [listener performSelector:selector withObject:currentKeyCode withObject:[NSNumber numberWithUnsignedInteger:keyStatus]];
    }
}

- (void)onKeyDown {
    [super onKeyDown];
    [self fireKey];
    timerCount = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (timerCount >= 6) {
            [self fireKey];
            return;
        }
        timerCount++;
    }];
}

- (void)onKeyUp {
    [super onKeyUp];
    [timer invalidate];
}

@end
