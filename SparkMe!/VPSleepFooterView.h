//
//  VPSleepTimingCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/24/16.
//
//

#import <UIKit/UIKit.h>

@interface VPSleepFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIButton *btnEdit;
- (void)setFrom:(NSString *)from to:(NSString *)to isSleep:(BOOL)sleep;
+ (CGFloat)heightForWidth:(float)width;
@end
