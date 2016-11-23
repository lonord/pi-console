//
//  XTermView.h
//  piconsoleclient
//
//  Created by lonord on 2016/11/7.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "DataPackHandlerDelegate.h"

@interface XTermView : UIView<DataPackHandlerDelegate, UIWebViewDelegate>

- (void)initWebView:(int)num;

- (void)sendKey:(NSString*)keyName flag:(NSUInteger)flag;

- (void)sendRestartCmd;

- (void)reloadXTermView;

@end
