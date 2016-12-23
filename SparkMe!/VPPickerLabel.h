//
//  VPPickerLable.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <UIKit/UIKit.h>

@interface VPPickerLabel : UILabel

@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIView *inputAccessoryView;

- (void)setInputView:(UIView *)aView andToolbar:(UIToolbar *)aToolbar;

@end
