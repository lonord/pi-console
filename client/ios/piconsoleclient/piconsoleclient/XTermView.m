//
//  XTermView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/7.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "XTermView.h"

#define JS_SEND_BUFFER_SIZE 1024

@implementation XTermView {
    UIWebView* webView;
    JSContext* jsContext;
    int ttyNumber;
    void (^dataCallback)(unsigned char tag, NSData* data);
    
    BOOL needPrompt;
}

- (id)init {
    self = [super init];
    if (self) {
        webView = [[UIWebView alloc] init];
        webView.scrollView.bounces = NO;
        webView.delegate = self;
        [self addSubview:webView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resizeViews:[UIScreen mainScreen].bounds.size];
}

- (void)initWebView:(int)num {
    ttyNumber = num;
    NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"index.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [webView loadRequest:request];
    needPrompt = YES;
}

- (void)setDataCallback:(void(^)(unsigned char tag, NSData* data))cb {
    dataCallback = cb;
}

- (void)notifyBTConnected {
    JSValue* func = jsContext[@"requestTermFit"];
    [func callWithArguments:nil];
    //正常连接需要发送提示命令，断线重连不需要
    if (needPrompt) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //发送提示命令 E? 01 03
            unsigned char bytes[1];
            bytes[0] = 3;
            NSData* data = [[NSData alloc] initWithBytes:bytes length:1];
            dataCallback(0xE0 + ttyNumber, data);
            needPrompt = NO;
        });
    }
}

- (void)sendKey:(NSString*)keyName flag:(NSUInteger)flag {
    dispatch_async(dispatch_get_main_queue(), ^{
        JSValue* func = jsContext[@"sendKey"];
        JSValue* flagVal = [JSValue valueWithUInt32:(uint32_t)flag inContext:jsContext];
        [func callWithArguments:@[keyName, flagVal]];
    });
}

- (void)sendRestartCmd {
    //发送重启pty命令 E? 01 02
    unsigned char bytes[1];
    bytes[0] = 2;
    NSData* data = [[NSData alloc] initWithBytes:bytes length:1];
    dataCallback(0xE0 + ttyNumber, data);
    [webView reload];
}

- (void)reloadXTermView {
    [webView reload];
    needPrompt = YES;
}

#pragma mark - private methods

- (void)resizeViews:(CGSize)winSize {
    webView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - DataPackHandler delegate methods

- (void)putData:(unsigned char)tag data:(NSData*)data {
    if (tag == 0xF0 + ttyNumber) {
        NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (str == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSUInteger t = [[NSDate date] timeIntervalSince1970] * 1000;
            JSValue* func = jsContext[@"sendData"];
            NSString* dataStr = str;
            int c = 0;
            while (YES) {
                if (dataStr.length > JS_SEND_BUFFER_SIZE) {
                    NSString* s = [dataStr substringToIndex:JS_SEND_BUFFER_SIZE];
                    dataStr = [dataStr substringFromIndex:JS_SEND_BUFFER_SIZE];
                    [func callWithArguments:@[s]];
                    c++;
                }
                else {
                    [func callWithArguments:@[dataStr]];
                    c++;
                    break;
                }
            }
            NSUInteger now = [[NSDate date] timeIntervalSince1970] * 1000;
            NSLog(@"send data to js %d times, using %ldms.", c, (now - t));
        });
//        JSValue* func = jsContext[@"sendData"];
//        JSValue* dataVal = [JSValue valueWithObject:dataStr inContext:jsContext];
//        [func callWithArguments:@[dataVal]];
    }
}

- (BOOL)acceptTag:(unsigned char)tag {
    return (tag == 0xF0 + ttyNumber || tag == 0xE0 + ttyNumber);
}

- (void)webViewDidFinishLoad:(UIWebView *)w {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    jsContext = [w valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    __block XTermView* blockSelf = self;
    jsContext[@"objcResize"] = ^(NSNumber* cols, NSNumber* rows) {
        int c = [cols intValue];
        int r = [rows intValue];
        unsigned char bytes[5];
        bytes[0] = 1;
        bytes[1] = c / 256;
        bytes[2] = c % 256;
        bytes[3] = r / 256;
        bytes[4] = r % 256;
        blockSelf->dataCallback(0xE0 + ttyNumber, [NSData dataWithBytes:bytes length:5]);
    };
    jsContext[@"objcSendData"] = ^(NSString* dataStr) {
        NSData* data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        blockSelf->dataCallback(0xF0 + ttyNumber, data);
    };
}

@end
