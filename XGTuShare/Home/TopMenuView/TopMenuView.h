//
//  TopMenuView.h
//  XGTuShare
//
//  Created by xuegang on 15/5/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eTopMenuButonTouchEventHot = 0,
    eTopMenuButonTouchEventNew ,
    eTopMenuButonTouchEventNearby,
    
}ETopMenuButonTouchEventType;

@protocol  TopMenuViewDelegate<NSObject>

-(void)onTopMenuButonTouched:(UIButton *)button withTouchEventType:(ETopMenuButonTouchEventType)touchEventType;

@end

@interface TopMenuView : UIView
@property(nonatomic,assign)id<TopMenuViewDelegate> delegate;

- (void)showMenu;
- (void)hideMenu;

@end
