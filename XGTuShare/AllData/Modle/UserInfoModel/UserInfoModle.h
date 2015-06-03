//
//  UserInfoModle.h
//  XGTuShare
//
//  Created by xuegang on 15/6/2.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModle : NSObject


@property(nonatomic,strong)NSString *userID;                        //用户ID
@property(nonatomic,strong)NSString *userName;                      //用户姓名
@property(nonatomic,strong)NSString *userEmail;                     //用户email
@property(nonatomic,strong)NSString *userPhone;                     //用户电话号码
@property(nonatomic,strong)NSString *userNickName;                  //用户昵称
@property(nonatomic,strong)NSString *userHeadPortraitImageURL;      //用户头像
@property(nonatomic,strong)NSString *userSex;                       //用户性别
@property(nonatomic,strong)NSString *userAge;                       //用户年龄
@property(nonatomic,strong)NSString *userBirthday;                  //用户生日
@property(nonatomic,strong)NSString *userCountrySide;               //用户家乡
@property(nonatomic,strong)NSString *userMindState;                 //用户心情状态
@property(nonatomic,strong)NSString *userSchool;                    //用户学校
@property(nonatomic,strong)NSString *userWorkplace;                 //用户工作地点
@property(nonatomic,strong)NSString *userHobby;                     //用户爱好
@property(nonatomic,strong)NSString *userConstellation;             //用户星座

@property(nonatomic,strong)NSString *userFavorites;                  //用户收藏
@property(nonatomic,strong)NSString *userArticles;                   //用户发表的文章
@property(nonatomic,strong)NSString *userFriends;                     //用户的朋友们
@property(nonatomic,strong)NSString *userBefriends;                   //喜欢用户的朋友们


- (void)setupProperties:(NSDictionary *)dictionary;


@end
