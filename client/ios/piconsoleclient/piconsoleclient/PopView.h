//
//  PopView.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopSelectView : UIView<UITableViewDelegate, UITableViewDataSource>

- (void)resizeViews:(CGSize)winSize;

- (void)show:(void(^)(NSDictionary* selected))cb;

- (void)hide;

- (void)appendItem:(NSDictionary*)device;

@end

@interface PopTextView : UIView

- (void)resizeViews:(CGSize)winSize;

- (void)show:(NSString*)text;

- (void)hide;

- (void)setText:(NSString*)text;

@end

@interface PopNotifyView : UIView

+ (void)toast:(NSString*)text;

@end

@interface PopSideView : UIView<UITableViewDelegate, UITableViewDataSource>

- (void)resizeViews:(CGSize)winSize;

- (void)show;

- (void)hide;

- (void)setButtonTouchListener:(id)target selector:(SEL)sel;

@end

@interface PopAlertView : UIView

+ (void)showWithText:(NSString*)text callback:(void(^)(BOOL isOK))cb;

@end
