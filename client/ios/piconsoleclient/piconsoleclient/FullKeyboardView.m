//
//  FullKeyboardView.m
//  piconsoleclient
//
//  Created by lonord on 2016/11/17.
//  Copyright © 2016年 lonord. All rights reserved.
//

#import "KeyboardView.h"

@implementation FullKeyboardView {
    UIView* contentView;
    NormalKeyView* keyEsc;
    NormalKeyView* key1;
    NormalKeyView* key2;
    NormalKeyView* key3;
    NormalKeyView* key4;
    NormalKeyView* key5;
    NormalKeyView* key6;
    NormalKeyView* key7;
    NormalKeyView* key8;
    NormalKeyView* key9;
    NormalKeyView* key0;
    NormalKeyView* keyMinus;
    NormalKeyView* keyEqual;
    NormalKeyView* keyBackspace;
    NormalKeyView* keyGrave;
    NormalKeyView* keyQ;
    NormalKeyView* keyW;
    NormalKeyView* keyE;
    NormalKeyView* keyR;
    NormalKeyView* keyT;
    NormalKeyView* keyY;
    NormalKeyView* keyU;
    NormalKeyView* keyI;
    NormalKeyView* keyO;
    NormalKeyView* keyP;
    NormalKeyView* keyLeftBrace;
    NormalKeyView* keyRightBrace;
    NormalKeyView* keyBackSlash;
    NormalKeyView* keyTab;
    NormalKeyView* keyA;
    NormalKeyView* keyS;
    NormalKeyView* keyD;
    NormalKeyView* keyF;
    NormalKeyView* keyG;
    NormalKeyView* keyH;
    NormalKeyView* keyJ;
    NormalKeyView* keyK;
    NormalKeyView* keyL;
    NormalKeyView* keySemicolon;
    NormalKeyView* keyApostrophe;
    NormalKeyView* keyEnter;
    NormalKeyView* keyZ;
    NormalKeyView* keyX;
    NormalKeyView* keyC;
    NormalKeyView* keyV;
    NormalKeyView* keyB;
    NormalKeyView* keyN;
    NormalKeyView* keyM;
    NormalKeyView* keyComma;
    NormalKeyView* keyDot;
    NormalKeyView* keySlash;
    NormalKeyView* keyUp;
    NormalKeyView* keySpace;
    NormalKeyView* keyLeft;
    NormalKeyView* keyDown;
    NormalKeyView* keyRight;
    StatusKeyView* keyFn;
    StatusKeyView* keyShift;
    StatusKeyView* keyCtrl;
    StatusKeyView* keyAlt;
    KeyView* keyOption;
    
    NSArray* normalKeyArray;
    id keyCodeListener;
    id optionKeyListener;
    SEL keyCodeSelector;
    SEL optionKeySelector;
}

- (id)init {
    self = [super init];
    if (self) {
        contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        [self initKeys];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resizeViews:[UIScreen mainScreen].bounds.size];
}

- (void)setKeyCodeListener:(id)listener selector:(SEL)sel {
    keyCodeListener = listener;
    keyCodeSelector = sel;
}

- (void)setOptionKeyListener:(id)listener selector:(SEL)sel {
    optionKeyListener = listener;
    optionKeySelector = sel;
}

#pragma mark - private methods

