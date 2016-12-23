//
//  VPSwitchCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPSwitchCell.h"
#import "Utility.h"

@implementation VPSwitchCell

- (void)setup
{
    [super setup];
    self.isDetailMode = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _prioritySwitch = [[UISwitch alloc] init];
    [_prioritySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_prioritySwitch];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    CGSize size = _prioritySwitch.bounds.size;
    
    float x = rect.size.width - kDefaultSidePadding - size.width;
    float y = CenteredOrigin(rect.size.height, size.height);
    
    [_prioritySwitch setFrame:(CGRect) {x, y, size}];
}


- (void)changeSwitch:(id)sender
{
    if ([_delegate respondsToSelector:@selector(switchButtonValueChangeWithCell:)]) {
        [_delegate switchButtonValueChangeWithCell:self];
    }
}

@end
