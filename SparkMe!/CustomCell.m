//
//  CustomCell.m
//  Sparky
//
//  Created by Hung on 1/12/12.
//
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize consIdLabel, rhsLabel, lhsLabel, effDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
