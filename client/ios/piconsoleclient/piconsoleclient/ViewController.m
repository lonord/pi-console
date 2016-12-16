//
//  ViewController.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/5.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "ViewController.h"
#import "PopView.h"
#import "XTermView.h"
#import "KeyboardView.h"
#import "StatusView.h"
#import "SysInfoItem.h"
#import "DateHandler.h"
#import "PowerHandler.h"

#define KEYBOARD_MAX_HEIGHT 240.0

#define NOTIFY_VIEW_WIDTH 100.0
#define NOTIFY_VIEW_HEIGHT 60.0

#define STATUS_BAR_HEIGHT 14.0

@interface ViewController ()

@end

@implementation ViewController {
    UIView* mainView;
    PopTextView* popTextView;
    PopSelectView* popSelectView;
    PopSideView* popSideView;
    XTermView* xTermView1;
    XTermView* xTermView2;
    XTermView* xTermView3;
    UIView<KeyboardViewDelegate>* keyboardView;
    StatusView* statusBar;

    BTService* btService;
    NSMutableArray* packageHandlerArray;
    int activeXTermNum;
    PowerHandler* powerHandler;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView = [[UIView alloc] init];
    [self.view addSubview:mainView];
    
    xTermView1 = [[XTermView alloc] init];
    [mainView addSubview:xTermView1];
    [xTermView1 setHidden:YES];
    
    xTermView2 = [[XTermView alloc] init];
    [mainView addSubview:xTermView2];
    [xTermView2 setHidden:YES];
    
    xTermView3 = [[XTermView alloc] init];
    [mainView addSubview:xTermView3];
    [xTermView3 setHidden:YES];
    
    keyboardView = [[FullKeyboardView alloc] init];
    [keyboardView setKeyCodeListener:self selector:@selector(onKey:status:)];
    [keyboardView setOptionKeyListener:self selector:@selector(onOptionKey:)];
    [mainView addSubview:keyboardView];
    
    popSideView = [[PopSideView alloc] init];
    [popSideView setButtonTouchListener:self selector:@selector(sideViewButtonClicked:)];
    
    statusBar = [[StatusView alloc] init];
    [mainView addSubview:statusBar];
    
    packageHandlerArray = [[NSMutableArray alloc] init];
    [self setupPackageHandlers];
    activeXTermNum = 1;
    
    btService = [BTService shareBTService];
    btService.delegate = self;
    
    UIScreenEdgePanGestureRecognizer* recognizerLeft = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgeGestureLeft:)];
    recognizerLeft.edges = UIRectEdgeLeft;
    UIScreenEdgePanGestureRecognizer* recognizerRight = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgeGestureRight:)];
    recognizerRight.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:recognizerLeft];
    [self.view addGestureRecognizer:recognizerRight];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 0.5), dispatch_get_main_queue(), ^{
        [self showText:@"正在搜索Pi..."];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), dispatch_get_main_queue(), ^{
            [btService setupBTService];
            [xTermView1 setHidden:NO];
            [xTermView2 setHidden:NO];
            [xTermView3 setHidden:NO];
        });
    });
}

