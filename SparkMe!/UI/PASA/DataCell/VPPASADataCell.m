//
//  VPPASADataCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import "VPPASADataCell.h"

@implementation VPPASADataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (UINib *)cellNib{
    UINib *cellNib = [UINib nibWithNibName:@"VPPASADataCell" bundle:nil];
    return cellNib;
}

+ (CGFloat)height{
    return 21.0;
}

@end
