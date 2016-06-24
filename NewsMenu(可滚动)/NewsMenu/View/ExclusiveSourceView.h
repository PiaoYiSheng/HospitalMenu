//
//  ExclusiveSourceView.h
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExclusiveSourceView : UIView

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSArray *exclusiveSourceArray;
@property (nonatomic, strong) NSMutableArray *returnsExclusiveSourceArray;
@property (nonatomic, strong) UIColor *titleColor;
-(void)dissmiss;
@end
