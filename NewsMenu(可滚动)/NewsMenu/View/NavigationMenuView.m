//
//  NavigationMenuView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  导航菜单
#define LeftSpacing 20 // 间距
#define NavigationViewH 2 // 导航提示条高度
#define NavigationViewW ButtonW - (2 *LeftSpacing)
#define NavigationTag 1111
#define ButtonW 81 // 按钮宽
#define MenuViewH  43 // 导航栏高度
#define LColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "NavigationMenuView.h"
@interface NavigationMenuView()
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, assign) CGFloat navigationViewY;
@property (nonatomic, assign) CGFloat offsetX;
@property (nonatomic, assign) NSInteger recordsSelectButton;
@property (nonatomic, strong) UIColor *naviTitleColor;
@end
@implementation NavigationMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.naviTitleColor = LColorFromRGB(0x5ec4d6);
        
        // 初始化按钮
        [self setButtons:self.frame buttons:nil];
        
        // 接收滚动通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationCenter:) name:@"scrollView" object:nil];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setSubviewsFrame];
}

#pragma 初始化frame
-(void)setSubviewsFrame{
    CGFloat buttonH = self.frame.size.height - 3;
    
    int i = 0;
    for (UIView *view in self.subviews) {
        if (view.tag >= 1 && view.tag <= self.subviews.count -1) {
            view.frame = CGRectMake(i*ButtonW, 0, ButtonW, buttonH);
        }
        i++;
    }
}

#pragma 接收通知
-(void)receiveNotificationCenter:(NSDictionary *)dict{
    NSDictionary *dic = [dict valueForKey:@"userInfo"];
    NSString *keyTag = [NSString stringWithFormat:@"%@",dic[@"scrollViewKey"]];
    NSInteger tag = [keyTag integerValue] +1;
    for (UIButton *button in self.subviews) {
        if (button.tag == tag) {
            [self click:button];
        }
    }
}

#pragma set
-(void)setNavigationMenuArray:(NSArray *)navigationMenuArray{
    if (navigationMenuArray.count == 0) {
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self setButtons:self.frame buttons:navigationMenuArray];
}
-(void)setTitleColor:(UIColor *)titleColor{
    self.naviTitleColor = titleColor;
    for (UIButton *button in self.subviews) {
        if (button.tag >= 1 && button.tag <= self.subviews.count -1) {
            [button setTitleColor:self.naviTitleColor forState:UIControlStateSelected];
        }
        if (button.tag == NavigationTag) {
            button.backgroundColor = self.naviTitleColor;
        }
    }
}

#pragma 获得self的frame
-(void)setMenuFrame:(CGRect)menuFrame{
    CGFloat buttonH = menuFrame.size.height - 4;
    self.navigationViewY = buttonH;
}

#pragma 添加按钮
-(void)setButtons:(CGRect )frame buttons:(NSArray *)array{
    NSArray *buttons = [NSArray array];
    if (array.count > 0) {
        buttons = array;
    } else {
        buttons = self.menuArray;
    }
    for (int i = 0; i < buttons.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = i +1;
    
        if (i == 0) {
            [button setTitle:@"全部" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        }else{
            [button setTitle:[NSString stringWithFormat:@"%@",buttons[i]] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        [button setTitleColor:LColorFromRGB(0x474747) forState:UIControlStateNormal];
         [button setTitleColor:self.naviTitleColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (button.tag == 1) {
            self.selectedButton = button;
            button.selected = YES;
        }
        self.contentSize = CGSizeMake(ButtonW*buttons.count +LeftSpacing, 0);
        self.contentOffset = CGPointMake(0, 0);
    }
    CGFloat buttonH = MenuViewH - 4;
    self.navigationViewY = buttonH;
    self.navigationView.frame = CGRectMake(LeftSpacing, self.navigationViewY, NavigationViewW, NavigationViewH);
    self.navigationView.backgroundColor = self.naviTitleColor;
    [self addSubview:self.navigationView];
    
}

#pragma 点击事件
-(void)click:(UIButton *)button{
    self.selectedButton.selected = NO;
    self.selectedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    button.selected = YES;
    self.selectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger tag = button.tag - 1;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.navigationView.frame = CGRectMake(LeftSpacing + tag *ButtonW, self.navigationViewY, NavigationViewW, NavigationViewH);
    }];
    NSString *tagStr = [NSString stringWithFormat:@"%ld",button.tag];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:tagStr forKey:@"NavigationMenuKey"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NavigationMenu" object:self userInfo:dict];
    
    // 计算偏移量
    [self obtainnavigationViewX:button];
}



#pragma 计算偏移量
#pragma 获取滚动条x值
-(void)obtainnavigationViewX:(UIButton *)button{

    NSInteger selectButton = button.frame.origin.x / ButtonW;
    NSInteger integer = self.subviews.count - 1;
    
    if (selectButton <= 2) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
        return;
    }
    
    if (selectButton == integer -1) {
        CGFloat lastOffsetX = ButtonW *(selectButton - 3);
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = CGPointMake(lastOffsetX, 0);
        }];
        return;
    }
    
    CGFloat rightX = ButtonW * (selectButton -2);
    CGFloat letfX = ButtonW *(selectButton -1);

    if (selectButton >= 3 && integer >3) {
        if (selectButton <= integer - 2) {
            if (selectButton > self.recordsSelectButton) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.contentOffset = CGPointMake(rightX, 0);
                }];
            } else {
                if (selectButton <= (integer -3)) {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.contentOffset = CGPointMake(letfX, 0);
                    }];
                }
            }
        }
    }
    self.offsetX = self.contentOffset.x;
    self.recordsSelectButton = selectButton;
}

#pragma 懒加载
-(UIView *)navigationView{
    if (_navigationView == nil) {
        self.navigationView = [[UIView alloc] init];
        self.navigationView.tag = NavigationTag;
    }
    return _navigationView;
}

-(NSArray *)menuArray{
    if (_menuArray == nil) {
        self.menuArray = @[@"全部"];
    }
    return _menuArray;
}
@end
