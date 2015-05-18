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

#define TABBAR_BUTTON_NUM   3
#define TABBAR_HEIGHT       50

@interface MainViewController ()

@property(nonatomic,strong)UIButton *selectedButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBar) name:kSendShowTabBarMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBar) name:kSendHideTabBarMessage object:nil];

    self.view.backgroundColor = [UIColor clearColor];
    
    //设置tabbar为透明
    self.tabBarController.view.backgroundColor = [UIColor clearColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] == NSOrderedAscending) {
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:127.0/255.0 green:186.0/255.0 blue:235.0/255.0 alpha:1.0]];
        [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
        //上面两个是清除item的背景色跟选中背景色
        
    }
    
    [self _initViewControllers];
    [self _initTabbarView];
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
//    self.tabBarView.hidden = YES;
//    self.tabBar.hidden = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, ScreenHeight-TABBAR_HEIGHT, ScreenWidth, TABBAR_HEIGHT)];
//    _tabBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    _tabBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:_tabBarView];

    
    NSArray *tabBarImgs = @[IMG_recommend_n,IMG_find_n,IMG_mine_n];
    NSArray *highlightImgs = @[IMG_recommend_p,IMG_find_p,IMG_mine_p];
    
    for (int i = 0 ; i < tabBarImgs.count; i++)
    {
        NSString *strTabBarImg = tabBarImgs[i];
        NSString *strHighlightImg = highlightImgs[i];
        
        UIImage *tabImg = [UIImage imageNamed:strTabBarImg];
        UIImage *highImg = [UIImage imageNamed:strHighlightImg];
        
        UIButton *tabButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX+i*(ScreenWidth/3.0)+30, 0, TABBAR_HEIGHT+12, TABBAR_HEIGHT)];
//        tabButn.center = CGPointMake(ScreenWidth/4.0 * i , 0);
        [tabButn setImage:tabImg forState:UIControlStateNormal];
//        [tabButn setImage:highImg forState:UIControlStateHighlighted];
        [tabButn setImage:highImg forState:UIControlStateSelected];
        tabButn.tag = i;
        [tabButn addTarget:self action:@selector(tabBarSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tabButn showsTouchWhenHighlighted];
        tabButn.backgroundColor = [UIColor clearColor];
        [_tabBarView addSubview:tabButn];
    }
    
}

- (void)tabBarSelected:(UIButton *)button
{
    self.selectedIndex = button.tag;
    _selectedButton = button;
    
    
    NSArray *buttons = self.tabBarView.subviews;
    for (id btn in buttons) {
        if (btn && [btn isKindOfClass:[UIButton class]]) {
            ((UIButton *)btn).selected = NO;
        }
    }
    
    button.selected = YES;
}

- (void)hideTabBar {

    [UIView animateWithDuration:0.4 animations:^{
        self.tabBar.hidden = YES;
        self.tabBarView.hidden = YES;
    }];

}


- (void)showTabBar
{
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBar.hidden = NO;
        self.tabBarView.hidden = NO;
    }];

}

@end
