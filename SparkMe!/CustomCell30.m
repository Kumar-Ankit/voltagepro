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
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.dateLabel.adjustsFontSizeToFitWidth =  YES;;
}

@end
