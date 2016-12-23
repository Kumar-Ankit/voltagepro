//
//  VPPickerLable.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "VPPickerLabel.h"

@implementation VPPickerLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setInputView:(UIView *)aView andToolbar:(UIToolbar *)aToolbar
{
    _inputView = aView;
    _inputAccessoryView = aToolbar;
}

- (UIView *)inputView
{
    return _inputView;
}

- (UIView *)inputAccessoryView
{
    return _inputAccessoryView;
}
@end
