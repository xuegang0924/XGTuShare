//
//  DetailCommentsTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *commentUserHeadImageView;
@property (strong, nonatomic) IBOutlet UILabel *commentUserNickNameLable;
@property (strong, nonatomic) IBOutlet UILabel *commentContentLable;
@property (strong, nonatomic) IBOutlet UILabel *commentZanNumLable;
@property (strong, nonatomic) IBOutlet UILabel *commentCommentNumLable;




+ (DetailCommentsTableViewCell*) articleDetailsCommentsCell;
@end
