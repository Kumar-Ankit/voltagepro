//
//  VPDetailTextFieldCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPDetailTextFieldCell.h"
#import "Utility.h"

@interface VPDetailTextFieldCell ()
@property (nonatomic, strong) UILabel *leftLabel;
@end
@implementation VPDetailTextFieldCell

- (void)setup
{
    [super setup];
    self.textField.textAlignment = NSTextAlignmentRight;
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.leftLabel.font = kTableViewCellMainFont;
    self.leftLabel.textColor = kTableTitleColor;
    [self.contentView addSubview:_leftLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    CGSize size = self.leftLabel.intrinsicContentSize;
    
    float origin_x = kTableViewSidePadding + size.width;
    self.leftLabel.frame = (CGRect) {kTableViewSidePadding, 0.0, size.width, rect.size.height};
    self.textField.frame = (CGRect) {origin_x, 1.0, rect.size.width - origin_x, rect.size.height - 1.0};
}

- (void)setTitleText:(NSString *)titleText
{
    if ([_titleText isEqualToString:titleText]) {
        return;
    }
    
    _titleText = titleText;
    self.leftLabel.text = titleText;
    [self setNeedsLayout];
}

@end
