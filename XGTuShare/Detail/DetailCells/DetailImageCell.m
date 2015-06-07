//
//  DetailImageCell.m
//  XGTuShare
//
//  Created by xuegang on 15/6/4.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "DetailImageCell.h"

@implementation DetailImageCell

+ (DetailImageCell*) articleDetailsImageCell
{
    DetailImageCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailImageCell" owner:self options:nil] objectAtIndex:0];
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
