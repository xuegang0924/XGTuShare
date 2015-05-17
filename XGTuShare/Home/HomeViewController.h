//
//  HomeViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryMenuView.h"
#import "TopMenuView.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate ,CategoryMenuViewDelegate,TopMenuViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
