//
//  NewsMenuView.h
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsMenuView : UIView
/** 分类*/
@property (nonatomic, strong) NSArray *classificationArray;
/** 专属*/
@property (nonatomic, strong) NSArray *exclusiveSourceArray;
/** 视图*/
@property (nonatomic, strong) NSArray *viewsArray;

/** 导航条文字及光标颜色 (默认是蓝色)*/
@property (nonatomic, strong) UIColor *titleColor;

@end
