//
//  MineSubView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/15.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "MineSubView.h"
#import "UserCountSubView.h"

#define vUserCountViewHeight    (ScreenHeight/4-20)
//#define vUserCountViewHeight    (ScreenHeight/4)
#define vSubViewWidth           (ScreenWidth/2)


@interface MineSubView()
@property (nonatomic,strong) UserCountSubView *userCountView;         //账号视图
@property (nonatomic,strong) UIView *likeOthersView;        //喜欢的人视图
@property (nonatomic,strong) UIView *likeMeView;            //喜欢我的人视图
@property (nonatomic,strong) UIView *colectView;            //收藏的文章视图
@property (nonatomic,strong) UIView *publishedView;         //发表的文章视图
@property (nonatomic,strong) UIView *settingsView;          //设置视图
@property (nonatomic,strong) UIView *moreInfoView;          //更多视图

@end

@implementation MineSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4F];
        [self setupSubViews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

-(void)setupSubViews
{
    [self setupUserCountentSubView];
    [self setupLikeOthersView];
    [self setupLikeMeView];
    [self setupColectView];
    [self setupPublishedView];
    [self setupSettingsView];
    [self setupMoreInfoView];
}

-(void)setupUserCountentSubView
{
    _userCountView = [[UserCountSubView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, vUserCountViewHeight)];
    [self addSubview:_userCountView];
}

-(void)setupLikeOthersView
{
    _likeOthersView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LIKEOTHERS]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_likeOthersView addSubview:imgView];
    
    _likeOthersView.backgroundColor = [UIColor clearColor];
    [self addSubview:_likeOthersView];
    
}

-(void)setupLikeMeView
{
    _likeMeView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LIKEME]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_likeMeView addSubview:imgView];
    
    _likeMeView.backgroundColor = [UIColor clearColor];

    [self addSubview:_likeMeView];
    
}

-(void)setupColectView
{
    _colectView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight*2, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_COLECT]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_colectView addSubview:imgView];
    _colectView.backgroundColor = [UIColor clearColor];

    [self addSubview:_colectView];
    
}

-(void)setupPublishedView
{
    _publishedView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight*2, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_PULISHED]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_publishedView addSubview:imgView];
    _publishedView.backgroundColor = [UIColor clearColor];

    [self addSubview:_publishedView];
    
}

-(void)setupSettingsView
{
    _settingsView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight*3, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SETTING]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_settingsView addSubview:imgView];
    _settingsView.backgroundColor = [UIColor clearColor];

    [self addSubview:_settingsView];
    
}

-(void)setupMoreInfoView
{
    _moreInfoView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight*3, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_MOREINFO]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2, ScreenHeight/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_moreInfoView addSubview:imgView];
    _moreInfoView.backgroundColor = [UIColor clearColor];
    [self addSubview:_moreInfoView];
    
}















@end
