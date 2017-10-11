//
//  VPStateSegmentControlView.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/10/17.
//

#import "VPStateSegmentControl.h"
#import "Utility.h"

@implementation VPStateSegmentControl

- (id)init
{
    self = [super initWithItems:[VPStateSegmentControl defaultStates]];
    if (self){
        self.selectedSegmentIndex = 0;
    }
    return self;
}

+ (NSArray *)defaultStates{
    return @[@"NSW", @"QLD", @"SA", @"TAS", @"VIC"];
}

@end
