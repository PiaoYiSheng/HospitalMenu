//
//  NewsMenuView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  整体控件
#define MenuViewH  43
#define DefaultPage 1
#define LColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "NewsMenuView.h"
#import "MenuView.h"
#import "ScrollMenuView.h"
#import "PopupMenuView.h"
#import "ExclusiveSourceView.h"
@interface NewsMenuView()<MenuViewDelegate>
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) ScrollMenuView *scrollMenu;
@property (nonatomic, strong) PopupMenuView *popMenuView;
@property (nonatomic, strong) ExclusiveSourceView *exclusiveSourceView;
@property (nonatomic, strong) NSMutableArray *navigationMenusArray;
@property (nonatomic, strong) NSArray *defaultArray; // 记录默认的数据
@property (nonatomic, strong) UIButton *completeButton; // 完成按钮
@property (nonatomic, strong) UIView *completeView; // 完成按钮视图
@property (nonatomic, assign) CGFloat completeViewY; // 完成视图高
@property (nonatomic, assign) BOOL withOrWithout; // 有无专属医院
@property (nonatomic, strong) UIColor *allTitleColor;
@end
@implementation NewsMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.allTitleColor = LColorFromRGB(0x5ec4d6);
        
        self.backgroundColor = [UIColor yellowColor];
        self.withOrWithout = NO;
        
        self.menuView = [[MenuView alloc] init];// 导航菜单
        self.menuView.delegate = self;
        [self addSubview:self.menuView];
        
        self.scrollMenu = [[ScrollMenuView alloc] init];// 滚动界面
        [self addSubview:self.scrollMenu];
    }
    return self;
}

#pragma set
-(void)setClassificationArray:(NSArray *)classificationArray{
    
    // 分类
    self.popMenuView.classificationArray = classificationArray;
    
    // 默认页
    NSMutableArray *defaultArray = [NSMutableArray array];
    for (int i = 0; i < DefaultPage; i++) {
        [defaultArray addObject:classificationArray[i]];
    }
    self.defaultArray = defaultArray;
    self.scrollMenu.navigationMenuArray = defaultArray;
}

#pragma 专属
-(void)setExclusiveSourceArray:(NSArray *)exclusiveSourceArray{
    if (exclusiveSourceArray.count > 0) {
        self.withOrWithout = YES;
    }
    self.exclusiveSourceView = [[ExclusiveSourceView alloc] init];
    self.exclusiveSourceView.exclusiveSourceArray = exclusiveSourceArray;
}

#pragma Delegate
-(void)dropdownMenu:(MenuView *)dropdownMenu didSelect:(BOOL)select{
    if (select) {
        [self setPopMenuView];
        [self setExclusiveSourceView];
        [self setCompleteButton];
    }else{
        [self.popMenuView dissmiss];
        [self.exclusiveSourceView dissmiss];
        [self.completeView removeFromSuperview];
    }
}

#pragma 标题颜色
-(void)setTitleColor:(UIColor *)titleColor{
    self.allTitleColor = titleColor;
    self.menuView.titleColor = titleColor;
    self.popMenuView.titleColor = titleColor;
    self.exclusiveSourceView.titleColor = titleColor;
}

#pragma 弹出分类
-(void)setPopMenuView{
    self.popMenuView.frame = CGRectMake(0, self.scrollMenu.frame.origin.y, self.scrollMenu.frame.size.width, self.popMenuView.height);
    self.completeViewY = CGRectGetMaxY(self.popMenuView.frame);
    [self addSubview:self.popMenuView];
}
#pragma 弹出专属来源
-(void)setExclusiveSourceView{
    CGFloat exclusiveY = CGRectGetMaxY(self.popMenuView.frame);
    CGFloat excusiveW = self.popMenuView.frame.size.width;
    CGFloat excusiveH = self.exclusiveSourceView.height;
    self.exclusiveSourceView.frame = CGRectMake(0, exclusiveY, excusiveW, excusiveH);
    if (self.withOrWithout) {
        self.completeViewY = CGRectGetMaxY(self.exclusiveSourceView.frame);
    }
    [self addSubview:self.exclusiveSourceView];
}
#pragma 弹出完成按钮
-(void)setCompleteButton{
    CGFloat marginTop = 30;
    CGFloat viewW = self.popMenuView.frame.size.width;
    CGFloat viewH = 2*marginTop + 40;

    self.completeView.frame = CGRectMake(0, self.completeViewY, viewW, viewH);
    [self addSubview:self.completeView];

    CGFloat buttonW = 159;
    CGFloat buttonH = 40;
    CGFloat buttonX = viewW*0.5 - buttonW *0.5;
    CGFloat buttonY = marginTop;
    self.completeButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
}
#pragma 点击完成
-(void)clickCompleteButton{
    NSArray *navigationMenusArray = self.navigationMenusArray;
    self.navigationMenusArray = nil;
    
    NSString *defaultString = self.defaultArray[0];
    
    if (self.popMenuView.returnsClassificationArray.count > 0) {
        for (NSString *str in self.popMenuView.returnsClassificationArray) {
            [self.navigationMenusArray addObject:str];
        }
    } else {
        [self.navigationMenusArray addObject:defaultString];
    }
    if (self.exclusiveSourceView.returnsExclusiveSourceArray.count > 0) {
        for (NSString *str in self.exclusiveSourceView.returnsExclusiveSourceArray) {
            [self.navigationMenusArray addObject:str];
        }
    }
    
    self.defaultArray = nil;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithObject:defaultString];
    self.defaultArray = mutableArray;
    
    if (![navigationMenusArray isEqualToArray:self.navigationMenusArray]) {
        self.menuView.menuButtons = self.navigationMenusArray;
        self.scrollMenu.navigationMenuArray = self.navigationMenusArray;
    }
    
    self.menuView.whetherToPut = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.menuView.frame = CGRectMake(0, 0, self.bounds.size.width, MenuViewH); // 导航菜单
    
    CGFloat scrollMenuY = self.menuView.frame.size.height;
    CGFloat scrollMenuW = self.menuView.frame.size.width;
    CGFloat scrollMenuH = self.frame.size.height - self.menuView.frame.size.height;
    self.scrollMenu.frame = CGRectMake(0, scrollMenuY, scrollMenuW, scrollMenuH); // 滚动视图
    self.scrollMenu.height = scrollMenuH;
}


#pragma 懒加载
-(PopupMenuView *)popMenuView{
    if (_popMenuView == nil) {
        self.popMenuView = [[PopupMenuView alloc] init];
    }
    return _popMenuView;
}

-(NSMutableArray *)navigationMenusArray{
    if (_navigationMenusArray == nil) {
        self.navigationMenusArray = [NSMutableArray array];
    }
    return _navigationMenusArray;
}
-(NSArray *)defaultArray{
    if (_defaultArray == nil) {
        self.defaultArray = [NSArray array];
    }
    return _defaultArray;
}

-(UIView *)completeView{
    if (_completeView == nil) {
        self.completeView = [[UIView alloc] init];
        self.completeView.backgroundColor = [UIColor whiteColor];
    }
    return _completeView;
}

-(UIButton *)completeButton{
    if (_completeButton == nil) {
        self.completeButton = [[UIButton alloc] init];
        self.completeButton.layer.cornerRadius = 3;
        self.completeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.completeButton setBackgroundColor:self.allTitleColor];
        [self.completeButton addTarget:self action:@selector(clickCompleteButton) forControlEvents:UIControlEventTouchUpInside];
        [self.completeView addSubview:self.completeButton];
    }
    return _completeButton;
}
@end
