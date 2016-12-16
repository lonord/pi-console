//
//  SysInfoItem.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/18.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "SysInfoItem.h"
#import "ViewUtil.h"

#define MARGIN_H 2.0
#define MARGIN_V 1.0
#define FONT_SIZE 10.0
#define CPU_TITLE @"CPU:"
#define MEM_TITLE @"MEM:"
#define BATT_TITLE @"BATT:"

#define TAG 0xA1

@implementation SysInfoItem {
    UIView* cpuView;
    UIView* memView;
    UIView* battView;
    UILabel* labelCpuTitle;
    UILabel* labelCpuVal;
    UILabel* labelMemTitle;
    UILabel* labelMemVal;
    UILabel* labelBattTitle;
    UILabel* labelBattVal;
}

- (id)initWithHeight:(CGFloat)height {
    self = [super init];
    if (self) {
        cpuView = [[UIView alloc] init];
        cpuView.layer.borderWidth = 0.5;
        cpuView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        [self addSubview:cpuView];
        
        labelCpuTitle = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_H, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:CPU_TITLE].width, height - MARGIN_V * 2)];
        labelCpuTitle.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelCpuTitle.text = CPU_TITLE;
        labelCpuTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [cpuView addSubview:labelCpuTitle];
        
        labelCpuVal = [[UILabel alloc] initWithFrame:CGRectMake(labelCpuTitle.frame.origin.x + labelCpuTitle.frame.size.width, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:@"999%"].width + 0.5, height - MARGIN_V * 2)];
        labelCpuVal.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelCpuVal.text = @"---%";
        labelCpuVal.textAlignment = NSTextAlignmentRight;
        labelCpuVal.textColor = [UIColor whiteColor];
        [cpuView addSubview:labelCpuVal];
        
        cpuView.frame = CGRectMake(MARGIN_H, MARGIN_V, labelCpuTitle.frame.size.width + labelCpuVal.frame.size.width + MARGIN_H * 2, height - MARGIN_V * 2);
        
        memView = [[UIView alloc] init];
        memView.layer.borderWidth = 0.5;
        memView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        [self addSubview:memView];
        
        labelMemTitle = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_H, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:MEM_TITLE].width, height - MARGIN_V * 2)];
        labelMemTitle.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelMemTitle.text = MEM_TITLE;
        labelMemTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [memView addSubview:labelMemTitle];
        
        labelMemVal = [[UILabel alloc] initWithFrame:CGRectMake(labelMemTitle.frame.origin.x + labelMemTitle.frame.size.width, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:@"99%"].width + 0.5, height - MARGIN_V * 2)];
        labelMemVal.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelMemVal.text = @"--%";
        labelMemVal.textAlignment = NSTextAlignmentRight;
        labelMemVal.textColor = [UIColor whiteColor];
        [memView addSubview:labelMemVal];
        
        memView.frame = CGRectMake(cpuView.frame.origin.x + cpuView.frame.size.width + MARGIN_H, MARGIN_V, labelMemTitle.frame.size.width + labelMemVal.frame.size.width + MARGIN_H * 2, height - MARGIN_V * 2);
        
        battView = [[UIView alloc] init];
        battView.layer.borderWidth = 0.5;
        battView.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:1].CGColor;
        [self addSubview:battView];
        
        labelBattTitle = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN_H, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:BATT_TITLE].width, height - MARGIN_V * 2)];
        labelBattTitle.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelBattTitle.text = BATT_TITLE;
        labelBattTitle.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        [battView addSubview:labelBattTitle];
        
        labelBattVal = [[UILabel alloc] initWithFrame:CGRectMake(labelBattTitle.frame.origin.x + labelBattTitle.frame.size.width, 0, [ViewUtil calculateSizeByConstraintFontSize:FONT_SIZE string:@"100%"].width + 0.5, height - MARGIN_V * 2)];
        labelBattVal.font = [UIFont systemFontOfSize:FONT_SIZE];
        labelBattVal.text = @"---%";
        labelBattVal.textAlignment = NSTextAlignmentRight;
        labelBattVal.textColor = [UIColor whiteColor];
        [battView addSubview:labelBattVal];
        
        battView.frame = CGRectMake(memView.frame.origin.x + memView.frame.size.width + MARGIN_H, MARGIN_V, labelBattTitle.frame.size.width + labelBattVal.frame.size.width + MARGIN_H * 2, height - MARGIN_V * 2);
        
        self.frame = CGRectMake(0, 0, battView.frame.origin.x + battView.frame.size.width + MARGIN_H, height);
    }
    return self;
}

#pragma mark - DataPackHandler delegate methods

- (void)putData:(unsigned char)tag data:(NSData *)data {
    unsigned char* bytes = (unsigned char*)data.bytes;
    int len = (int)data.length;
    if (len != 4) {
        return;
    }
    int cpu = bytes[0] * 256 + bytes[1];
    int mem = bytes[2];
    int batt = bytes[3];
    labelCpuVal.text = [NSString stringWithFormat:@"%d%%", cpu];
    labelMemVal.text = [NSString stringWithFormat:@"%d%%", mem];
    if (batt == 0xFF) {
        labelBattVal.text = @"---%";
    }
    else {
        labelBattVal.text = [NSString stringWithFormat:@"%d%%", batt];
    }
}

- (BOOL)acceptTag:(unsigned char)tag {
    return tag == TAG;
}

@end
