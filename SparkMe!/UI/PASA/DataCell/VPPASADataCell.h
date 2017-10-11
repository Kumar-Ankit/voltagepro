//
//  VPPASADataCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import <UIKit/UIKit.h>

@interface VPPASADataCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelPASA;
@property (weak, nonatomic) IBOutlet UILabel *labelDelta;

+ (CGFloat)height;
+ (UINib *)cellNib;
@end
