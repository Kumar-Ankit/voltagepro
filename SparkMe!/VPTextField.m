//
//  VPTextField.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "VPTextField.h"
#import "Utility.h"

@implementation VPTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    _horInset = kTextFieldSidePadding;
    self.textColor = kTfTextColor;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _horInset, 0.0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _horInset, 0.0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, _horInset, 0.0);
}

- (void)setIsInvalid:(BOOL)isInvalid
{
    _isInvalid = isInvalid;
    [self updateAttributedPlaceholder];
}

- (void)updateAttributedPlaceholder
{
    if (self.placeholder.length == 0) {
        return;
    }
    
    if (_isInvalid) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:@{NSForegroundColorAttributeName:kAppSelectionRedColor}];
        self.textColor = kAppSelectionRedColor;
        
    } else {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                     attributes:@{NSForegroundColorAttributeName:kPlaceholderColor}];
        self.textColor = kTfTextColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    [self updateAttributedPlaceholder];
}



@end
