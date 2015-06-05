//
//  DetailCommentNumberTableViewCell.m
//  XGTuShare
//
//  Created by xuegang on 15/6/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "DetailCommentNumberTableViewCell.h"

@implementation DetailCommentNumberTableViewCell

+ (DetailCommentNumberTableViewCell*) articleDetailsCommentNumberCell
{
    DetailCommentNumberTableViewCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCommentNumberTableViewCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
