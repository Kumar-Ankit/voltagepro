//
//  VPTableViewCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <UIKit/UIKit.h>

@interface VPTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isInvalid;
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, assign) BOOL isDetailMode;
@property (nonatomic, assign) BOOL isPlaceholder;

- (void)setup;
- (void)updateColors;
@end
