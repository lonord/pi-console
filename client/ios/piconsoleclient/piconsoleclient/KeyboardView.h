//
//  KeyboardView.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/10.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KeyboardView.h"

#define KEY_MARGIN 2.0

typedef NS_OPTIONS(NSUInteger, KeyStatus) {
    KeyStatusNormal = 0,
    KeyStatusFn = 1 << 0,
    KeyStatusShift = 1 << 1,
    KeyStatusCtrl = 1 << 2,
    KeyStatusAlt = 1 << 3
};

typedef NS_ENUM(NSInteger, KeySwitch) {
    KeySwitchOff,
    KeySwitchOn,
    KeySwitchOnLock
};

@protocol KeyboardViewDelegate <NSObject>

- (void)setKeyCodeListener:(id)listener selector:(SEL)sel;

- (void)setOptionKeyListener:(id)listener selector:(SEL)sel;

@end

@interface KeyView : UIButton {
    UIView* btnView;
    UILabel* btnLabel;
    UIView* popView;
    UILabel* popLabel;
    id keyUpListener;
    SEL keyUpSelector;
}

- (void)setTitle:(NSString*)title;

- (void)setTapEventCompleteListener:(id)target selector:(SEL)sel;

- (void)setLabelFrame;

- (void)onKeyDown;

- (void)onKeyUp;

@end

@interface NormalKeyView : KeyView

- (void)setTitle:(NSString*)title keyName:(NSString*)key forStatus:(KeyStatus)status;

- (void)setStatus:(KeyStatus)status;

- (void)setKeyListener:(id)target selector:(SEL)sel;

@end

@interface StatusKeyView : KeyView

- (void)setKeySwitchListener:(id)listener selector:(SEL)sel;

@property(nonatomic,assign) KeySwitch switchStatus;

@end

@interface FullKeyboardView : UIView<KeyboardViewDelegate>

@end