- (void)viewWillLayoutSubviews {
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    BOOL isStatusBarShown = !self.prefersStatusBarHidden;
    if (isStatusBarShown) {
        mainView.frame = CGRectMake(0, 20, winSize.width, winSize.height - 20);
    }
    else {
        mainView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    }
    CGFloat keyboardHeight = KEYBOARD_MAX_HEIGHT;
    if (winSize.height / 2 < keyboardHeight) {
        keyboardHeight = winSize.height / 2;
    }
    CGFloat xTermHeight = mainView.frame.size.height - keyboardHeight;
    CGFloat xTermWidth = mainView.frame.size.width;
    xTermView1.frame = CGRectMake((1 - activeXTermNum) * xTermWidth, 0, xTermWidth, xTermHeight);
    xTermView2.frame = CGRectMake((2 - activeXTermNum) * xTermWidth, 0, xTermWidth, xTermHeight);
    xTermView3.frame = CGRectMake((3 - activeXTermNum) * xTermWidth, 0, xTermWidth, xTermHeight);
    keyboardView.frame = CGRectMake(0, xTermHeight, mainView.frame.size.width, keyboardHeight);
    [popSelectView resizeViews:winSize];
    [popTextView resizeViews:winSize];
    [popSideView resizeViews:winSize];
    statusBar.frame = CGRectMake(mainView.frame.size.width - statusBar.frame.size.width, 0, statusBar.frame.size.width, STATUS_BAR_HEIGHT);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat minSize = size.height > size.width ? size.width : size.height;
    if (minSize > 600) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)setupPackageHandlers {
    void (^dataCallback)(unsigned char tag, NSData* data) = ^(unsigned char tag, NSData *data) {
        [btService sendDataPack:[[BTPackage alloc] initWithTag:tag data:data]];
    };
    
    // *** Add Handlers Here ***
    
    [xTermView1 initWebView:1];
    [packageHandlerArray addObject:xTermView1];
    
    [xTermView2 initWebView:2];
    [packageHandlerArray addObject:xTermView2];
    
    [xTermView3 initWebView:3];
    [packageHandlerArray addObject:xTermView3];
    
    SysInfoItem* sysInfoItem = [[SysInfoItem alloc] initWithHeight:STATUS_BAR_HEIGHT];
    [statusBar appendItem:sysInfoItem];
    [packageHandlerArray addObject:sysInfoItem];
    
    [packageHandlerArray addObject:[[DateHandler alloc] init]];

    powerHandler = [[PowerHandler alloc] init];
    [packageHandlerArray addObject:powerHandler];
    
    // ****** Handlers end *****
    
    for (id handler in packageHandlerArray) {
        if ([handler isKindOfClass:[NSObject<DataPackHandlerDelegate> class]]) {
            if ([handler respondsToSelector:@selector(setDataCallback:)]) {
                [handler setDataCallback:dataCallback];
            }
        }
    }
}

