//
//  TopMenuView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "TopMenuView.h"

@implementation TopMenuView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self setOpaque:NO];
//    self.alpha = 0.4;
    self.hidden = YES;
    [self initViews];
    [self hideMenu];
}


- (void)initViews
{
    NSArray *names = @[ STR_CATEGORY_ZUIXIN,STR_CATEGORY_ZUIRE,STR_CATEGORY_FUJIN];
    
    for ( int i = 0; i<names.count; i++)
    {
        UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cateBtn.frame = CGRectMake(ScreenX+71*i, 0, 70, 50);
        
//        [cateBtn setImage:[UIImage imageNamed: IMG_mine_p] forState:UIControlStateNormal];
//        [cateBtn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
        cateBtn.tag = i;
        [cateBtn setTitle:names[i] forState:UIControlStateNormal];
//        cateBtn.titleLabel.textColor = [UIColor redColor];
        [cateBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cateBtn.backgroundColor = [UIColor clearColor];
        
        [cateBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cateBtn];
    }
    
}

- (void)hideMenu
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - self.frame.size.height , self.frame.size.width, self.frame.size.height);
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished){
        if (finished)
        {
            self.hidden = YES;
        }
    }];
}

- (void)showMenu
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.hidden = NO;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.frame.size.height);
        self.alpha = 1.0f;
    } completion:^(BOOL finished){}];
    
}

- (void)buttonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onTopMenuButonTouched:withTouchEventType:)])
    {
        [self.delegate onTopMenuButonTouched:button withTouchEventType:(ETopMenuButonTouchEventType)button.tag];
        
    }
}



@end
