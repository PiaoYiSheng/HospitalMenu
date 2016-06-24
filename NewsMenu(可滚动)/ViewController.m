//
//  ViewController.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import "ViewController.h"
#import "NewsMenuView.h"
@interface ViewController ()
/** 分类数组*/
@property (nonatomic, strong) NSArray *classificationArray;
/** 专属数组*/
@property (nonatomic, strong) NSArray *exclusiveSourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //创建菜单栏
    NewsMenuView *newsMenu = [[NewsMenuView alloc] init];
    
    // 分类数组传入菜单
    newsMenu.classificationArray = self.classificationArray;
    // 专属数组传入菜单
    newsMenu.exclusiveSourceArray = self.exclusiveSourceArray;
    // 设置文字颜色
//    newsMenu.titleColor = [UIColor magentaColor];
    
    // 设置菜单栏位置大小
    newsMenu.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    // 将菜单栏添加到视图中
    [self.view addSubview:newsMenu];
 
}





#pragma 懒加载
-(NSArray *)classificationArray{
    if (_classificationArray == nil) {
        self.classificationArray = @[
                                     @"全部",
                                     @"医保",
                                     @"营养",
                                     @"健身",
                                     @"生活",
                                     @"老年",
                                     @"社保",
                                     ];
    }
    return _classificationArray;
}
-(NSArray *)exclusiveSourceArray{
    if (_exclusiveSourceArray == nil) {
        self.exclusiveSourceArray = @[
                                      @"301医院",
                                      @"丰台医院",
                                      @"北京医院",
                                      @"友谊医院"
                                      ];
    }
    return _exclusiveSourceArray;
}
@end