- (void)dealWithBTPackage:(BTPackage*)package {
    for (id<DataPackHandlerDelegate> handler in packageHandlerArray) {
        if ([handler acceptTag:package.tag] && [handler respondsToSelector:@selector(putData:data:)]) {
            [handler putData:package.tag data:package.data];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showText:(NSString*)text {
    if (popSelectView != nil) {
        [popSelectView hide];
        popSelectView = nil;
    }
    if (popTextView == nil) {
        popTextView = [[PopTextView alloc] init];
        [popTextView show:text];
    }
    else {
        [popTextView setText:text];
    }
}

- (void)showSelect:(CBPeripheral*)peripheral {
    if (popTextView != nil) {
        [popTextView hide];
        popTextView = nil;
    }
    if (popSelectView == nil) {
        popSelectView = [[PopSelectView alloc] init];
        [popSelectView show:^(NSDictionary* selected) {
            [btService connectDevice:selected[@"obj"]];
        }];
    }
    [popSelectView appendItem:@{@"title": peripheral.name, @"obj": peripheral}];
}

- (void)hideAllPopView {
    if (popTextView != nil) {
        [popTextView hide];
        popTextView = nil;
    }
    if (popSelectView != nil) {
        [popSelectView hide];
        popSelectView = nil;
    }
}

- (void)switchXTermTo:(int)num {
    activeXTermNum = num;
    CGFloat xTermWidth = xTermView1.frame.size.width;
    CGFloat xTermHeight = xTermView1.frame.size.height;
    CGFloat xTermY = xTermView1.frame.origin.y;
    [UIView animateWithDuration:0.4 animations:^{
        xTermView1.frame = CGRectMake((1 - activeXTermNum) * xTermWidth, xTermY, xTermWidth, xTermHeight);
        xTermView2.frame = CGRectMake((2 - activeXTermNum) * xTermWidth, xTermY, xTermWidth, xTermHeight);
        xTermView3.frame = CGRectMake((3 - activeXTermNum) * xTermWidth, xTermY, xTermWidth, xTermHeight);
    } completion:^(BOOL finished) {
        [PopNotifyView toast:[NSString stringWithFormat:@"%d", activeXTermNum]];
    }];
}

#pragma mark - listener methods

- (void)onKey:(NSString*)keyCode status:(NSNumber*)status {
    NSUInteger flag = [status unsignedIntegerValue] >> 1;
    switch (activeXTermNum) {
        case 2:
            [xTermView2 sendKey:keyCode flag:flag];
            break;
        case 3:
            [xTermView3 sendKey:keyCode flag:flag];
            break;
        default:
            [xTermView1 sendKey:keyCode flag:flag];
            break;
    }
    
}

- (void)onOptionKey:(NSString*)identifier {
    if ([identifier isEqualToString:@"option"]) {
        [popSideView show];
    }
}

- (void)edgeGestureLeft:(UIScreenEdgePanGestureRecognizer*)ges {
    if (ges.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (activeXTermNum > 1) {
        [self switchXTermTo:activeXTermNum - 1];
    }
    else {
        [PopNotifyView toast:[NSString stringWithFormat:@"%d", activeXTermNum]];
    }
}

- (void)edgeGestureRight:(UIScreenEdgePanGestureRecognizer*)ges {
    if (ges.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (activeXTermNum < 3) {
        [self switchXTermTo:activeXTermNum + 1];
    }
    else {
        [PopNotifyView toast:[NSString stringWithFormat:@"%d", activeXTermNum]];
    }
}

- (void)sideViewButtonClicked:(NSString*)identifier {
    XTermView* activeXTerm;
    switch (activeXTermNum) {
        case 2:
            activeXTerm = xTermView2;
            break;
        case 3:
            activeXTerm = xTermView3;
            break;
        default:
            activeXTerm = xTermView1;
            break;
    }
    if ([identifier isEqualToString:@"disconnect"]) {
        [btService disconnectDevice];
        [xTermView1 reloadXTermView];
        [xTermView2 reloadXTermView];
        [xTermView3 reloadXTermView];
    }
    else if ([identifier isEqualToString:@"reset_tty"]) {
        [activeXTerm sendRestartCmd];
    }
    else if ([identifier isEqualToString:@"paste"]) {
        UIPasteboard* board = [UIPasteboard generalPasteboard];
        NSString* str;
        if (board.hasURLs) {
            str = board.URL.absoluteString;
        }
        else if (board.hasStrings) {
            str = board.string;
        }
        
        void(^doPaste)(BOOL isOK) = ^(BOOL isOK) {
            if (isOK) {
                NSData* d = [str dataUsingEncoding:NSUTF8StringEncoding];
                unsigned char tag = 0xF0 + activeXTermNum;
                BTPackage* p = [[BTPackage alloc] initWithTag:tag data:d];
                [btService sendDataPack:p];
            }
        };
        
        if ([str containsString:@"\r"] || [str containsString:@"\n"]) {
            [PopAlertView showWithText:[NSString stringWithFormat:@"%@\n------------------------------\n包含换行符，仍然粘贴吗？", str] callback:doPaste];
        }
        else {
            doPaste(YES);
        }
    }
    else if ([identifier isEqualToString:@"power"]) {
        [PopPowerView showWithCallback:^(int position) {
            if (position == 0) {
                [powerHandler sendShutdownCmd];
            }
            else if (position == 1) {
                [powerHandler sendRestartCmd];
            }
        }];
    }
}

#pragma mark - BTServiceDelegate delegate methods

- (void)scanning {
}

- (void)connectingDevice:(NSString*)deviceName {
    [self showText:[NSString stringWithFormat:@"正在连接 %@ ...", deviceName]];
}

- (void)didConnectDevice {
    [self showText:@"正在发现服务..."];
}

- (void)deviceReady {
    [self hideAllPopView];
    for (id<DataPackHandlerDelegate> handler in packageHandlerArray) {
        if ([handler respondsToSelector:@selector(notifyBTConnected)]) {
            [handler notifyBTConnected];
        }
    }
}

- (void)didDisconnectDevice {
    [self showText:@"连接断开"];
    for (id<DataPackHandlerDelegate> handler in packageHandlerArray) {
        if ([handler respondsToSelector:@selector(notifyBTDisconnected)]) {
            [handler notifyBTDisconnected];
        }
    }
}

- (void)didScanFoundDevice:(CBPeripheral*)device {
    [self showSelect:device];
//    [btService connectDevice:device];
}

- (void)didReceiveDataPack:(BTPackage*)package {
    [self dealWithBTPackage:package];
}

- (void)serviceDisabled {
    [self showText:@"蓝牙不可用"];
}


@end
