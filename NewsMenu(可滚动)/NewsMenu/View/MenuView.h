//
//  MenuView.h
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuView;
@protocol MenuViewDelegate <NSObject>
- (void)dropdownMenu:(MenuView *)dropdownMenu didSelect:(BOOL)select;
@end

@interface MenuView : UIView
@property (nonatomic, strong) NSArray *menuButtons;
@property (nonatomic, assign) BOOL whetherToPut; // 是否收起菜单
/** 代理协议*/
@property (nonatomic, weak) id<MenuViewDelegate> delegate;
@property (nonatomic, strong) UIColor *titleColor;
@end
