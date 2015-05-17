//
//  CategoryMenuView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "CategoryMenuView.h"

#define BUTTON_HEIGHT   50

@interface CategoryMenuView ()
@property (nonatomic,strong) UIButton *categoryButn;

@end

@implementation CategoryMenuView


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.opaque = YES;
//    self.alpha = 0.6;
    [self initViews];
    [self hideMenu];
}


- (void)initViews
{
    NSArray *names = @[ STR_CATEGORY_SHOUYE,STR_CATEGORY_LVYOU,STR_CATEGORY_MEISHI,STR_CATEGORY_YOUXI,STR_CATEGORY_GOUWU,STR_CATEGORY_FENGJING,STR_CATEGORY_SHUMA,STR_CATEGORY_JIANZHU,STR_CATEGORY_FUSHI,STR_CATEGORY_JIAOTONG,STR_CATEGORY_QITA];
    
    for ( int i = 0; i<names.count; i++)
    {
        UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cateBtn.frame = CGRectMake(ScreenX, (BUTTON_HEIGHT+1) * i, self.frame.size.width, BUTTON_HEIGHT);
        
//        [cateBtn setImage:[UIImage imageNamed: IMG_mine_p] forState:UIControlStateNormal];
//        [cateBtn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
        cateBtn.tag = i;
//        cateBtn.titleLabel.text = @"sss";//names[i];
        [cateBtn setTitle:names[i] forState:UIControlStateNormal];
//        cateBtn.titleLabel.textColor = [UIColor whiteColor];
        [cateBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//        cateBtn.backgroundColor = [UIColor darkGrayColor];
//        cateBtn.alpha = 1;
//        cateBtn.opaque = YES;
        [cateBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cateBtn];
    }

}

- (void)hideMenu
{

    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.frame.origin.x - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);

    } completion:^(BOOL finished){
        self.hidden = YES;
    }];
}

- (void)showMenu
{
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished){}];

}

- (void)buttonPressed:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCategoryMenuButonTouched:withTouchEventType:)])
    {
        [self.delegate onCategoryMenuButonTouched:button withTouchEventType:(ECategoryMenuButonTouchEventType)button.tag];
        
    }
}

@end
