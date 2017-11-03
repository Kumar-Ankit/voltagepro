//
//  VPTimeSelectionController.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/14/17.
//

#import "VPViewController.h"
#import "VPPASATimeCompareModel.h"
@class VPTimeSelectionController;

@protocol VPTimeSelectionControllerDelegate <NSObject>
- (void)timeSelectionController:(VPTimeSelectionController *)controller didSelcectTime:(VPPASATimeCompareModel *)time;
@end

@interface VPTimeSelectionController : VPViewController
@property (nonatomic, weak) id <VPTimeSelectionControllerDelegate> delegate;
@property (nonatomic, assign) PASAType controllerType;
@property (nonatomic, strong) NSString *preSelectedTimeId;
@end
