//
//  CustomCell5.m
//  Sparky
//
//  Created by Hung on 21/12/12.
//
//

#import "CustomCell5.h"

@implementation CustomCell5

@synthesize dateLabel, demandLabel, priceLabel;

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
