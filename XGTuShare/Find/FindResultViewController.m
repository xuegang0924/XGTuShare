//
//  FindResultViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/10.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "FindResultViewController.h"
#import "FindResultTableView.h"
#import "ListTableViewCell.h"
#import "DetailViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "SBJSON.h"
#import "XGHttpRequest.h"

#import "CreateArticleViewController.h"

NSString *const FindResultTableViewCellIdentifier = @"FindResultCell";


@interface FindResultViewController () <ASIHTTPRequestDelegate>
@property (nonatomic,strong) UIImage *capImage;
@property (nonatomic,strong) UIImageView *capImageView;
//@property (nonatomic,strong) FindResultView *findResultView;

@property (nonatomic,strong) FindResultTableView *findResultTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView   *backgroundImageView;
@property (nonatomic, strong) UIView   *backgroundView;

@end

@implementation FindResultViewController


- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.capImage = image;
        
        self.findResultTableView = [[FindResultTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        
        //request
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://m.weather.com.cn/data/101210101.html"]];
        request.delegate = self;
        [request startAsynchronous];

    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //加入半透明浮层
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    
    //加入模糊图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    [self.backgroundImageView setImageToBlur:self.capImage blurRadius:30 completionBlock:nil];
    [self.view addSubview:self.backgroundImageView];
    //    [self.view bringSubviewToFront:self.backgroundImageView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    

    
    self.capImageView = [[UIImageView alloc] initWithImage:self.capImage];
    self.capImageView.backgroundColor = [UIColor yellowColor];
    self.capImageView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, 250);
    self.capImageView.contentMode = UIViewContentModeScaleToFill;
    self.capImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.capImageView];
    //给imageview添加手势
    UITapGestureRecognizer *imageTab = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick)];
    [self.capImageView addGestureRecognizer:imageTab];
 

    
    
    //findResultView
//    self.findResultView = [[FindResultView alloc] initWithFrame:CGRectMake(ScreenX, 200, ScreenWidth, 300)];
//    self.findResultView.frame = CGRectMake(0, 300, 300, 300);
//    self.findResultView.hidden = NO;
//    self.findResultView.backgroundColor = [UIColor clearColor];
    
    [self setupDataArray];
//    
    self.findResultTableView.frame = CGRectMake(ScreenX, ScreenY+self.capImageView.frame.size.height, ScreenWidth , ScreenHeight-self.capImageView.frame.size.height);
    [self.findResultTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:FindResultTableViewCellIdentifier];
    self.findResultTableView.delegate = self;
    self.findResultTableView.dataSource = self;
    
    [self.findResultTableView reloadData];
    self.findResultTableView.backgroundColor = [UIColor clearColor];
    self.findResultTableView.hidden = NO;
    
    [self.view addSubview:self.findResultTableView];

    [self.backBtn addTarget:self action:@selector(backBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view bringSubviewToFront:self.backBtn];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnSelect:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//imageView单击事件
-(void)imageViewClick
{
//        CreateArticleViewController *caVc = [CreateArticleViewController getCreateArticleViewController];
        CreateArticleViewController *caVc = [[CreateArticleViewController alloc] init];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.000];
    [self.navigationController.navigationBar setTranslucent:YES];
    //    为什么要加这个呢，shadowImage 是在ios6.0以后才可用的。但是发现5.0也可以用。不过如果你不判断有没有这个方法，
    //    而直接去调用可能会crash，所以判断下。作用：如果你设置了上面那句话，你会发现是透明了。但是会有一个阴影在，下面的方法就是去阴影
    if ([self.navigationController.navigationBar respondsToSelector:@selector(shadowImage)])
    {
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }
    //    以上面4句是必须的,但是习惯还是加了下面这句话
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
//    self.navigationController.navigationBar.back
    [self.navigationController pushViewController:caVc animated:YES];
//    [self presentViewController:caVc animated:YES completion:nil];
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MJTableViewCellIdentifier forIndexPath:indexPath];
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FindResultTableViewCellIdentifier forIndexPath:indexPath];
    

    // Load data
    NSDictionary *dataDict = self.dataArray[indexPath.row];
    // Sample image
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%i", arc4random_uniform(10) + 1]];
    cell.backgroundColor = [UIColor clearColor];
    [cell setupCellWithData:dataDict andImage:image];
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor clearColor];
    //    cell.textLabel.text = self.fakeData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hahhahh");
    DetailViewController *dvc = [[DetailViewController alloc] init];

//    [self.navigationController pushViewController:dvc animated:YES];
    [self presentViewController:dvc animated:YES completion:nil];
    
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
    SBJSON *sbjson = [[SBJSON alloc] init];
    NSDictionary *dic = [sbjson objectWithString:request.responseString];
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
////    NSString *str = [data JSONFragment];//[[NSString alloc] initWithData:data encoding:NSSymbolStringEncoding];
////    NSDictionary *dic = [self.sbjson objectWithString:str];
//    
//    NSLog(@"didReceiveData:%@ \rn dic:%@",data);
//}


@end
