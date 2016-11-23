//
//  PopSelectView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/6.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "PopView.h"

#define MAIN_HEIGHT 300.0
#define MAIN_WIDTH 400.0


@implementation PopSelectView {
    UIView* backView;
    UIView* mainView;
    UIView* titleView;
    UILabel* titleLabel;
    UIActivityIndicatorView* processView;
    UITableView* tableView;
    
    void (^selectCallback)(NSDictionary*);
    NSMutableArray* deviceArray;
}

#pragma mark - public methods

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
        
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_WIDTH, 40)];
        [mainView addSubview:titleView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, MAIN_WIDTH - 60, 20)];
        titleLabel.text = @"正在扫描...";
        [titleView addSubview:titleLabel];
        
        processView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(MAIN_WIDTH - 30, 10, 20, 20)];
        processView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [titleView addSubview:processView];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, MAIN_WIDTH, MAIN_HEIGHT - 40)];
        tableView.delegate = self;
        tableView.dataSource = self;
        [mainView addSubview:tableView];
        
        UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 40, MAIN_WIDTH, 0.5)];
        sepLine.backgroundColor = [UIColor blackColor];
        sepLine.alpha = 0.5;
        [mainView addSubview:sepLine];
        
        [self resizeViews:[UIScreen mainScreen].bounds.size];
        
        deviceArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)resizeViews:(CGSize)winSize {
    self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    backView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    mainView.frame = CGRectMake((winSize.width - MAIN_WIDTH) / 2, (winSize.height - MAIN_HEIGHT) / 2, MAIN_WIDTH, MAIN_HEIGHT);
}

- (void)show:(void(^)(NSDictionary* selected))cb {
    selectCallback = cb;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    [processView startAnimating];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)appendItem:(NSDictionary*)device {
    if ([deviceArray containsObject:device]) {
        return;
    }
    [deviceArray addObject:device];
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:deviceArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}

#pragma mark - UITableViewDelegate delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* selectedDevice = [deviceArray objectAtIndex:indexPath.row];
    [self hide];
    selectCallback(selectedDevice);
}

#pragma mark - UITableViewDataSource delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return deviceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    NSDictionary* item = [deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"title"];
    return cell;
}

@end
