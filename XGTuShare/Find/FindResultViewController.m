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


NSString *const FindResultTableViewCellIdentifier = @"FindResultCell";


@interface FindResultViewController ()
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
//    self.capImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.capImageView];
    
    //findResultView
//    self.findResultView = [[FindResultView alloc] initWithFrame:CGRectMake(ScreenX, 200, ScreenWidth, 300)];
//    self.findResultView.frame = CGRectMake(0, 300, 300, 300);
//    self.findResultView.hidden = NO;
//    self.findResultView.backgroundColor = [UIColor clearColor];
    
    [self setupDataArray];
    
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




@end
