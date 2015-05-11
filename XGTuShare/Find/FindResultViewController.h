//
//  FindResultViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/5/10.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindResultViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) IBOutlet UIButton *backBtn;


- (id)initWithImage:(UIImage *)image;
@end
