//
//  DetailCommentNumberTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCommentNumberTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *commentNumLable;



+ (DetailCommentNumberTableViewCell*) articleDetailsCommentNumberCell;
@end
