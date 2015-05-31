//
//  ListTableViewCell.m
//  XGTuShare
//
//  Created by xuegang on 15/5/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ListTableViewCell ()

@property(nonatomic,strong)NSString *title;         //文章标题
@property(nonatomic,strong)UIImageView  *articleImageView;         //文章图片
@property(nonatomic,strong)NSString *authorName;    //作者姓名
@property(nonatomic,strong)NSString *crateTime;     //创建时间
@property(nonatomic,strong)NSString *zanNum;        //赞数
@property(nonatomic,strong)NSString *commentNum;    //评论数
@property(nonatomic,strong)NSString *distance;      //用户距离


/**
 * ImageView that shows sample picture
 */
@property (nonatomic, strong) UIImageView *sampleImageView;

/**
 * Label that is name of sample person
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 * Label that is name of sample company
 */
@property (nonatomic, strong) UILabel *companyLabel;

/**
 * Label that displays sample "bio".
 */
@property (nonatomic, strong) UILabel *bioLabel;


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
//    self.backgroundColor = [UIColor whiteColor];
//    self.accessoryType = UITableViewCellAccessoryNone;
//    self.accessoryView = nil;
//    self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    
//    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
//    
//    self.articleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    self.articleImageView.translatesAutoresizingMaskIntoConstraints = NO;
//    self.articleImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.articleImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.articleImageView.layer.borderWidth = 1;
//    self.articleImageView.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:self.articleImageView];
    

    
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Fix for contentView constraint warning
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    // Create our ImageView
    self.sampleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.sampleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.sampleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.sampleImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.sampleImageView.layer.borderWidth = 1;
    self.sampleImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.sampleImageView];
    
    // Name label
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.numberOfLines = 1;
    [self.contentView addSubview:self.nameLabel];
    
    // Company label
    self.companyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.companyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.companyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    self.companyLabel.textColor = [UIColor greenColor];
    self.companyLabel.numberOfLines = 1;
    [self.contentView addSubview:self.companyLabel];
    
    // Bio label
    self.bioLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bioLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.bioLabel.numberOfLines = 0; // Must be set for multi-line label to work
    self.bioLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.bioLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.bioLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.contentView addSubview:self.bioLabel];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_sampleImageView, _nameLabel, _companyLabel, _bioLabel);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @10, @"verticalBuffer" : @10, @"imageSize" : @75};
    
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_sampleImageView(imageSize)]-sideBuffer-[_nameLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_sampleImageView(imageSize)]-sideBuffer-[_companyLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_bioLabel]-sideBuffer-|" options:0 metrics:metricDict views:viewDict]];
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_sampleImageView(imageSize)]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_nameLabel]-verticalBuffer-[_companyLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bioLabel]-verticalBuffer-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.companyLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.sampleImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.bioLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.sampleImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
    
    // Set hugging/compression priorites for all labels.
    // This is one of the most important aspects of having the cell size
    // itself. setContentCompressionResistancePriority needs to be set
    // for all labels to UILayoutPriorityRequired on the Vertical axis.
    // This prevents the label from shrinking to satisfy constraints and
    // will not cut off any text.
    // Setting setContentCompressionResistancePriority to UILayoutPriorityDefaultLow
    // for Horizontal axis makes sure it will shrink the width where needed.
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.companyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.companyLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.bioLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.bioLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    // Set max layout width for all multi-line labels
    // This is required for any multi-line label. If you
    // do not set this, you'll find the auto-height will not work
    // this is because "intrinsicSize" of a label is equal to
    // the minimum size needed to fit all contents. So if you
    // do not have a max width it will not constrain the width
    // of the label when calculating height.
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.bioLabel.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sideBuffer"] floatValue] * 2);

    
    
  

}


- (void)setupCellWithData:(NSDictionary *)data andImage:(UIImage *)image
{
    // Pull out sample data
    NSString *nameString = data[@"sampleName"];
    NSString *companyString = data[@"sampleCompany"];
    NSString *bioString = data[@"sampleBio"];
    
    // Set values
    self.nameLabel.text = nameString;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.companyLabel.text = companyString;
    self.companyLabel.textColor = [UIColor whiteColor];

    self.bioLabel.text = bioString;
    
    self.sampleImageView.image = image;
}

- (void)setupCellWithModel:(ListViewModel *)model
{
    // Pull out sample data
    if (model == nil) {
        return;
    }
    
    NSString *nameString = model.articleTitle;
    NSString *companyString = model.createTime;
    NSString *bioString = model.articleSummary;
    
    // Set values
    self.nameLabel.text = nameString;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.companyLabel.text = companyString;
    self.companyLabel.textColor = [UIColor whiteColor];
    
    self.bioLabel.text = bioString;
    
    self.sampleImageView.frame = CGRectMake(0, 0, 80, 80);
    self.sampleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.sampleImageView sd_setImageWithURL:[NSURL URLWithString:model.articleImageUrl]];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

//    NSLog(@"ssssss");
    // Configure the view for the selected state
}

@end
