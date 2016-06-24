//
//  ScrollMenuView.h
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollMenuView : UIScrollView
@property (nonatomic, strong) NSArray *navigationMenuArray;
@property (nonatomic, strong) NSArray *newsArray;
@property (nonatomic, assign) CGFloat height;
@end
