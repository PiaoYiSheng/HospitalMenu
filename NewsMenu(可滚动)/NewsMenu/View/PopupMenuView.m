//
//  PopupMenuView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  弹出分类选项
#define columns 4   // 列数
#define LColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 默认色
#define defaultColor LColorFromRGB(0xcccccc)
// 选中色
#define selectColor LColorFromRGB(0x5ec4d6)
// 字体大小
#define defaultButtonTitleFont [UIFont systemFontOfSize:14]

#import "PopupMenuView.h"
#import "ExclusiveSourceView.h"
@interface PopupMenuView()
@property (nonatomic, strong) UIButton *allButton;
@property (nonatomic, strong) UIButton *healthCare;
@property (nonatomic, strong) NSArray *defaultArray;
@property (nonatomic, strong) NSArray *classArray;
@property (nonatomic, strong) NSArray *exclusiveSourceArray;
@property (nonatomic, strong) NSMutableArray *selectClassArray; // 选中的分类
@property (nonatomic, strong) UIColor *selectTitleColor;
@end
@implementation PopupMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectTitleColor = selectColor;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UILabel *lable = [[UILabel alloc] init];
        lable.text = @"请检查您的网络..";
        lable.textColor = [UIColor blackColor];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.frame = CGRectMake(0, 0, window.frame.size.width, 100);
        [self addSubview:lable];
        
        self.height = CGRectGetMaxY(lable.frame);
    }
    return self;
}
#pragma set
-(void)setClassificationArray:(NSArray *)classificationArray{
    if (classificationArray.count == 0) {
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.classArray = classificationArray;
    [self loopToCreateButtons:classificationArray];
}

-(void)setTitleColor:(UIColor *)titleColor{
    self.selectTitleColor = titleColor;
    for (UIButton *button in self.subviews) {
        if (button.tag > 0 && button.tag < self.subviews.count) {
            [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
        }
    }
}

#pragma 循环创建分类
-(void)loopToCreateButtons:(NSArray *)array{
    CGFloat marginTop = 15;
    CGFloat marginLeft = 19;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat buttonW = (window.frame.size.width - (columns+1) *marginLeft) / columns;
    CGFloat buttonH = 24;
    
    CGFloat oneX = marginLeft;
    CGFloat oneY = marginTop;
    
    for (int i = 0; i < array.count -1; i++) {
        int col = i % columns; // 对应的列
        int row = i / columns; // 对应的行
        
        CGFloat x = oneX + col *(buttonW +marginLeft);
        CGFloat y = oneY +row *(buttonH +marginTop);
        NSString *buttonTitle = array[i +1];
        UIButton *button = [self addButtonTitle:buttonTitle];
        button.tag = i+1;
        button.frame = CGRectMake(x, y, buttonW, buttonH);
        button.titleLabel.font = defaultButtonTitleFont;
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [defaultColor CGColor];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (i == array.count -2) {
            CGFloat h = CGRectGetMaxY(button.frame) + marginTop;
            self.height = h;
            
            UIView *dividerView = [[UIView alloc] init];
            dividerView.backgroundColor = LColorFromRGB(0xf2f2f0);
            dividerView.frame = CGRectMake(0, h - 1, window.bounds.size.width, 1);
            [self addSubview:dividerView];
        }
        if (i < 1) {
            NSString *str = array[i];
            [self.selectClassArray addObject:str];
        }
    }
}

#pragma button点击
-(void)click:(UIButton *)button{
    
    if (button.selected) {
        button.selected = NO;
        button.layer.borderColor = [defaultColor CGColor];
        NSString *selectClassStr = self.classArray[button.tag];
        [self.selectClassArray removeObject:selectClassStr];
    }else{
        button.selected = YES;
        button.layer.borderColor = [self.selectTitleColor CGColor];
        NSString *selectClassStr = self.classArray[button.tag];
        [self.selectClassArray addObject:selectClassStr];
    }
    self.returnsClassificationArray = self.selectClassArray;
}

#pragma 创建按钮方法
-(UIButton *)addButtonTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
    [self addSubview:button];
    
    return button;
}


#pragma 私有方法
-(NSString *)returnsString:(NSInteger)integer{
    NSString *str = [NSString stringWithFormat:@"%ld",integer];
    return str;
}
-(NSInteger )returnsInteger:(NSString *)string{
    NSInteger integer = [string integerValue];
    return integer;
}
#pragma 公开方法
-(void)dissmiss{
    [self removeFromSuperview];
}
#pragma 默认数组
-(NSArray *)defaultArray{
    if (_defaultArray == nil) {
        self.defaultArray = @[
                                     @"全部",
                                     @"医保",
                                     @"营养",
                                     @"健身",
                                     @"生活"
                                     ];
    }
    return _defaultArray;
}

-(NSArray *)classArray{
    if (_classArray == nil) {
        self.classArray = [NSArray array];
    }
    return _classArray;
}

-(NSMutableArray *)selectClassArray{
    if (_selectClassArray == nil) {
        self.selectClassArray = [NSMutableArray array];
    }
    return _selectClassArray;
}


@end
