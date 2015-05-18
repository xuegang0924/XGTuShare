//
//  DetailTableViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/18.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "DetailTableViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "KMComposeCommentCell.h"


#define KMComposeCommentCellIdentifier @"KMComposeCommentCellIdentifier"

@interface DetailTableViewController ()
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UIImageView *articleImageView;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

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
    _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, ScreenWidth+100, 300)];
    [_articleImageView setImage:[UIImage imageNamed:IMG_FOCUSVIEW_3]];
    
    [self.tableView setParallaxHeaderView:_articleImageView
                                     mode:VGParallaxHeaderModeTopFill
                                   height:200];
    
    
    self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
    // 注册cell
    [self.tableView registerClass:[KMComposeCommentCell class] forCellReuseIdentifier:KMComposeCommentCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.alpha = 0.5f;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KMComposeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:KMComposeCommentCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...


    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
}

@end
