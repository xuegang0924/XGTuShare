//
//  DetailAuthorInfoTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailAuthorInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *authorHeadImageView;
@property (strong, nonatomic) IBOutlet UILabel *authorNickName;
@property (strong, nonatomic) IBOutlet UILabel *createTIme;
@property (strong, nonatomic) IBOutlet UILabel *createLocation;


+ (DetailAuthorInfoTableViewCell*) articleDetailsAuthorInfoCell;
@end
