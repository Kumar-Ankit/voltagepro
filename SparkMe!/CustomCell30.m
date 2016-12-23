//
//  CustomCell30.m
//  Sparky
//
//  Created by Hung on 21/12/12.
//
//

#import "CustomCell30.h"

@implementation CustomCell30

@synthesize dateLabel, demandLabel, priceLabel, typeLabel;

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
