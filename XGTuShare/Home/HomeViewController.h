//
//  HomeViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView1;
@end
