//
//  ListTableViewCell.m
//  XGTuShare
//
//  Created by xuegang on 15/5/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()

@property(nonatomic,strong)NSString *title;         //文章标题
@property(nonatomic,strong)UIImageView  *articleImageView;         //文章图片
@property(nonatomic,strong)NSString *authorName;    //作者姓名
@property(nonatomic,strong)NSString *crateTime;     //创建时间
@property(nonatomic,strong)NSString *zanNum;        //赞数
@property(nonatomic,strong)NSString *commentNum;    //评论数
@property(nonatomic,strong)NSString *distance;      //用户距离

@end

@implementation ListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

//设置view
- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.articleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.articleImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.articleImageView.layer.borderWidth = 1;
    self.articleImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.articleImageView];
    
    
    
    
    // Constrain
//    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_sampleImageView, _nameLabel, _companyLabel, _bioLabel);
//    // Create a dictionary with buffer values
//    NSDictionary *metricDict = @{@"sideBuffer" : @10, @"verticalBuffer" : @10, @"imageSize" : @75};
//    
//    // Constrain elements horizontally
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_sampleImageView(imageSize)]-sideBuffer-[_nameLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_sampleImageView(imageSize)]-sideBuffer-[_companyLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_bioLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
//    
//    // Constrain elements vertically
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_sampleImageView(imageSize)]" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_nameLabel]-verticalBuffer-[_companyLabel]" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bioLabel]-verticalBuffer-|" options:0 metrics:metricDict views:viewDict]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.companyLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sampleImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
//    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sampleImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    

}


- (void)setupCellWithData:(NSDictionary *)data andImage:(UIImage *)image
{
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
