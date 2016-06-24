//
//  PopupMenuView.h
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupMenuView : UIView

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *classificationArray;
@property (nonatomic, strong) NSMutableArray *returnsClassificationArray;
@property (nonatomic, strong) UIColor *titleColor;
-(void)dissmiss;
@end
