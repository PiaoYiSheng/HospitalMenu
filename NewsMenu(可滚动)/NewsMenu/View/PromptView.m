//
//  PromptView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//  提示视图

#import "PromptView.h"
#define LColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface PromptView()
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIView *dividerView;
@end
@implementation PromptView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.promptLabel = [[UILabel alloc] init];
        self.promptLabel.text = @"请选择需要添加的分类";
        self.promptLabel.textColor = LColorFromRGB(0x474747);
        self.promptLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.promptLabel];
        
        self.dividerView = [[UIView alloc] init];
        self.dividerView.backgroundColor = LColorFromRGB(0xcccccc);
        [self addSubview:self.dividerView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.promptLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height -1);
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    CGFloat viewX = self.promptLabel.frame.origin.x;
    CGFloat viewY = self.promptLabel.frame.size.height;
    CGFloat viewW = window.frame.size.width - viewX;
    self.dividerView.frame = CGRectMake(viewX, viewY, viewW, 1);
}

-(void)dissmiss{
    [self removeFromSuperview];
}

@end