- (void)initKeys {
    //esc
    keyEsc = [[NormalKeyView alloc] init];
    [keyEsc setTitle:@"Esc" keyName:@"key_esc" forStatus:KeyStatusNormal];
    [contentView addSubview:keyEsc];
    
    //1
    key1 = [[NormalKeyView alloc] init];
    [key1 setTitle:@"1" keyName:@"key_1" forStatus:KeyStatusNormal];
    [key1 setTitle:@"!" keyName:@"key_1_2" forStatus:KeyStatusShift];
    [key1 setTitle:@"F1" keyName:@"key_f1" forStatus:KeyStatusFn];
    [contentView addSubview:key1];
    
    //2
    key2 = [[NormalKeyView alloc] init];
    [key2 setTitle:@"2" keyName:@"key_2" forStatus:KeyStatusNormal];
    [key2 setTitle:@"@" keyName:@"key_2_2" forStatus:KeyStatusShift];
    [key2 setTitle:@"F2" keyName:@"key_f2" forStatus:KeyStatusFn];
    [contentView addSubview:key2];
    
    //3
    key3 = [[NormalKeyView alloc] init];
    [key3 setTitle:@"3" keyName:@"key_3" forStatus:KeyStatusNormal];
    [key3 setTitle:@"#" keyName:@"key_3_2" forStatus:KeyStatusShift];
    [key3 setTitle:@"F3" keyName:@"key_f3" forStatus:KeyStatusFn];
    [contentView addSubview:key3];
    
    //4
    key4 = [[NormalKeyView alloc] init];
    [key4 setTitle:@"4" keyName:@"key_4" forStatus:KeyStatusNormal];
    [key4 setTitle:@"$" keyName:@"key_4_2" forStatus:KeyStatusShift];
    [key4 setTitle:@"F4" keyName:@"key_f4" forStatus:KeyStatusFn];
    [contentView addSubview:key4];
    
    //5
    key5 = [[NormalKeyView alloc] init];
    [key5 setTitle:@"5" keyName:@"key_5" forStatus:KeyStatusNormal];
    [key5 setTitle:@"%" keyName:@"key_5_2" forStatus:KeyStatusShift];
    [key5 setTitle:@"F5" keyName:@"key_f5" forStatus:KeyStatusFn];
    [contentView addSubview:key5];
    
    //6
    key6 = [[NormalKeyView alloc] init];
    [key6 setTitle:@"6" keyName:@"key_6" forStatus:KeyStatusNormal];
    [key6 setTitle:@"^" keyName:@"key_6_2" forStatus:KeyStatusShift];
    [key6 setTitle:@"F6" keyName:@"key_f6" forStatus:KeyStatusFn];
    [contentView addSubview:key6];
    
    //7
    key7 = [[NormalKeyView alloc] init];
    [key7 setTitle:@"7" keyName:@"key_7" forStatus:KeyStatusNormal];
    [key7 setTitle:@"&" keyName:@"key_7_2" forStatus:KeyStatusShift];
    [key7 setTitle:@"F7" keyName:@"key_f7" forStatus:KeyStatusFn];
    [contentView addSubview:key7];
    
    //8
    key8 = [[NormalKeyView alloc] init];
    [key8 setTitle:@"8" keyName:@"key_8" forStatus:KeyStatusNormal];
    [key8 setTitle:@"*" keyName:@"key_8_2" forStatus:KeyStatusShift];
    [key8 setTitle:@"F8" keyName:@"key_f8" forStatus:KeyStatusFn];
    [contentView addSubview:key8];
    
    //9
    key9 = [[NormalKeyView alloc] init];
    [key9 setTitle:@"9" keyName:@"key_9" forStatus:KeyStatusNormal];
    [key9 setTitle:@"(" keyName:@"key_9_2" forStatus:KeyStatusShift];
    [key9 setTitle:@"F9" keyName:@"key_f9" forStatus:KeyStatusFn];
    [contentView addSubview:key9];
    
    //0
    key0 = [[NormalKeyView alloc] init];
    [key0 setTitle:@"0" keyName:@"key_0" forStatus:KeyStatusNormal];
    [key0 setTitle:@")" keyName:@"key_0_2" forStatus:KeyStatusShift];
    [key0 setTitle:@"F10" keyName:@"key_f10" forStatus:KeyStatusFn];
    [contentView addSubview:key0];
    
    //-
    keyMinus = [[NormalKeyView alloc] init];
    [keyMinus setTitle:@"-" keyName:@"key_minus" forStatus:KeyStatusNormal];
    [keyMinus setTitle:@"_" keyName:@"key_minus_2" forStatus:KeyStatusShift];
    [keyMinus setTitle:@"F11" keyName:@"key_f11" forStatus:KeyStatusFn];
    [contentView addSubview:keyMinus];
    
    //=
    keyEqual = [[NormalKeyView alloc] init];
    [keyEqual setTitle:@"=" keyName:@"key_equal" forStatus:KeyStatusNormal];
    [keyEqual setTitle:@"+" keyName:@"key_equal_2" forStatus:KeyStatusShift];
    [keyEqual setTitle:@"F12" keyName:@"key_f12" forStatus:KeyStatusFn];
    [contentView addSubview:keyEqual];
    
    //backspace
    keyBackspace = [[NormalKeyView alloc] init];
    [keyBackspace setTitle:@"Bak" keyName:@"key_backspace" forStatus:KeyStatusNormal];
    [keyBackspace setTitle:@"Del" keyName:@"key_del" forStatus:KeyStatusFn];
    [contentView addSubview:keyBackspace];
    
    //`
    keyGrave = [[NormalKeyView alloc] init];
    [keyGrave setTitle:@"`" keyName:@"key_grave" forStatus:KeyStatusNormal];
    [keyGrave setTitle:@"~" keyName:@"key_grave_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyGrave];
    
    //q
    keyQ = [[NormalKeyView alloc] init];
    [keyQ setTitle:@"q" keyName:@"key_q" forStatus:KeyStatusNormal];
    [keyQ setTitle:@"Q" keyName:@"key_Q" forStatus:KeyStatusShift];
    [contentView addSubview:keyQ];
    
    //w
    keyW = [[NormalKeyView alloc] init];
    [keyW setTitle:@"w" keyName:@"key_w" forStatus:KeyStatusNormal];
    [keyW setTitle:@"W" keyName:@"key_W" forStatus:KeyStatusShift];
    [contentView addSubview:keyW];
    
    //e
    keyE = [[NormalKeyView alloc] init];
    [keyE setTitle:@"e" keyName:@"key_e" forStatus:KeyStatusNormal];
    [keyE setTitle:@"E" keyName:@"key_E" forStatus:KeyStatusShift];
    [contentView addSubview:keyE];
    
    //r
    keyR = [[NormalKeyView alloc] init];
    [keyR setTitle:@"r" keyName:@"key_r" forStatus:KeyStatusNormal];
    [keyR setTitle:@"R" keyName:@"key_R" forStatus:KeyStatusShift];
    [contentView addSubview:keyR];
    
    //t
    keyT = [[NormalKeyView alloc] init];
    [keyT setTitle:@"t" keyName:@"key_t" forStatus:KeyStatusNormal];
    [keyT setTitle:@"T" keyName:@"key_T" forStatus:KeyStatusShift];
    [contentView addSubview:keyT];
    
    //y
    keyY = [[NormalKeyView alloc] init];
    [keyY setTitle:@"y" keyName:@"key_y" forStatus:KeyStatusNormal];
    [keyY setTitle:@"Y" keyName:@"key_Y" forStatus:KeyStatusShift];
    [contentView addSubview:keyY];
    
    //u
    keyU = [[NormalKeyView alloc] init];
    [keyU setTitle:@"u" keyName:@"key_u" forStatus:KeyStatusNormal];
    [keyU setTitle:@"U" keyName:@"key_U" forStatus:KeyStatusShift];
    [contentView addSubview:keyU];
    
    //i
    keyI = [[NormalKeyView alloc] init];
    [keyI setTitle:@"i" keyName:@"key_i" forStatus:KeyStatusNormal];
    [keyI setTitle:@"I" keyName:@"key_I" forStatus:KeyStatusShift];
    [contentView addSubview:keyI];
    
    //o
    keyO = [[NormalKeyView alloc] init];
    [keyO setTitle:@"o" keyName:@"key_o" forStatus:KeyStatusNormal];
    [keyO setTitle:@"O" keyName:@"key_O" forStatus:KeyStatusShift];
    [contentView addSubview:keyO];
    
    //p
    keyP = [[NormalKeyView alloc] init];
    [keyP setTitle:@"p" keyName:@"key_p" forStatus:KeyStatusNormal];
    [keyP setTitle:@"P" keyName:@"key_P" forStatus:KeyStatusShift];
    [contentView addSubview:keyP];
    
    //[
    keyLeftBrace = [[NormalKeyView alloc] init];
    [keyLeftBrace setTitle:@"[" keyName:@"key_left_brace" forStatus:KeyStatusNormal];
    [keyLeftBrace setTitle:@"{" keyName:@"key_left_brace_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyLeftBrace];
    
    //]
    keyRightBrace = [[NormalKeyView alloc] init];
    [keyRightBrace setTitle:@"]" keyName:@"key_right_brace" forStatus:KeyStatusNormal];
    [keyRightBrace setTitle:@"}" keyName:@"key_right_brace_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyRightBrace];
    
    //backslash
    keyBackSlash = [[NormalKeyView alloc] init];
    [keyBackSlash setTitle:@"\\" keyName:@"key_back_slash" forStatus:KeyStatusNormal];
    [keyBackSlash setTitle:@"|" keyName:@"key_back_slash_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyBackSlash];
    
    //tab
    keyTab = [[NormalKeyView alloc] init];
    [keyTab setTitle:@"Tab" keyName:@"key_tab" forStatus:KeyStatusNormal];
    [contentView addSubview:keyTab];
    
    //a
    keyA = [[NormalKeyView alloc] init];
    [keyA setTitle:@"a" keyName:@"key_a" forStatus:KeyStatusNormal];
    [keyA setTitle:@"A" keyName:@"key_A" forStatus:KeyStatusShift];
    [contentView addSubview:keyA];
    
    //s
    keyS = [[NormalKeyView alloc] init];
    [keyS setTitle:@"s" keyName:@"key_s" forStatus:KeyStatusNormal];
    [keyS setTitle:@"S" keyName:@"key_S" forStatus:KeyStatusShift];
    [contentView addSubview:keyS];
    
    //d
    keyD = [[NormalKeyView alloc] init];
    [keyD setTitle:@"d" keyName:@"key_d" forStatus:KeyStatusNormal];
    [keyD setTitle:@"D" keyName:@"key_D" forStatus:KeyStatusShift];
    [contentView addSubview:keyD];
    
    //f
    keyF = [[NormalKeyView alloc] init];
    [keyF setTitle:@"f" keyName:@"key_f" forStatus:KeyStatusNormal];
    [keyF setTitle:@"F" keyName:@"key_F" forStatus:KeyStatusShift];
    [contentView addSubview:keyF];
    
    //g
    keyG = [[NormalKeyView alloc] init];
    [keyG setTitle:@"g" keyName:@"key_g" forStatus:KeyStatusNormal];
    [keyG setTitle:@"G" keyName:@"key_G" forStatus:KeyStatusShift];
    [contentView addSubview:keyG];
    
    //h
    keyH = [[NormalKeyView alloc] init];
    [keyH setTitle:@"h" keyName:@"key_h" forStatus:KeyStatusNormal];
    [keyH setTitle:@"H" keyName:@"key_H" forStatus:KeyStatusShift];
    [contentView addSubview:keyH];
    
    //j
    keyJ = [[NormalKeyView alloc] init];
    [keyJ setTitle:@"j" keyName:@"key_j" forStatus:KeyStatusNormal];
    [keyJ setTitle:@"J" keyName:@"key_J" forStatus:KeyStatusShift];
    [contentView addSubview:keyJ];
    
    //k
    keyK = [[NormalKeyView alloc] init];
    [keyK setTitle:@"k" keyName:@"key_k" forStatus:KeyStatusNormal];
    [keyK setTitle:@"K" keyName:@"key_K" forStatus:KeyStatusShift];
    [contentView addSubview:keyK];
    
    //l
    keyL = [[NormalKeyView alloc] init];
    [keyL setTitle:@"l" keyName:@"key_l" forStatus:KeyStatusNormal];
    [keyL setTitle:@"L" keyName:@"key_L" forStatus:KeyStatusShift];
    [contentView addSubview:keyL];
    
    //;
    keySemicolon = [[NormalKeyView alloc] init];
    [keySemicolon setTitle:@";" keyName:@"key_semicolon" forStatus:KeyStatusNormal];
    [keySemicolon setTitle:@":" keyName:@"key_semicolon_2" forStatus:KeyStatusShift];
    [contentView addSubview:keySemicolon];
    
    //'
    keyApostrophe = [[NormalKeyView alloc] init];
    [keyApostrophe setTitle:@"'" keyName:@"key_apostrophe" forStatus:KeyStatusNormal];
    [keyApostrophe setTitle:@"\"" keyName:@"key_apostrophe_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyApostrophe];
    
    //enter
    keyEnter = [[NormalKeyView alloc] init];
    [keyEnter setTitle:@"Enter" keyName:@"key_enter" forStatus:KeyStatusNormal];
    [contentView addSubview:keyEnter];
    
    //z
    keyZ = [[NormalKeyView alloc] init];
    [keyZ setTitle:@"z" keyName:@"key_z" forStatus:KeyStatusNormal];
    [keyZ setTitle:@"Z" keyName:@"key_Z" forStatus:KeyStatusShift];
    [contentView addSubview:keyZ];
    
    //x
    keyX = [[NormalKeyView alloc] init];
    [keyX setTitle:@"x" keyName:@"key_x" forStatus:KeyStatusNormal];
    [keyX setTitle:@"X" keyName:@"key_X" forStatus:KeyStatusShift];
    [contentView addSubview:keyX];
    
    //c
    keyC = [[NormalKeyView alloc] init];
    [keyC setTitle:@"c" keyName:@"key_c" forStatus:KeyStatusNormal];
    [keyC setTitle:@"C" keyName:@"key_C" forStatus:KeyStatusShift];
    [contentView addSubview:keyC];
    
    //v
    keyV = [[NormalKeyView alloc] init];
    [keyV setTitle:@"v" keyName:@"key_v" forStatus:KeyStatusNormal];
    [keyV setTitle:@"V" keyName:@"key_V" forStatus:KeyStatusShift];
    [contentView addSubview:keyV];
    
    //b
    keyB = [[NormalKeyView alloc] init];
    [keyB setTitle:@"b" keyName:@"key_b" forStatus:KeyStatusNormal];
    [keyB setTitle:@"B" keyName:@"key_B" forStatus:KeyStatusShift];
    [contentView addSubview:keyB];
    
    //n
    keyN = [[NormalKeyView alloc] init];
    [keyN setTitle:@"n" keyName:@"key_n" forStatus:KeyStatusNormal];
    [keyN setTitle:@"N" keyName:@"key_N" forStatus:KeyStatusShift];
    [contentView addSubview:keyN];
    
    //m
    keyM = [[NormalKeyView alloc] init];
    [keyM setTitle:@"m" keyName:@"key_m" forStatus:KeyStatusNormal];
    [keyM setTitle:@"M" keyName:@"key_M" forStatus:KeyStatusShift];
    [contentView addSubview:keyM];
    
    //,
    keyComma = [[NormalKeyView alloc] init];
    [keyComma setTitle:@"," keyName:@"key_comma" forStatus:KeyStatusNormal];
    [keyComma setTitle:@"<" keyName:@"key_comma_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyComma];
    
    //.
    keyDot = [[NormalKeyView alloc] init];
    [keyDot setTitle:@"." keyName:@"key_dot" forStatus:KeyStatusNormal];
    [keyDot setTitle:@">" keyName:@"key_dot_2" forStatus:KeyStatusShift];
    [contentView addSubview:keyDot];
    
    ///
    keySlash = [[NormalKeyView alloc] init];
    [keySlash setTitle:@"/" keyName:@"key_slash" forStatus:KeyStatusNormal];
    [keySlash setTitle:@"?" keyName:@"key_slash_2" forStatus:KeyStatusShift];
    [contentView addSubview:keySlash];
    
    //space
    keySpace = [[NormalKeyView alloc] init];
    [keySpace setTitle:@" " keyName:@"key_space" forStatus:KeyStatusNormal];
    [contentView addSubview:keySpace];
    
    //up
    keyUp = [[NormalKeyView alloc] init];
    [keyUp setTitle:@"Up" keyName:@"key_up" forStatus:KeyStatusNormal];
    [keyUp setTitle:@"PgUp" keyName:@"key_pgup" forStatus:KeyStatusFn];
    [contentView addSubview:keyUp];
    
    //down
    keyDown = [[NormalKeyView alloc] init];
    [keyDown setTitle:@"Down" keyName:@"key_down" forStatus:KeyStatusNormal];
    [keyDown setTitle:@"PgDn" keyName:@"key_pgdown" forStatus:KeyStatusFn];
    [contentView addSubview:keyDown];
    
    //left
    keyLeft = [[NormalKeyView alloc] init];
    [keyLeft setTitle:@"Left" keyName:@"key_left" forStatus:KeyStatusNormal];
    [keyLeft setTitle:@"Home" keyName:@"key_home" forStatus:KeyStatusFn];
    [contentView addSubview:keyLeft];
    
    //right
    keyRight = [[NormalKeyView alloc] init];
    [keyRight setTitle:@"Right" keyName:@"key_right" forStatus:KeyStatusNormal];
    [keyRight setTitle:@"End" keyName:@"key_end" forStatus:KeyStatusFn];
    [contentView addSubview:keyRight];
    
    //fn
    keyFn = [[StatusKeyView alloc] init];
    [keyFn setTitle:@"Fn"];
    [keyFn setKeySwitchListener:self selector:@selector(onKeyStatusChange:)];
    [contentView addSubview:keyFn];
    
    //shift
    keyShift = [[StatusKeyView alloc] init];
    [keyShift setTitle:@"Shift"];
    [keyShift setKeySwitchListener:self selector:@selector(onKeyStatusChange:)];
    [contentView addSubview:keyShift];
    
    //ctrl
    keyCtrl = [[StatusKeyView alloc] init];
    [keyCtrl setTitle:@"Ctrl"];
    [keyCtrl setKeySwitchListener:self selector:@selector(onKeyStatusChange:)];
    [contentView addSubview:keyCtrl];
    
    //alt
    keyAlt = [[StatusKeyView alloc] init];
    [keyAlt setTitle:@"Alt"];
    [keyAlt setKeySwitchListener:self selector:@selector(onKeyStatusChange:)];
    [contentView addSubview:keyAlt];
    
    //...
    keyOption = [[KeyView alloc] init];
    [keyOption setTitle:@"..."];
    [keyOption setTapEventCompleteListener:self selector:@selector(onOptionKey)];
    [contentView addSubview:keyOption];
    
    normalKeyArray = [NSArray arrayWithObjects:
                      keyEsc,
                      key1,
                      key2,
                      key3,
                      key4,
                      key5,
                      key6,
                      key7,
                      key8,
                      key9,
                      key0,
                      keyMinus,
                      keyEqual,
                      keyBackspace,
                      keyGrave,
                      keyQ,
                      keyW,
                      keyE,
                      keyR,
                      keyT,
                      keyY,
                      keyU,
                      keyI,
                      keyO,
                      keyP,
                      keyLeftBrace,
                      keyRightBrace,
                      keyBackSlash,
                      keyTab,
                      keyA,
                      keyS,
                      keyD,
                      keyF,
                      keyG,
                      keyH,
                      keyJ,
                      keyK,
                      keyL,
                      keySemicolon,
                      keyApostrophe,
                      keyEnter,
                      keyZ,
                      keyX,
                      keyC,
                      keyV,
                      keyB,
                      keyN,
                      keyM,
                      keyComma,
                      keyDot,
                      keySlash,
                      keySpace,
                      keyUp,
                      keyDown,
                      keyLeft,
                      keyRight,
                      nil];
    
    for (NormalKeyView* key in normalKeyArray) {
        [key setKeyListener:self selector:@selector(onKey:status:)];
        [key setTapEventCompleteListener:self selector:@selector(onKeyTapComplete)];
    }
}

- (void)resizeViews:(CGSize)winSize {
    contentView.frame = CGRectMake(KEY_MARGIN, KEY_MARGIN, self.frame.size.width - KEY_MARGIN * 2, self.frame.size.height - KEY_MARGIN * 2);
    [self resizeKeys];
}

- (void)resizeKeys {
    CGFloat width = contentView.frame.size.width;
    CGFloat smallKeyWidth = width / 14.2;
    CGFloat keyHeight = contentView.frame.size.height / 5;
    CGFloat smallMediumKeyWidth = smallKeyWidth * 1.2;   //backspace grave opt
    CGFloat mediumKeyWidth = (width - smallKeyWidth * 11) / 2;   //tab enter
    CGFloat mediumLargeKeyWidth = width - smallKeyWidth * 12;   //shift
    CGFloat largeKeyWidth = smallKeyWidth * 6;   //space
    CGFloat otherKeyWidth = (width - largeKeyWidth - 3 * smallKeyWidth - smallMediumKeyWidth) / 2;   //ctrl alt
    
    //  esc   1   2   3   4   5   6   7   8   9   0   -   =   del
    keyEsc.frame = CGRectMake(0, 0, smallKeyWidth, keyHeight);
    key1.frame = CGRectMake(smallKeyWidth, 0, smallKeyWidth, keyHeight);
    key2.frame = CGRectMake(smallKeyWidth * 2, 0, smallKeyWidth, keyHeight);
    key3.frame = CGRectMake(smallKeyWidth * 3, 0, smallKeyWidth, keyHeight);
    key4.frame = CGRectMake(smallKeyWidth * 4, 0, smallKeyWidth, keyHeight);
    key5.frame = CGRectMake(smallKeyWidth * 5, 0, smallKeyWidth, keyHeight);
    key6.frame = CGRectMake(smallKeyWidth * 6, 0, smallKeyWidth, keyHeight);
    key7.frame = CGRectMake(smallKeyWidth * 7, 0, smallKeyWidth, keyHeight);
    key8.frame = CGRectMake(smallKeyWidth * 8, 0, smallKeyWidth, keyHeight);
    key9.frame = CGRectMake(smallKeyWidth * 9, 0, smallKeyWidth, keyHeight);
    key0.frame = CGRectMake(smallKeyWidth * 10, 0, smallKeyWidth, keyHeight);
    keyMinus.frame = CGRectMake(smallKeyWidth * 11, 0, smallKeyWidth, keyHeight);
    keyEqual.frame = CGRectMake(smallKeyWidth * 12, 0, smallKeyWidth, keyHeight);
    keyBackspace.frame = CGRectMake(smallKeyWidth * 13, 0, smallMediumKeyWidth, keyHeight);
    
    //    `     q   w   e   r   t   y   u   i   o   p   [   ]   backslash
    keyGrave.frame = CGRectMake(0, keyHeight, smallMediumKeyWidth, keyHeight);
    keyQ.frame = CGRectMake(smallMediumKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyW.frame = CGRectMake(smallMediumKeyWidth + smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyE.frame = CGRectMake(smallMediumKeyWidth + 2 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyR.frame = CGRectMake(smallMediumKeyWidth + 3 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyT.frame = CGRectMake(smallMediumKeyWidth + 4 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyY.frame = CGRectMake(smallMediumKeyWidth + 5 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyU.frame = CGRectMake(smallMediumKeyWidth + 6 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyI.frame = CGRectMake(smallMediumKeyWidth + 7 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyO.frame = CGRectMake(smallMediumKeyWidth + 8 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyP.frame = CGRectMake(smallMediumKeyWidth + 9 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyLeftBrace.frame = CGRectMake(smallMediumKeyWidth + 10 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyRightBrace.frame = CGRectMake(smallMediumKeyWidth + 11 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    keyBackSlash.frame = CGRectMake(smallMediumKeyWidth + 12 * smallKeyWidth, keyHeight, smallKeyWidth, keyHeight);
    
    //   tab     a   s   d   f   g   h   j   k   l   ;   '   enter
    keyTab.frame = CGRectMake(0, keyHeight * 2, mediumKeyWidth, keyHeight);
    keyA.frame = CGRectMake(mediumKeyWidth, keyHeight * 2, smallKeyWidth, keyHeight);
    keyS.frame = CGRectMake(mediumKeyWidth + smallKeyWidth, keyHeight * 2, smallKeyWidth, keyHeight);
    keyD.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 2, keyHeight * 2, smallKeyWidth, keyHeight);
    keyF.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 3, keyHeight * 2, smallKeyWidth, keyHeight);
    keyG.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 4, keyHeight * 2, smallKeyWidth, keyHeight);
    keyH.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 5, keyHeight * 2, smallKeyWidth, keyHeight);
    keyJ.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 6, keyHeight * 2, smallKeyWidth, keyHeight);
    keyK.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 7, keyHeight * 2, smallKeyWidth, keyHeight);
    keyL.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 8, keyHeight * 2, smallKeyWidth, keyHeight);
    keySemicolon.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 9, keyHeight * 2, smallKeyWidth, keyHeight);
    keyApostrophe.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 10, keyHeight * 2, smallKeyWidth, keyHeight);
    keyEnter.frame = CGRectMake(mediumKeyWidth + smallKeyWidth * 11, keyHeight * 2, mediumKeyWidth, keyHeight);
    
    //   shift    z   x   c   v   b   n   m   ,   .   /   up   fn
    keyShift.frame = CGRectMake(0, keyHeight * 3, mediumLargeKeyWidth, keyHeight);
    keyZ.frame = CGRectMake(mediumLargeKeyWidth, keyHeight * 3, smallKeyWidth, keyHeight);
    keyX.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth, keyHeight * 3, smallKeyWidth, keyHeight);
    keyC.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 2, keyHeight * 3, smallKeyWidth, keyHeight);
    keyV.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 3, keyHeight * 3, smallKeyWidth, keyHeight);
    keyB.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 4, keyHeight * 3, smallKeyWidth, keyHeight);
    keyN.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 5, keyHeight * 3, smallKeyWidth, keyHeight);
    keyM.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 6, keyHeight * 3, smallKeyWidth, keyHeight);
    keyComma.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 7, keyHeight * 3, smallKeyWidth, keyHeight);
    keyDot.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 8, keyHeight * 3, smallKeyWidth, keyHeight);
    keySlash.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 9, keyHeight * 3, smallKeyWidth, keyHeight);
    keyUp.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 10, keyHeight * 3, smallKeyWidth, keyHeight);
    keyFn.frame = CGRectMake(mediumLargeKeyWidth + smallKeyWidth * 11, keyHeight * 3, smallKeyWidth, keyHeight);
    
    //   ctrl    alt           spack           ...   lt   dn   rt
    keyCtrl.frame = CGRectMake(0, keyHeight * 4, otherKeyWidth, keyHeight);
    keyAlt.frame = CGRectMake(otherKeyWidth, keyHeight * 4, otherKeyWidth, keyHeight);
    keySpace.frame = CGRectMake(otherKeyWidth * 2, keyHeight * 4, largeKeyWidth, keyHeight);
    keyOption.frame = CGRectMake(otherKeyWidth * 2 + largeKeyWidth, keyHeight * 4, smallMediumKeyWidth, keyHeight);
    keyLeft.frame = CGRectMake(otherKeyWidth * 2 + largeKeyWidth + smallMediumKeyWidth, keyHeight * 4, smallKeyWidth, keyHeight);
    keyDown.frame = CGRectMake(otherKeyWidth * 2 + largeKeyWidth + smallMediumKeyWidth + smallKeyWidth, keyHeight * 4, smallKeyWidth, keyHeight);
    keyRight.frame = CGRectMake(otherKeyWidth * 2 + largeKeyWidth + smallMediumKeyWidth + smallKeyWidth * 2, keyHeight * 4, smallKeyWidth, keyHeight);
}

