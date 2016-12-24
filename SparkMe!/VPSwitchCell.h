//
//  VPSwitchCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPTableViewCell.h"

typedef enum{
    VPSwitchCellModeMute,
    VPSwitchCellModeSleep
}VPSwitchCellMode;

@class VPSwitchCell;

@protocol VPSwitchCellDelegate <NSObject>
- (void)switchButtonValueChangeWithCell :(VPSwitchCell *)cell;
@end

@interface VPSwitchCell : VPTableViewCell
@property (nonatomic, strong) NSIndexPath *nextIndexPath;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;
@property (nonatomic, strong) UISwitch *prioritySwitch;
@property (nonatomic, weak) id <VPSwitchCellDelegate> delegate;
@property (nonatomic, assign) VPSwitchCellMode switchCellMode;
@end
