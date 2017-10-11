//
//  VPPASADataController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/10/17.
//

#import "VPPASADataController.h"
#import "VPStateSegmentControl.h"

@interface VPPASADataController ()
@property (nonatomic, strong) VPStateSegmentControl *segmentControl;
@end

@implementation VPPASADataController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.segmentControl = [[VPStateSegmentControl alloc] init];
    self.navigationItem.titleView = self.segmentControl;
    [self.navigationItem.titleView sizeToFit];
    
}


@end
