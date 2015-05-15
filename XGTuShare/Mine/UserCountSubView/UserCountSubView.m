//
//  UserCountSubView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/15.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "UserCountSubView.h"

@interface UserCountSubView ()

@property (nonatomic,strong) UIImageView *userHeadIconImageView;        //头像
@property (nonatomic,strong) UILabel *userNickNameLable;            //用户昵称
@property (nonatomic,strong) UILabel *userMoodLable;                //用户心情状态

@end

@implementation UserCountSubView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景
        self.backgroundColor = [UIColor clearColor];
        
        
        //头像
        _userHeadIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_USERHEAD]];
        _userHeadIconImageView.frame = CGRectMake(2, 2, 50, 50);
        [self addSubview:_userHeadIconImageView];
        
        //用户昵称
        _userNickNameLable = [[UILabel alloc] initWithFrame:CGRectMake(2, 55, 70, 20)];
        [_userNickNameLable setText:@"奋斗的牛"];
        _userNickNameLable.textColor = [UIColor greenColor];
        [self addSubview:_userNickNameLable];
        
        //用户心情状态
        _userMoodLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 50)];
        [_userMoodLable setText:@"今天天气不错，心情挺好哒！~"];
        _userMoodLable.textColor = [UIColor redColor];
        [self addSubview:_userMoodLable];
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

@end
