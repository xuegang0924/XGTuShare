//
//  HomeListTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewModel.h"

@interface HomeListTableViewCell : UITableViewCell
+ (HomeListTableViewCell*) getHomeListTableViewCell;

- (void)setupHomeListCellWithModel:(ListViewModel *)model;

@end