- (void)refershNormalKeysStatus {
    KeyStatus s = 0;
    if (keyFn.switchStatus == KeySwitchOn || keyFn.switchStatus == KeySwitchOnLock) {
        s |= KeyStatusFn;
    }
    if (keyShift.switchStatus == KeySwitchOn || keyShift.switchStatus == KeySwitchOnLock) {
        s |= KeyStatusShift;
    }
    if (keyCtrl.switchStatus == KeySwitchOn || keyCtrl.switchStatus == KeySwitchOnLock) {
        s |= KeyStatusCtrl;
    }
    if (keyAlt.switchStatus == KeySwitchOn || keyAlt.switchStatus == KeySwitchOnLock) {
        s |= KeyStatusAlt;
    }
    for (NormalKeyView* key in normalKeyArray) {
        [key setStatus:s];
    }
}

- (void)onKey:(NSString*)code status:(NSNumber*)status {
    if ([keyCodeListener respondsToSelector:keyCodeSelector]) {
        [keyCodeListener performSelector:keyCodeSelector withObject:code withObject:status];
    }
}

- (void)onKeyTapComplete {
    if (keyFn.switchStatus == KeySwitchOn) {
        keyFn.switchStatus = KeySwitchOff;
    }
    if (keyShift.switchStatus == KeySwitchOn) {
        keyShift.switchStatus = KeySwitchOff;
    }
    if (keyCtrl.switchStatus == KeySwitchOn) {
        keyCtrl.switchStatus = KeySwitchOff;
    }
    if (keyAlt.switchStatus == KeySwitchOn) {
        keyAlt.switchStatus = KeySwitchOff;
    }
    [self refershNormalKeysStatus];
}

- (void)onKeyStatusChange:(KeyStatus)status {
    [self refershNormalKeysStatus];
}

- (void)onOptionKey {
    if ([optionKeyListener respondsToSelector:optionKeySelector]) {
        [optionKeyListener performSelector:optionKeySelector withObject:@"option"];
    }
}

@end
