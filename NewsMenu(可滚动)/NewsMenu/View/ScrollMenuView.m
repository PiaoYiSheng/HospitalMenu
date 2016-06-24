//
//  ScrollMenuView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  滚动页面
#define ResponseTag  3330 // tag值基准
#import "ScrollMenuView.h"

#warning 测试视图
#import "NewsView.h"
@interface ScrollMenuView()<UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, assign) CGFloat windowW;
@property (nonatomic, strong) NSArray *receivedNewsArray;
@end
@implementation ScrollMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.text = @"请检查您的网络";
        self.promptLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.promptLabel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNavigationMenu:) name:@"NavigationMenu" object:nil];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat y = self.bounds.size.height *0.5 - 30;
    self.promptLabel.frame = CGRectMake(0, y, self.bounds.size.width, 30);
}

#pragma 设置滚动高度
-(void)setHeight:(CGFloat)height{
    int i = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat w = window.bounds.size.width;
    for (UIView *view in self.subviews) {
        view.frame = CGRectMake(i *w, 0, w, height);
        i++;
    }
}

#pragma 接收导航栏通知
-(void)receiveNavigationMenu:(NSDictionary *)dict{
    NSDictionary *dic = [dict valueForKey:@"userInfo"];
    NSString *keyTag = [NSString stringWithFormat:@"%@",dic[@"NavigationMenuKey"]];
    NSInteger tag = [keyTag integerValue];
    CGFloat x = self.windowW *(tag -1);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = CGPointMake(x, 0);
    }];
    
}

#pragma delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger tag = offsetX / self.windowW;
    
    NSString *tagStr = [NSString stringWithFormat:@"%ld",tag];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:tagStr forKey:@"scrollViewKey"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollView" object:self userInfo:dict];
}


#pragma set
-(void)setNavigationMenuArray:(NSArray *)navigationMenuArray{
    self.receivedNewsArray = navigationMenuArray;
    if (navigationMenuArray.count == 0) {
        return;
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.contentSize = CGSizeMake(0, 0);
    [self setNewsViews:navigationMenuArray.count];
}

#pragma newsArray
-(void)setNewsArray:(NSArray *)newsArray{
    self.receivedNewsArray = newsArray;
}

#pragma 初始化新闻页
-(void)setNewsViews:(NSInteger )integer{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat w = window.bounds.size.width;
    CGFloat h = window.bounds.size.height;
    for (int i = 0; i < integer; i++) {
        NewsView *newsView = [[NewsView alloc] init];
        newsView.frame = CGRectMake(i *w, 0, w, h);
        newsView.newsArray = self.receivedNewsArray[i];
        [self addSubview:newsView];
    }
    self.contentSize = CGSizeMake(integer *w, 0);
}

#pragma 懒加载
-(CGFloat)windowW{
    if (_windowW == 0) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.windowW = window.frame.size.width;
    }
    return _windowW;
}
-(NSArray *)receivedNewsArray{
    if (_receivedNewsArray == nil) {
        self.receivedNewsArray = [NSArray array];
    }
    return _receivedNewsArray;
}
@end
