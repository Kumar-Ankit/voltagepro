//
//  CustomCell5PD.m
//  Sparky
//
//  Created by Hung on 11/07/13.
//
//

#import "CustomCell5PD.h"

@implementation CustomCell5PD

@synthesize stateLabel, dateLabel, demandLabel, priceLabel, genLabel, ichgLabel;

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
