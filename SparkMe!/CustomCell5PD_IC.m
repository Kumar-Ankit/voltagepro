//
//  CustomCell5PD_IC.m
//  Sparky
//
//  Created by Hung on 5/09/13.
//
//

#import "CustomCell5PD_IC.h"


@implementation CustomCell5PD_IC

@synthesize stateLabel, dateLabel, mwFlowLabel,exportLimitLabel,importLimitLabel;

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

