//
//  HomeViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryMenuView.h"
#import "TopMenuView.h"
#import "FocusView.h"
#import "ListView.h"
#import "ListTableViewCell.h"
#import "MJRefresh.h"

#import "DetailViewController.h"

#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]
NSString *const MJTableViewCellIdentifier = @"Cell";


@interface HomeViewController ()

@property(nonatomic,strong)UIButton *showCatergoryViewButn;
@property(nonatomic,strong)UIButton *showTopMenuViewButn;
@property(nonatomic,strong)CategoryMenuView *categoryMenuView;
@property(nonatomic,strong)TopMenuView *topMenuView;
@property(nonatomic,strong)FocusView *focusView;
@property(nonatomic,strong)ListView *listView;
@property(nonatomic,assign)BOOL iscategoryMenuViewShowed;
@property(nonatomic,assign)BOOL isTopMenuShowed;

@property (strong, nonatomic) NSMutableArray *fakeData;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        _categoryMenuView = [[CategoryMenuView alloc] initWithFrame:CGRectMake(ScreenX,40, 100, ScreenHeight)];
        _topMenuView = [[TopMenuView alloc] initWithFrame:CGRectMake(ScreenWidth-100 -200,ScreenY+40, 200, 50)];
        _focusView = [[FocusView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, ScreenWidth, 200)];
//        _listView = [[ListView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY+200, ScreenWidth, 300)];
        [self setupDataArray];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.hidesBottomBarWhenPushed = YES;

    
    self.tableView1.frame = CGRectMake(ScreenX,20, ScreenWidth, ScreenHeight-_focusView.frame.size.height);
    // 1.注册cell
    [self.tableView1 registerClass:[ListTableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView1.alpha = 0.5f;
    self.tableView1.backgroundColor = [UIColor clearColor];
    self.tableView1.hidden = NO;
    
    // 2.集成刷新控件
    [self setupRefresh];
    
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:_focusView];
    [self _initTopView];
    [self _initShowCatergoryView];
    
    //解决scrollview偏移
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_initShowCatergoryView
{
    _showCatergoryViewButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX+20, 20, 50, 50)];

    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    _showCatergoryViewButn.tag = 0;
    [_showCatergoryViewButn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_showCatergoryViewButn];
    
    _categoryMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:_categoryMenuView];
    _categoryMenuView.hidden = YES;

}

- (void)_initTopView
{
    _showTopMenuViewButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 20, 50, 50)];
    
    [_showTopMenuViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [_showTopMenuViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    _showTopMenuViewButn.tag = 1;
    [_showTopMenuViewButn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showTopMenuViewButn];
    
    
    _topMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    [self.view addSubview:_topMenuView];

}

- (void)buttonPressed:(UIButton *)button
{
    if (button.tag == 0) {
        
        _iscategoryMenuViewShowed = !_iscategoryMenuViewShowed;
        
        if (_iscategoryMenuViewShowed) {
            
            [_categoryMenuView showMenu];
            [UIView animateWithDuration:0.5 animations:^{
                _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x + _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
            }];
        }
        else
        {
            [_categoryMenuView hideMenu];
            [UIView animateWithDuration:0.5 animations:^{
                _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x - _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
            }];
        }
    }
    else if (button.tag == 1)
    {
        _isTopMenuShowed = !_isTopMenuShowed;
        
        if (_isTopMenuShowed) {
            
            [_topMenuView showMenu];
            [UIView animateWithDuration:0.5 animations:^{
//                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x + _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
            }];
        }
        else
        {
            [_topMenuView hideMenu];
            [UIView animateWithDuration:0.5 animations:^{
//                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x - _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
            }];
        }
    }
    

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
//    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendHideTabBarMessage object:nil];
    
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
//    self.tabBarController.tabBar.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendShowTabBarMessage object:nil];

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showTabBar];
}

/////////////////////////////////////////////

/**
 *  数据的懒加载
 */
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData = [NSMutableArray array];
        
        for (int i = 0; i<12; i++) {
            [self.fakeData addObject:MJRandomData];
        }
    }
    return _fakeData;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView1 addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView1 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView1 addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView1.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView1.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView1.headerRefreshingText = @"MJ哥正在帮你刷新中,不客气";
    
    self.tableView1.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView1.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView1.footerRefreshingText = @"MJ哥正在帮你加载中,不客气";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
//        [self.fakeData insertObject:MJRandomData atIndex:i];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView1 reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView1 headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
//        [self.dataArray addObject:MJRandomData];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView1 reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView1 footerEndRefreshing];
    });
}

- (void)setupDataArray {
    
    
    self.dataArray = [NSMutableArray array];
    
    // Load sample data into the array
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SampleData" ofType:@"plist"];
    [self.dataArray addObjectsFromArray:[NSArray arrayWithContentsOfFile:filePath]];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    
    // Load data
    NSDictionary *dataDict = self.dataArray[indexPath.row];
    // Sample image
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%i", arc4random_uniform(10) + 1]];
    cell.backgroundColor = [UIColor clearColor];
    [cell setupCellWithData:dataDict andImage:image];
    
//    cell.textLabel.text = self.fakeData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hahhahh");
    DetailViewController *dvc = [[DetailViewController alloc] init];

    [self.navigationController pushViewController:dvc animated:YES];
    [self hideTabBar];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    
    // Create our size
    CGSize cellSize = [ListTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<HTKDynamicResizingCellProtocol> cellToSetup) {
        // set values - there's no need to set the image here
        // because we have height and width constraints set, so
        // nil image will end up measuring to that size. If you don't
        // set the image contraints, it will end up being it's 1x intrinsic
        // size of the image, so you should set a default image when you
        // create the cell.
        NSDictionary *dataDict = weakSelf.dataArray[indexPath.row];
        [((ListTableViewCell *)cellToSetup) setupCellWithData:dataDict andImage:nil];
        
        // return cell
        return cellToSetup;
    }];
    
    return cellSize.height;
}


@end
