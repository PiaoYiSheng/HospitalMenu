//
//  NewsView.m
//  NewsMenu(可滚动)
//
//  Created by ll mac pro on 15/12/3.
//  Copyright © 2015年 liulu. All rights reserved.
//
// 颜色
#define LColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define LRandomColor LColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#import "NewsView.h"
@interface NewsView()
@property (nonatomic, strong) UILabel *label;
@end
@implementation NewsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LRandomColor;
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.numberOfLines = 0;
        self.label.font = [UIFont systemFontOfSize:30];
        [self addSubview:self.label];
    }
    return self;
}

-(void)setNewsArray:(NSArray *)newsArray{
//    NSLog(@"news:%@",newsArray);
    self.label.text = [NSString stringWithFormat:@"%@\nNewsView类是我",newsArray];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = CGRectMake(0, 100, self.bounds.size.width, 200);
}
@end
