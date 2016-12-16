#import "PopView.h"
#import "ViewUtil.h"

#define MAX_LABEL_HEIGHT 260.0
#define LABEL_WIDTH 420.0
#define MARGIN 20.0
#define BTN_HEIGHT 60.0
#define FONT_SIZE 16.0
#define SHUTDOWN_BTN_TEXT @"关机"
#define RESTART_BTN_TEXT @"重启"
#define CANCEL_BTN_TEXT @"取消"
#define NOTIFY_TEXT @"Pi关机选项"

@implementation PopPowerView {
    UIView* backView;
    UIView* mainView;
    UILabel* label;
    UIButton* cancelBtn;
    UIButton* shutdownBtn;
    UIButton* restartBtn;

    void(^callback)(int position);
}

PopPowerView* thisPopPowerView;

+ (void)showWithCallback:(void(^)(int position))cb {
    if (thisPopPowerView == nil) {
        thisPopPowerView = [[PopPowerView alloc] init];
    }
    thisPopPowerView->callback = cb;
    [thisPopPowerView calculateSize:NOTIFY_TEXT];
    thisPopPowerView->label.text = NOTIFY_TEXT;
    [thisPopPowerView show];
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

        shutdownBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [shutdownBtn setTitle:SHUTDOWN_BTN_TEXT forState:UIControlStateNormal];
        [shutdownBtn setTintColor:[UIColor redColor]];
        [shutdownBtn addTarget:self action:@selector(shutdownBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:shutdownBtn];

        restartBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [restartBtn setTitle:RESTART_BTN_TEXT forState:UIControlStateNormal];
        [restartBtn setTintColor:[UIColor orangeColor]];
        [restartBtn addTarget:self action:@selector(restartBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:restartBtn];

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
    CGFloat shutdownBtnWidth = [ViewUtil calculateSizeByConstraintFontSize:[UIFont systemFontSize] string:SHUTDOWN_BTN_TEXT].width + MARGIN * 2;
    CGFloat restartBtnWidth = [ViewUtil calculateSizeByConstraintFontSize:[UIFont systemFontSize] string:RESTART_BTN_TEXT].width + MARGIN * 2;
    shutdownBtn.frame = CGRectMake(mainViewWidth - shutdownBtnWidth - MARGIN, textHeight + MARGIN * 2, shutdownBtnWidth, BTN_HEIGHT);
    restartBtn.frame = CGRectMake(mainViewWidth - shutdownBtnWidth - restartBtnWidth - MARGIN, textHeight + MARGIN * 2, shutdownBtnWidth, BTN_HEIGHT);
    CGFloat cancelBtnWidth = [ViewUtil calculateSizeByConstraintFontSize:[UIFont systemFontSize] string:CANCEL_BTN_TEXT].width + MARGIN * 2;
    cancelBtn.frame = CGRectMake(mainViewWidth - shutdownBtnWidth - restartBtnWidth - cancelBtnWidth - MARGIN, textHeight + MARGIN * 2, cancelBtnWidth, BTN_HEIGHT);
    CGFloat mainViewHeight = shutdownBtn.frame.origin.y + shutdownBtn.frame.size.height;
    mainView.frame = CGRectMake((winSize.width - mainViewWidth) / 2, (winSize.height - mainViewHeight) / 2, mainViewWidth, mainViewHeight);
}

- (void)shutdownBtnClick {
    [self hide];
    callback(0);
}

- (void)restartBtnClick {
    [self hide];
    callback(1);
}

- (void)cancelBtnClick {
    [self hide];
    callback(2);
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
