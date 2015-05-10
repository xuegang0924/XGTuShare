//
//  FindResultView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/10.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "FindResultView.h"
#import "FindResultTableView.h"
#import "ListTableViewCell.h"

NSString *const FindResultTableViewCellIdentifier = @"FindResultCell";

@interface FindResultView ()
@property (nonatomic,strong) FindResultTableView *findResultTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation FindResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.findResultTableView = [[FindResultTableView alloc] initWithFrame:frame];
    }
    return self;
}

- (void)layoutSubviews
{
    
    
    [self setupDataArray];
    
    [self.findResultTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:FindResultTableViewCellIdentifier];
    self.findResultTableView.delegate = self;
    self.findResultTableView.dataSource = self;
    
    [self.findResultTableView reloadData];
    self.findResultTableView.backgroundColor = [UIColor blackColor];
    self.findResultTableView.hidden = NO;
    [super layoutSubviews];

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
    
    //    cell.textLabel.text = self.fakeData[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hahhahh");
//    DetailViewController *dvc = [[DetailViewController alloc] init];
    
//    [self pushViewController:dvc animated:YES];
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
