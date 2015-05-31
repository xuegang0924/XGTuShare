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
//#import "ListView.h"
#import "ListTableViewCell.h"
#import "MJRefresh.h"
#import "DetailViewController.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "UIImageView+LBBlurredImage.h"
#import "DetailTableViewController.h"
#import "XGHttpRequest.h"
#import "JSON.h"
#import "ListViewModel.h"

#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

NSString *const MJTableViewCellIdentifier = @"HomeViewCell";


@interface HomeViewController () <XGHttpRequestDelegate>

@property(nonatomic,strong)UIButton *showCatergoryViewButn;
@property(nonatomic,strong)UIButton *showTopMenuViewButn;
@property(nonatomic,strong)CategoryMenuView *categoryMenuView;
@property(nonatomic,strong)TopMenuView *topMenuView;
@property(nonatomic,strong)FocusView *focusView;
//@property(nonatomic,strong)ListView *listView;
@property(nonatomic,assign)BOOL iscategoryMenuViewShowed;
@property(nonatomic,assign)BOOL isTopMenuShowed;

@property (strong, nonatomic) NSMutableArray *fakeData;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView   *backgroundImageView;
@property (nonatomic, strong) UIView   *backgroundView;

@property (nonatomic, strong) NSMutableArray *listDataArray;    //列表数据
@property (nonatomic, strong) NSMutableArray *foucusDataArray;  //焦点图数据

@property (nonatomic, strong) XGHttpRequest *httpRequest;       //数据请求
@property (nonatomic, strong) SBJSON *sbjson;                   //json转dic
@property (nonatomic, strong) NSMutableDictionary *mdicReciveData;       //数据请求




@end

@implementation HomeViewController



- (id)init
{
    self = [super init];
    if (self) {
        
        
        [self setupDataArray];
        
        //httpRequest
        self.httpRequest = [[XGHttpRequest alloc] initWithDelegate:self];
        self.httpRequest.url = [NSURL URLWithString:@"http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&sort_by=popularity.desc&page=1"];
        [self.httpRequest createASIHttpRequest];
        [self.httpRequest startRequestWithCachePolicy:ASIAskServerIfModifiedCachePolicy];

//        ASIHTTPRequest
        
        //sbjson
        self.sbjson = [[SBJSON alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.hidesBottomBarWhenPushed = YES;
    

    
    //加入半透明浮层
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    
    //加入模糊图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    [self.backgroundImageView setImageToBlur:[UIImage imageNamed:IMG_FOCUSVIEW_2] blurRadius:30 completionBlock:nil];
    [self.view addSubview:self.backgroundImageView];
    //    [self.view bringSubviewToFront:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    

    //设置视差效果tableView
    //焦点图视图
    _focusView = [[FocusView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, ScreenWidth, 200)];
    [self.tableView setParallaxHeaderView:_focusView
                                     mode:VGParallaxHeaderModeFill
                                   height:200];
    
    
    self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
    // 注册cell
    [self.tableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.alpha = 0.5f;
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.hidden = NO;
    
    // 集成刷新控件
//    [self setupRefresh];
    
    // 加入类别和分类菜单
    [self _initTopView];
    [self _initShowCatergoryView];
    

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
    
    //右侧类别菜单
    _categoryMenuView = [[CategoryMenuView alloc] initWithFrame:CGRectMake(ScreenX,40, 100, ScreenHeight)];
    _categoryMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _categoryMenuView.delegate = self;
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
    
    //顶部分类菜单
    _topMenuView = [[TopMenuView alloc] initWithFrame:CGRectMake(ScreenWidth-100 -200,ScreenY+40, 200, 50)];
    _topMenuView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    _topMenuView.delegate = self;
    [self.view addSubview:_topMenuView];

}

- (void)buttonPressed:(UIButton *)button
{
    if (button.tag == 0)
    {
        _iscategoryMenuViewShowed = !_iscategoryMenuViewShowed;
        
        if (_iscategoryMenuViewShowed)
        {
            [self showCategoryMenu];
        }
        else
        {
            [self hideCategoryMenu];
        }
    }
    else if (button.tag == 1)
    {
        _isTopMenuShowed = !_isTopMenuShowed;
        
        if (_isTopMenuShowed)
        {
            [self showTopMenu];
        }
        else
        {
            [self hideTopMenu];
        }
    }
    

}

- (void)showCategoryMenu
{
    [_categoryMenuView showMenu];
    [UIView animateWithDuration:0.5 animations:^{
        _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x + _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
    }];
}

- (void)hideCategoryMenu
{
    [_categoryMenuView hideMenu];
    [UIView animateWithDuration:0.5 animations:^{
        _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x - _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
    }];
}

- (void)showTopMenu
{
    [_topMenuView showMenu];
    [UIView animateWithDuration:0.5 animations:^{
        //                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x + _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
    }];
}

- (void)hideTopMenu
{
    [_topMenuView hideMenu];
    [UIView animateWithDuration:0.5 animations:^{
        //                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x - _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
    }];
}

- (void)hideTabBar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendHideTabBarMessage object:nil];
}


- (void)showTabBar

{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendShowTabBarMessage object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self showTabBar];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
    // Log Parallax Progress
    //NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
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
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"正在帮你刷新中,不客气";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"正在帮你加载中,不客气";
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
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
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
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
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
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
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


#pragma mark -
#pragma mark CategoryMenuViewDelegate
-(void)onCategoryMenuButonTouched:(UIButton *)button withTouchEventType:(ECategoryMenuButonTouchEventType)touchEventType
{
    //TODO:获取不同的类别数据 进行刷新
    [self.tableView reloadData];
    [self hideCategoryMenu];
    _iscategoryMenuViewShowed = NO;
}

#pragma mark -
#pragma mark TopMenuViewDelegate
-(void)onTopMenuButonTouched:(UIButton *)button withTouchEventType:(ETopMenuButonTouchEventType)touchEventType
{
    //TODO:获取不同的分类数据 进行刷新
    [self.tableView reloadData];
    [self hideTopMenu];
    _isTopMenuShowed = NO;
}



#pragma mark -
#pragma mark XGHttpRequestDelegate
- (void) requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"requestStarted");
}

- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"didReceiveResponseHeaders:%@",responseHeaders);
}

- (void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    NSLog(@"willRedirectToURL:%@",newURL);
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished string:%@",request.responseString);
    
    NSDictionary *dic = [self.sbjson objectWithString:request.responseString];
    NSLog(@"requestFinished dic:%@",dic);
}

- (void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed");
}

- (void) requestCanceled:(ASIHTTPRequest *)request
{
    NSLog(@"requestCanceled");
}

- (void) requestRedirected:(ASIHTTPRequest *)request
{
    NSLog(@"requestRedirected");
}

//- (void) request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
//{
//    NSString *str = [data JSONFragment];//[[NSString alloc] initWithData:data encoding:NSSymbolStringEncoding];
//    NSDictionary *dic = [self.sbjson objectWithString:str];
//
//    NSLog(@"didReceiveData:%@ \rn dic:%@",data,dic);
//}

- (void) setProgress:(float)newProgress
{
    NSLog(@"setProgress:%f",newProgress);
}

@end
