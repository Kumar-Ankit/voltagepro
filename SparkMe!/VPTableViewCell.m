//
//  VPTableViewCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "VPTableViewCell.h"
#import "Utility.h"

@implementation VPTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.textLabel.font = kTableViewCellMainFont;
    self.detailTextLabel.font = kTableViewCellMainFont;
    self.textLabel.textColor = kTableViewCellMainColor;
    self.detailTextLabel.textColor = kTableViewCellDescColor;
    
    [self setPreservesSuperviewLayoutMargins:NO];
    [self setLayoutMargins:UIEdgeInsetsZero];
    
    [self setIsLastCell:NO];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kSeparatorColor;
    self.selectedBackgroundView = view;
}

- (void)setIsLastCell:(BOOL)isLastCell
{
    _isLastCell = isLastCell;
    
    if (_isLastCell) {
        self.separatorInset = UIEdgeInsetsZero;
    }
    else {
        self.separatorInset = (UIEdgeInsets) {0.0, kTableViewSidePadding, 0.0, 0.0};
    }
}

- (void)setIsPlaceholder:(BOOL)isPlaceholder
{
    _isPlaceholder = isPlaceholder;
    [self updateColors];
}

- (void)setIsInvalid:(BOOL)isInvalid
{
    _isInvalid = isInvalid;
    [self updateColors];
}

- (void)setIsDetailMode:(BOOL)isDetailMode
{
    _isDetailMode = isDetailMode;
    [self updateColors];
}

- (void)updateColors
{
    if (_isDetailMode) {
        self.textLabel.textColor = kTableTitleColor;
        
        if (_isInvalid) {
            self.detailTextLabel.textColor = kAppSelectionRedColor;
        }
        else if (_isPlaceholder) {
            self.detailTextLabel.textColor = kPlaceholderColor;
        }
        else {
            self.detailTextLabel.textColor = kTableViewCellMainColor;
        }
    }
    else {
        if (_isInvalid) {
            self.textLabel.textColor = kAppSelectionRedColor;
            self.detailTextLabel.textColor = kAppSelectionRedColor;
        }
        else if (_isPlaceholder) {
            self.textLabel.textColor = kPlaceholderColor;
            self.detailTextLabel.textColor = kPlaceholderColor;
        }
        else {
            self.textLabel.textColor = kTableViewCellMainColor;
            self.detailTextLabel.textColor = kTableViewCellDescColor;
        }
    }
}


@end
