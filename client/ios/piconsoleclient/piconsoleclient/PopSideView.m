//
//  PopSideView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "PopView.h"

#define VIEW_WIDTH 200.0

@implementation PopSideView {
    UIView* backView;
    UIView* mainView;
    UIView* aboutView;
    UILabel* aboutLabel;
    UITableView* tableView;
    
    NSMutableArray* sectionArray;
    CGSize windowSize;
    id clickListener;
    SEL clickSelector;
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
        
        UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spaceTouch)];
        [backView addGestureRecognizer:tapGes];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setSectionFooterHeight:0];
        [mainView addSubview:tableView];
        
        [self initSubViews];
        
        [self resizeViews:[UIScreen mainScreen].bounds.size];
    }
    return self;
}

- (void)resizeViews:(CGSize)winSize {
    self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    backView.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    mainView.frame = CGRectMake(winSize.width, 0, VIEW_WIDTH, winSize.height);
    windowSize = winSize;
    [self resizeSubViews:mainView.frame.size];
}

- (void)show {
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        mainView.frame = CGRectMake(windowSize.width - VIEW_WIDTH, 0, VIEW_WIDTH, windowSize.height);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        mainView.frame = CGRectMake(windowSize.width, 0, VIEW_WIDTH, windowSize.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setButtonTouchListener:(id)target selector:(SEL)sel {
    clickListener = target;
    clickSelector = sel;
}

#pragma mark - private methods

- (void)initSubViews {
    aboutView = [[UIView alloc] init];
    [tableView setTableHeaderView:aboutView];
    
    aboutLabel = [[UILabel alloc] init];
    aboutLabel.font = [UIFont boldSystemFontOfSize:18];
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString* appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    aboutLabel.text= [NSString stringWithFormat:@"%@  V%@", appName, appVersion];
    [aboutView addSubview:aboutLabel];
    
    sectionArray = [[NSMutableArray alloc] init];
    
    //************************** action ******************************
    
    NSMutableArray* actionCellArray = [[NSMutableArray alloc] init];
    
    UITableViewCell* cellPaste = [[UITableViewCell alloc] init];
    cellPaste.textLabel.text = @"粘贴";
    [actionCellArray addObject:@{@"cell": cellPaste, @"tag": @"paste"}];
    
    [sectionArray addObject:actionCellArray];

    //************************* pi action *****************************

    NSMutableArray* piActionCellArray = [[NSMutableArray alloc] init];

    UITableViewCell* cellPower = [[UITableViewCell alloc] init];
    cellPower.textLabel.text = @"关机...";
    cellPower.textLabel.textColor = [UIColor redColor];
    [piActionCellArray addObject:@{@"cell": cellPower, @"tag": @"power"}];

    [sectionArray addObject:piActionCellArray];

    //************************** sys ******************************
    
    NSMutableArray* sysCellArray = [[NSMutableArray alloc] init];
    
    UITableViewCell* cellReset = [[UITableViewCell alloc] init];
    cellReset.textLabel.text = @"重启当前终端";
    cellReset.textLabel.textColor = [UIColor orangeColor];
    [sysCellArray addObject:@{@"cell": cellReset, @"tag": @"reset_tty"}];
    
    UITableViewCell* cellDisconn = [[UITableViewCell alloc] init];
    cellDisconn.textLabel.text = @"断开连接";
    cellDisconn.textLabel.textColor = [UIColor redColor];
    [sysCellArray addObject:@{@"cell": cellDisconn, @"tag": @"disconnect"}];
    
    [sectionArray addObject:sysCellArray];
}

- (void)resizeSubViews:(CGSize)mainViewSize {
    tableView.frame = CGRectMake(0, 0, mainViewSize.width, mainViewSize.height);
    aboutView.frame = CGRectMake(0, 0, mainViewSize.width, 50);
    aboutLabel.frame = CGRectMake(15, 0, aboutView.frame.size.width - 30, 30);
    [tableView reloadData];
}

- (void)spaceTouch {
    [self hide];
}

#pragma mark - DataPackHandler delegate methods

- (NSInteger)tableView:(UITableView *)t numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray*)sectionArray[section]).count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)t {
    return sectionArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)t cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dic = ((NSMutableArray*)sectionArray[indexPath.section])[indexPath.row];
    return dic[@"cell"];
}

- (void)tableView:(UITableView *)t didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [t deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    NSDictionary* dic = ((NSMutableArray*)sectionArray[indexPath.section])[indexPath.row];
    NSString* tag = dic[@"tag"];
    if ([clickListener respondsToSelector:clickSelector]) {
        [clickListener performSelector:clickSelector withObject:tag];
    }
}

@end
