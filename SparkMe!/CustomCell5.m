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
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.dateLabel.adjustsFontSizeToFitWidth =  YES;
}


@end
