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

#import "KMMovieDetailsCell.h"
#import "KMMovieDetailsDescriptionCell.h"
#import "KMMovieDetailsSimilarMoviesCell.h"
#import "KMSimilarMoviesCollectionViewCell.h"
#import "KMMovieDetailsPopularityCell.h"
#import "KMMovieDetailsCommentsCell.h"
#import "KMMovieDetailsViewAllCommentsCell.h"
#import "KMComposeCommentCell.h"

#import "ArticleModle.h"


#define KMComposeCommentCellIdentifier @"KMComposeCommentCellIdentifier"

@interface DetailTableViewController ()
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,strong) UIImageView *articleImageView;


@property (nonatomic,strong) ArticleModle *articleDetails;

@end

@implementation DetailTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.articleDetails = [[ArticleModle alloc] init];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    //加入半透明浮层
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [[self.view superview] addSubview:self.backgroundView];
    [[self.view superview] sendSubviewToBack:self.backgroundView];
    
    //加入模糊图片
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.frame = CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight);
    [self.backgroundImageView setImageToBlur:[UIImage imageNamed:IMG_FOCUSVIEW_2] blurRadius:30 completionBlock:nil];
    [[self.view superview] addSubview:self.backgroundImageView];
    //    [self.view bringSubviewToFront:self.backgroundImageView];
    [[self.view superview] sendSubviewToBack:self.backgroundImageView];
    
    
    //设置视差效果tableView
    //焦点图视图
    _articleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, ScreenWidth+100, 300)];
    [_articleImageView setImage:[UIImage imageNamed:IMG_FOCUSVIEW_3]];
    
    [self.tableView setParallaxHeaderView:_articleImageView
                                     mode:VGParallaxHeaderModeCenter
                                   height:200];
    
    
    self.tableView.frame = CGRectMake(0,0, ScreenWidth, ScreenHeight);
    // 注册cell
    [self.tableView registerClass:[KMComposeCommentCell class] forCellReuseIdentifier:KMComposeCommentCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.alpha = 0.5f;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self setupNavigationbarButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setupNavigationbarButtons
{
    UIButton *backButn = [UIButton buttonWithType:UIButtonTypeCustom];
    backButn.frame = CGRectMake(10, 31, 30, 30);
    [backButn setImage:[UIImage imageNamed:IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [backButn setImage:[UIImage imageNamed:IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    [backButn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButn];
    
//    self.navBarTitleLabel.text = self.articleDetails.articleTitle;
    
}

- (void)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    KMComposeCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:KMComposeCommentCellIdentifier forIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor clearColor]];
//    cell.backgroundView = nil;
//    // Configure the cell...
//
//
//    return cell;
    
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
        {
            KMMovieDetailsCell *detailsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCell"];
            
            if(detailsCell == nil)
                detailsCell = [KMMovieDetailsCell movieDetailsCell];
            
            //            [detailsCell.posterImageView setImageURL:[NSURL URLWithString:self.articleDetails.articleImageUrl]];
            detailsCell.posterImageView.image = [UIImage imageNamed:@"movepic1"];
            detailsCell.movieTitleLabel.text = self.articleDetails.articleTitle;
            detailsCell.genresLabel.text = self.articleDetails.articleAuthorName;
            
            cell = detailsCell;
        }
            break;
        case 1:
        {
            KMMovieDetailsDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsDescriptionCell"];
            
            if(descriptionCell == nil)
                descriptionCell = [KMMovieDetailsDescriptionCell movieDetailsDescriptionCell];
            
            descriptionCell.movieDescriptionLabel.text = self.articleDetails.articleContent;
            
            cell = descriptionCell;
        }
            break;
        case 2:
        {
            KMMovieDetailsSimilarMoviesCell *contributionCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsSimilarMoviesCell"];
            
            if(contributionCell == nil)
                contributionCell = [KMMovieDetailsSimilarMoviesCell movieDetailsSimilarMoviesCell];
            
            [contributionCell.viewAllSimilarMoviesButton addTarget:self action:@selector(viewAllSimilarMoviesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            cell = contributionCell;
            
        }
            break;
        case 3:
        {
            KMMovieDetailsPopularityCell *popularityCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsPopularityCell"];
            
            if(popularityCell == nil)
                popularityCell = [KMMovieDetailsPopularityCell movieDetailsPopularityCell];
            
            popularityCell.voteAverageLabel.text = self.articleDetails.articleZanNum;
            popularityCell.voteCountLabel.text = self.articleDetails.articleZanNum;
            popularityCell.popularityLabel.text = self.articleDetails.articleCommitNum;
            
            cell = popularityCell;
        }
            break;
        case 4:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil)
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
            
            commentsCell.usernameLabel.text = @"Kevin Mindeguia";
            commentsCell.commentLabel.text = @"Macaroon croissant I love tiramisu I love chocolate bar chocolate bar. Cheesecake dessert croissant sweet. Muffin gummies gummies biscuit bear claw. ";
            [commentsCell.cellImageView setImage:[UIImage imageNamed:@"kevin_avatar"]];
            
            cell = commentsCell;
        }
            break;
        case 5:
        {
            KMMovieDetailsCommentsCell *commentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsCommentsCell"];
            
            if(commentsCell == nil)
                commentsCell = [KMMovieDetailsCommentsCell movieDetailsCommentsCell];
            
            commentsCell.usernameLabel.text = @"Andrew Arran";
            commentsCell.commentLabel.text = @"Chocolate bar carrot cake candy canes oat cake dessert. Topping bear claw dragée. Sugar plum jelly cupcake.";
            [commentsCell.cellImageView setImage:[UIImage imageNamed:@"scrat_avatar"]];
            
            cell = commentsCell;
        }
            break;
        case 6:
        {
            KMMovieDetailsViewAllCommentsCell *viewAllCommentsCell = [tableView dequeueReusableCellWithIdentifier:@"KMMovieDetailsViewAllCommentsCell"];
            
            if(viewAllCommentsCell == nil)
                viewAllCommentsCell = [KMMovieDetailsViewAllCommentsCell movieDetailsAllCommentsCell];
            
            cell = viewAllCommentsCell;
        }
            break;
        case 7:
        {
            KMComposeCommentCell *composeCommentCell = [tableView dequeueReusableCellWithIdentifier:@"KMComposeCommentCell"];
            
            if(composeCommentCell == nil)
                composeCommentCell = [KMComposeCommentCell composeCommentsCell];
            
            cell = composeCommentCell;
        }
            break;
        default:
            break;
    }
    return cell;

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // A much nicer way to deal with this would be to extract this code to a helper class, that would take care of building the cells.
    CGFloat height = 0;
    
    if (indexPath.row == 0)
        height = 120;
    else if (indexPath.row == 1)
        height = 119;
    else if (indexPath.row == 2)
    {
//        if ([self.similarMoviesDataSource count] == 0)
//            height = 0;
//        else
            height = 143;
    }
    else if (indexPath.row == 3)
        height = 67;
    else if (indexPath.row >= 4 && indexPath.row < 6)
        height = 100;
    else if (indexPath.row == 6)
        height = 49;
    else if (indexPath.row == 7)
        height = 62;
    return height;
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
