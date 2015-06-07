//
//  DetailTableViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/5/18.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewModel.h"


@interface DetailTableViewController : UITableViewController


- (id)initWithModel:(ListViewModel *)model;
@end
