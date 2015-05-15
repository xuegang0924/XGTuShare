//
//  MineSubView.h
//  XGTuShare
//
//  Created by xuegang on 15/5/15.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    UserCountViewTouchedEventType = 1,
    LikeOthersViewTouchedEventType,
    LikeMeViewTouchedEventType,
    ColectViewTouchedEventType,
    PublishedViewTouchedEventType,
    SettingsViewTouchedEventType,
    MoreInfoViewTouchedEventType,
    
}MineViewTouchEventType;


@protocol MineSubViewDelegate <NSObject>

//view视图点击事件回调
- (void)onSubViewtouched:(UIView *)subView withEventType:(MineViewTouchEventType)eventype;

@end

@interface MineSubView : UIView

@end
