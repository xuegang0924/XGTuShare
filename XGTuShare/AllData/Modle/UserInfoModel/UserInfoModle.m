//
//  UserInfoModle.m
//  XGTuShare
//
//  Created by xuegang on 15/6/2.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "UserInfoModle.h"

#define kUserID         @"userID"
#define kUserName       @"userName"
#define kUserEmail      @"userEmail"
#define kUserPhone      @"userPhone"
#define kUserNickName   @"userNickName"
#define kUserHeadPortraitImageURL   @"userHeadPortraitImageURL"
#define kUserSex        @"userSex"
#define kUserAge        @"userAge"
#define kUserBirthday   @"userBirthday"
#define kUserCountrySide            @"userCountrySide"
#define kUserMindState  @"userMindState"
#define kUserSchool     @"userSchool"
#define kUserWorkplace  @"userWorkplace"
#define kUserHobby      @"userHobby"
#define kUserConstellation          @"userConstellation"
#define kUserFavorites  @"userFavorites"
#define kUserArticles   @"userArticles"
#define kUserFriends    @"userFriends"
#define kUserBeFriends  @"userBeFriends"

@implementation UserInfoModle


- (id)init
{
    self = [super init];
    if (self) {
        [self setInitProperty];
    }
    return self;
}

- (void)setInitProperty
{
    
    _userID = @"";
    _userName = @"";
    _userEmail = @"";
    _userPhone = @"";
    _userNickName = @"";
    _userHeadPortraitImageURL = @"";
    _userSex = @"";
    _userAge = @"";
    _userBirthday = @"";
    _userCountrySide = @"";
    _userMindState = @"";
    _userSchool= @"";
    _userWorkplace = @"";
    _userHobby = @"";
    _userConstellation = @"";

    _userFavorites = @"";
    _userArticles = @"";
    _userFriends = @"";
    _userBefriends = @"";

}

- (void)setupProperties:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return;
    }
    
    _userID = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserID]];
    _userName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserName]];
    _userEmail = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserEmail]];
    _userPhone = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserPhone]];
    _userNickName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserNickName]];
    _userHeadPortraitImageURL = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserHeadPortraitImageURL]];
    _userSex = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserSex]];
    _userAge = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserAge]];
    _userBirthday = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserBirthday]];
    _userCountrySide = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserCountrySide]];
    _userMindState = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserMindState]];
    _userSchool= [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserSchool]];
    _userWorkplace = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserWorkplace]];
    _userHobby = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserHobby]];
    _userConstellation = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserConstellation]];
    
    _userFavorites = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserFavorites]];
    _userArticles = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserArticles]];
    _userFriends = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserFriends]];
    _userBefriends = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kUserBeFriends]];
    
}


@end
