//
//  TwoButtonViewCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPTableViewCell.h"

@interface TwoButtonViewCell : VPTableViewCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier saveSel:(SEL)saveSel delSel:(SEL)delSel target:(id)target;
- (void)updateLeftTitle:(NSString *)lefTitle rightTitle:(NSString *)rightTitle;
@end
