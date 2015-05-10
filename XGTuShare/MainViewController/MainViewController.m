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
    _tabBarView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, ScreenHeight-TABBAR_HEIGHT, ScreenWidth, TABBAR_HEIGHT)];
//    _tabBarView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:_tabBarView];
    
    NSArray *tabBarImgs = @[IMG_recommend_n,IMG_find_n,IMG_mine_n];
    NSArray *highlightImgs = @[IMG_recommend_p,IMG_find_p,IMG_mine_p];
    
    for (int i = 0 ; i < tabBarImgs.count; i++)
    {
        NSString *strTabBarImg = tabBarImgs[i];
        NSString *strHighlightImg = highlightImgs[i];
        
        UIImage *tabImg = [UIImage imageNamed:strTabBarImg];
        UIImage *highImg = [UIImage imageNamed:strHighlightImg];
        
        UIButton *tabButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX+i*(ScreenWidth/3.0)+30, 0, TABBAR_HEIGHT+8, TABBAR_HEIGHT)];
//        tabButn.center = CGPointMake(ScreenWidth/4.0 * i , 0);
        [tabButn setImage:tabImg forState:UIControlStateNormal];
//        [tabButn setImage:highImg forState:UIControlStateHighlighted];
        [tabButn setImage:highImg forState:UIControlStateSelected];
        tabButn.tag = i;
        [tabButn addTarget:self action:@selector(tabBarSelected:) forControlEvents:UIControlEventTouchUpInside];
        [tabButn showsTouchWhenHighlighted];
        [_tabBarView addSubview:tabButn];
    }

//    UITabBarItem *tabbaritem = [UITabBarItem alloc] initWithTabBarSystemItem:UITabBar tag:<#(NSInteger)#>
//    NSArray *tabbaritems = nil;
//    self.tabBarController.tabBar.items = tabbaritems;
    
}

- (void)tabBarSelected:(UIButton *)button
{
    self.selectedIndex = button.tag;
    _selectedButton = button;
    button.highlighted = !button.highlighted;
//        button.selected = YES;
//    [self showViewController:[self.viewControllers objectAtIndex:button.tag-1] sender:nil];
}

- (void)hideTabBar {
//    if (self.tabBarController.tabBar.hidden == YES) {
//        return;
//    }
//    UIView *contentView;
//    if ( [[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] )
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//    else
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x,  contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height + self.tabBarController.tabBar.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBar.hidden = YES;
        self.tabBarView.hidden = YES;
    }];

}


- (void)showTabBar
{
//    if (self.tabBarController.tabBar.hidden == NO)
//    {
//        return;
//    }
//    UIView *contentView;
//    if ([[self.tabBarController.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]])
//
//        contentView = [self.tabBarController.view.subviews objectAtIndex:1];
//
//    else
//
//        contentView = [self.tabBarController.view.subviews objectAtIndex:0];
//    contentView.frame = CGRectMake(contentView.bounds.origin.x, contentView.bounds.origin.y,  contentView.bounds.size.width, contentView.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.tabBar.hidden = NO;
        self.tabBarView.hidden = NO;
    }];


    
}

@end
