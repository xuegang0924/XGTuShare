//
//  DetailArticleContentTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailArticleContentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLable;

+ (DetailArticleContentTableViewCell*) articleDetailsContentCell;
@end
