//
//  MenuView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  导航栏
#define rightButtonTag 2000
#define LColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "MenuView.h"
#import "PromptView.h"
#import "NavigationMenuView.h"
@interface MenuView()
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) PromptView *promptView;
@property (nonatomic, strong) NavigationMenuView *navigationMenuView;
@property (nonatomic, strong) UIView *separatedView;
@end
@implementation MenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.whetherToPut = NO; // 不收起菜单
        
        // 初始化右按钮
        [self setRightButtons];
        
        // 初始化导航菜单
        [self setNavigationMenu];
        
        self.separatedView = [[UIView alloc] init];
        self.separatedView.backgroundColor = LColorFromRGB(0xf2f2f0);
        [self addSubview:self.separatedView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat rightButtonWH = self.bounds.size.height;
    CGFloat rightButtonX = self.bounds.size.width - rightButtonWH;
    self.rightButton.frame = CGRectMake(rightButtonX, 0, rightButtonWH, rightButtonWH);

    // 导航菜单
    self.navigationMenuView.frame = CGRectMake(0, 0, self.bounds.size.width - rightButtonWH, self.bounds.size.height);
    self.navigationMenuView.menuFrame = CGRectMake(0, 0, self.bounds.size.width - rightButtonWH, self.bounds.size.height);
    
    // 设置分割线frame
    self.separatedView.frame = CGRectMake(0, self.bounds.size.height -1, self.bounds.size.width, 1);
}

-(void)setMenuButtons:(NSArray *)menuButtons{
    self.navigationMenuView.navigationMenuArray = menuButtons;
}

-(void)setTitleColor:(UIColor *)titleColor{
    self.navigationMenuView.titleColor = titleColor;
}

#pragma 导航菜单
-(void)setNavigationMenu{
    [self addSubview:self.navigationMenuView];
}
#pragma 右按钮初始化
-(void)setRightButtons{
    self.rightButton = [[UIButton alloc] init];
    [self.rightButton setImage:[UIImage imageNamed:@"下拉icon默认.png"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"下拉icon点击.png"] forState:UIControlStateSelected];
    self.rightButton.tag = rightButtonTag;
    [self.rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
}

-(void)setWhetherToPut:(BOOL)whetherToPut{
    if (whetherToPut) {
        [self clickRightButton:self.rightButton];
    }
}
#pragma 右按钮点击事件
-(void)clickRightButton:(UIButton *)button{
    if (button.selected) {
        button.selected = NO;
        self.whetherToPut = NO;
        [self.promptView dissmiss];
    }else{
        button.selected = YES;
        self.promptView.frame = CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height);
        [self addSubview:self.promptView];
    }
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:didSelect:)]) {
        [self.delegate dropdownMenu:self didSelect:button.selected];
    }
}
#pragma 懒加载
-(PromptView *)promptView{
    if (_promptView == nil) {
        self.promptView = [[PromptView alloc] init];
    }
    return _promptView;
}
-(NavigationMenuView *)navigationMenuView{
    if (_navigationMenuView == nil) {
        self.navigationMenuView = [[NavigationMenuView alloc] init];
    }
    return _navigationMenuView;
}
@end
