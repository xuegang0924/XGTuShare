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
    
    //加入水平分割view
    UIImageView *seperateHImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_H]];
    seperateHImageView.frame = CGRectMake(0, _userCountView.frame.size.height, ScreenWidth, 3);
    [self addSubview:seperateHImageView];
    
    [self setupLikeOthersView];
    
    //加入垂直分割view
    UIImageView *seperateVImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
    seperateVImageView1.frame = CGRectMake(_likeOthersView.frame.size.width, _likeOthersView.frame.origin.y + 10, 3, _likeOthersView.frame.size.height - 20);
    [self addSubview:seperateVImageView1];
    
    [self setupLikeMeView];
    
    //加入水平分割view
    UIImageView *seperateHImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_H]];
    seperateHImageView2.frame = CGRectMake(0, _likeOthersView.frame.origin.y +_likeOthersView.frame.size.height , ScreenWidth, 3);
    [self addSubview:seperateHImageView2];
    
    [self setupColectView];
    
    //加入垂直分割view
    UIImageView *seperateVImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
    seperateVImageView2.frame = CGRectMake(_colectView.frame.size.width, _colectView.frame.origin.y + 10, 3, _colectView.frame.size.height - 20);
    [self addSubview:seperateVImageView2];
    [self setupPublishedView];
    
    //加入水平分割view
    UIImageView *seperateHImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_H]];
    seperateHImageView3.frame = CGRectMake(0, _publishedView.frame.origin.y +_publishedView.frame.size.height , ScreenWidth, 3);
    [self addSubview:seperateHImageView3];
    
    [self setupSettingsView];
    
    //加入垂直分割view
    UIImageView *seperateVImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
    seperateVImageView3.frame = CGRectMake(_settingsView.frame.size.width, _settingsView.frame.origin.y + 10, 3, _settingsView.frame.size.height - 40);
    [self addSubview:seperateVImageView3];

    [self setupMoreInfoView];
    
    //加入水平分割view
//    for (int i = 0; i<3; i++) {
//        UIImageView *seperateHImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
//        seperateHImageView.frame = CGRectMake(0, ScreenHeight/4*(i+1)+2, ScreenWidth, 3);
//        [self addSubview:seperateHImageView];
//    }

    
//    UIImageView *seperateHImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
//    seperateHImageView2.frame = CGRectMake(0, ScreenHeight/4*2 + 2, ScreenWidth, 3);
//    [self addSubview:seperateHImageView2];
//    
//    UIImageView *seperateHImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SEPERATE_V]];
//    seperateHImageView3.frame = CGRectMake(0, ScreenHeight/4 *3 +2, ScreenWidth, 3);
//    [self addSubview:seperateHImageView3];
}

-(void)setupUserCountentSubView
{
    _userCountView = [[UserCountSubView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, vUserCountViewHeight)];
    [self addSubview:_userCountView];
}

-(void)setupLikeOthersView
{
    _likeOthersView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LIKEOTHERS]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/2, ScreenHeight/4/2);
    imgView.center = CGPointMake(_likeOthersView.center.x, imgView.center.y);
    
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [_likeOthersView addSubview:imgView];
    

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_likeOthersView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"我喜欢的人"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_likeOthersView addSubview:label];
    
    
    _likeOthersView.backgroundColor = [UIColor clearColor];
    [self addSubview:_likeOthersView];
}

-(void)setupLikeMeView
{
    _likeMeView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_LIKEME]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/2, ScreenHeight/4/2);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.center = CGPointMake(_likeMeView.center.x , 200);
//    NSLog(@"%f  %f",_likeMeView.center.x,_likeMeView.center.y);
    [_likeMeView addSubview:imgView];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_likeMeView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"喜欢我的人"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_likeOthersView addSubview:label];
    
    _likeMeView.backgroundColor = [UIColor clearColor];

    [self addSubview:_likeMeView];
    
}

-(void)setupColectView
{
    _colectView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight+ScreenHeight/4, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_COLECT]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/2, ScreenHeight/4/2);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.center = CGPointMake(_colectView.center.x, imgView.center.y);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_colectView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"我的收藏"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_colectView addSubview:label];
    
    [_colectView addSubview:imgView];
    _colectView.backgroundColor = [UIColor clearColor];

    [self addSubview:_colectView];
    
}

-(void)setupPublishedView
{
    _publishedView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight+ScreenHeight/4, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_PULISHED]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/2, ScreenHeight/4/2);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.center = CGPointMake(_publishedView.center.x, imgView.center.y);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_publishedView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"我的发布"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_publishedView addSubview:label];
    
    [_publishedView addSubview:imgView];
    _publishedView.backgroundColor = [UIColor clearColor];

    [self addSubview:_publishedView];
    
}

-(void)setupSettingsView
{
    _settingsView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, vUserCountViewHeight+ScreenHeight/4*2, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_SETTING]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/2, ScreenHeight/4/2);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.center = CGPointMake(_settingsView.center.x, imgView.center.y);

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_settingsView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"设置"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_settingsView addSubview:label];
    
    [_settingsView addSubview:imgView];
    _settingsView.backgroundColor = [UIColor clearColor];

    [self addSubview:_settingsView];
    
}

-(void)setupMoreInfoView
{
    _moreInfoView = [[UIView alloc] initWithFrame:CGRectMake(vSubViewWidth, vUserCountViewHeight+ScreenHeight/4*2, ScreenWidth/2, ScreenHeight/4)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:IMG_MOREINFO]];
    imgView.frame = CGRectMake(0, 0, ScreenWidth/2/4, ScreenHeight/4/4);
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
//    imgView.center = CGPointMake(_moreInfoView.center.x, imgView.center.y);

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.center = CGPointMake(_moreInfoView.center.x, label.center.y+imgView.frame.size.height);
    [label setText:@"更多内容"];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:20]];
    [_moreInfoView addSubview:label];
    
    [_moreInfoView addSubview:imgView];
    _moreInfoView.backgroundColor = [UIColor clearColor];
    [self addSubview:_moreInfoView];
    
}















@end
