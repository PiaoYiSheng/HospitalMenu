//
//  ExclusiveSourceView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  专属来源
#define columns 4   // 列数
#define promptLableH 30
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

#import "ExclusiveSourceView.h"
@interface ExclusiveSourceView()
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) NSMutableArray *selectExclusiveSourceArray;
@property (nonatomic, strong) NSArray *exclusiveArray;
@property (nonatomic, strong) UIColor *selectTitleColor;
@end
@implementation ExclusiveSourceView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectTitleColor = selectColor;
    }
    return self;
}
-(void)setExclusiveSourceArray:(NSArray *)exclusiveSourceArray{
    
    if (exclusiveSourceArray.count == 0) {
        return;
    }
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.exclusiveArray = exclusiveSourceArray;
    [self addPromptLabel];
    [self loopToCreateButtons:exclusiveSourceArray];
}

-(void)setTitleColor:(UIColor *)titleColor{
    self.selectTitleColor = titleColor;
    for (UIButton *button in self.subviews) {
        if (button.tag > 0 && button.tag < self.subviews.count) {
            [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
        }
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.promptLabel.frame = CGRectMake(0, 0, self.bounds.size.width, promptLableH);
}

#pragma 添加提示
-(void)addPromptLabel{
    [self addSubview:self.promptLabel];
}

#pragma 循环创建分类
-(void)loopToCreateButtons:(NSArray *)array{
    CGFloat marginTop = 15;
    CGFloat marginLeft = 19;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat buttonW = (window.frame.size.width - (columns+1) *marginLeft) / columns;
    CGFloat buttonH = 24;
    
    CGFloat oneX = marginLeft;
    CGFloat oneY = promptLableH+marginTop;
    
    for (int i = 0; i < array.count; i++) {
        int col = i % columns;
        int row = i / columns;
        CGFloat x = oneX + col *(buttonW +marginLeft);
        CGFloat y = oneY +row *(buttonH +marginTop);
        NSString *buttonTitle = array[i];
        UIButton *button = [self addButtonTitle:buttonTitle];
        button.titleLabel.font = defaultButtonTitleFont;
        button.tag = i+1;
        button.frame = CGRectMake(x, y, buttonW, buttonH);
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 3;
        button.layer.borderColor = [defaultColor CGColor];
        if (i == 0 || i == array.count - 1) {
            UIImage *image = [UIImage imageNamed:@"专属标志@2x.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(1, 1, 15, 15);
            [button addSubview:imageView];
        }
        if (i == array.count -1) {            
            CGFloat h = CGRectGetMaxY(button.frame) + marginTop;
            self.height = h;
            
            UIView *dividerView = [[UIView alloc] init];
            dividerView.backgroundColor = LColorFromRGB(0xf2f2f0);
            dividerView.frame = CGRectMake(0, h - 1, window.bounds.size.width, 1);
            [self addSubview:dividerView];
        }
    }
}
#pragma button点击
-(void)click:(UIButton *)button{
    if (button.selected) {
        button.selected = NO;
        button.layer.borderColor = [defaultColor CGColor];
        NSString *selectClassStr = self.exclusiveArray[button.tag -1];
        [self.selectExclusiveSourceArray removeObject:selectClassStr];
    } else {
        button.selected = YES;
        button.layer.borderColor = [self.selectTitleColor CGColor];
        NSString *selectClassStr = self.exclusiveArray[button.tag -1];
        [self.selectExclusiveSourceArray addObject:selectClassStr];
    }
    self.returnsExclusiveSourceArray = self.selectExclusiveSourceArray;
}
#pragma 创建按钮方法
-(UIButton *)addButtonTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [[UIColor grayColor] CGColor];
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:defaultColor forState:UIControlStateNormal];
    [button setTitleColor:self.selectTitleColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    return button;
}
-(void)dissmiss{
    [self removeFromSuperview];
}

#pragma 懒加载
-(UILabel *)promptLabel{
    if (_promptLabel == nil) {
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.text = @"   专属来源";
        self.promptLabel.textColor = LColorFromRGB(0x474747);
        self.promptLabel.font = [UIFont systemFontOfSize:15];
        self.promptLabel.backgroundColor = LColorFromRGB(0xf2f2f0);
    }
    return _promptLabel;
}
-(NSMutableArray *)selectExclusiveSourceArray{
    if (_selectExclusiveSourceArray == nil) {
        self.selectExclusiveSourceArray = [NSMutableArray array];
    }
    return _selectExclusiveSourceArray;
}
-(NSArray *)exclusiveArray{
    if (_exclusiveArray == nil) {
        self.exclusiveArray = [NSArray array];
    }
    return _exclusiveArray;
}


@end
