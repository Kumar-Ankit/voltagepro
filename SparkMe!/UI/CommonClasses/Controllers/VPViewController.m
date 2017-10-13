//
//  VPViewController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/14/17.
//

#import "VPViewController.h"

@interface VPViewController ()

@end

@implementation VPViewController

- (id)initFromNib
{
    NSString *className = NSStringFromClass([self class]);
    return [super initWithNibName:className bundle:nil];;
}

@end
