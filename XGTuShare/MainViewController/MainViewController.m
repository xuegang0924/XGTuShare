//
//  MainViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "FindViewController.h"
#import "MineViewController.h"
#import "BaseNavigationViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor greenColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) _initViewControllers
{
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    FindViewController *findVc = [[FindViewController alloc] init];
    MineViewController *mineVc = [[MineViewController alloc] init];
    
    NSArray *views = @[homeVc,findVc,mineVc];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (UIViewController *view in views) {
        BaseNavigationViewController *nav = [[BaseNavigationViewController alloc] initWithRootViewController:view];
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
    
}

- (void) _initTabbarView
{
    
}

@end
