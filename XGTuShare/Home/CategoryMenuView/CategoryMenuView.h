//
//  CategoryMenuView.h
//  XGTuShare
//
//  Created by xuegang on 15/5/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eCategoryMenuButonTouchEventHome = 0,
    eCategoryMenuButonTouchEventTraval,
    eCategoryMenuButonTouchEventFood,
    eCategoryMenuButonTouchEventGame,
    eCategoryMenuButonTouchEventShop,
    eCategoryMenuButonTouchEventSene,
    eCategoryMenuButonTouchEventDigtle,
    eCategoryMenuButonTouchEventConstruct,
    eCategoryMenuButonTouchEventClose,
    eCategoryMenuButonTouchEventTrafic,
    eCategoryMenuButonTouchEventOther,
    
}ECategoryMenuButonTouchEventType;

@protocol  CategoryMenuViewDelegate<NSObject>

-(void)onCategoryMenuButonTouched:(UIButton *)button withTouchEventType:(ECategoryMenuButonTouchEventType)touchEventType;

@end


@interface CategoryMenuView : UIView
@property(nonatomic,assign)id<CategoryMenuViewDelegate> delegate;

- (void)showMenu;
- (void)hideMenu;
@end
