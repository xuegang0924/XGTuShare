//
//  HomeListTableViewCell.m
//  XGTuShare
//
//  Created by xuegang on 15/6/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "HomeListTableViewCell.h"
#import "UIImageView+WebCache.h"


@interface HomeListTableViewCell()

@property (strong, nonatomic) IBOutlet UIImageView *userHeadImage;

@property (strong, nonatomic) IBOutlet UILabel *userNickName;
@property (strong, nonatomic) IBOutlet UILabel *createTime;
@property (strong, nonatomic) IBOutlet UILabel *zanNumber;
@property (strong, nonatomic) IBOutlet UILabel *commentNumber;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *content;

@end


@implementation HomeListTableViewCell

+ (HomeListTableViewCell*) getHomeListTableViewCell
{
    HomeListTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeListTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}






- (void)setupHomeListCellWithModel:(ListViewModel *)model
{
    // Pull out sample data
    if (model == nil) {
        return;
    }
    
    
    NSString *imageUrl = model.articleImageUrl;
    NSString *nickName = model.authorName;
    NSString *createTime = model.createTime;
    NSString *content = model.articleSummary;
    NSString *zanNumber = model.zanNum;
    NSString *comentNumber = model.comentNum;
    NSString *location = model.location;
    
    // Set values
    self.userNickName.text = nickName;
//    self.userNickName.textColor = [UIColor whiteColor];
    
    self.createTime.text = createTime;
//    self.createTime.textColor = [UIColor whiteColor];
    
    self.content.text = content;
    
    self.zanNumber.text = zanNumber;
    self.commentNumber.text = comentNumber;
    self.distance.text = location;
    
    self.userHeadImage.frame = CGRectMake(0, 0, 128, 80);
//    self.userHeadImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
