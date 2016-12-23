//
//  PVTextFieldCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "VPTextFieldCell.h"
#import "Utility.h"

@interface VPTextFieldCell ()<UITextFieldDelegate>
@end

@implementation VPTextFieldCell



- (void)setup
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textField = [[VPTextField alloc] initWithFrame:self.contentView.bounds];
    self.textField.delegate = self;
    self.textField.font = kTableViewCellMainFont;
    self.textField.inputAccessoryView = [self addKeyBoardToolBar];
    [self.contentView addSubview:_textField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.frame = self.contentView.bounds;
}

- (void)setIsInvalid:(BOOL)isInvalid
{
    [super setIsInvalid:isInvalid];
    self.textField.isInvalid = isInvalid;
}

- (void)setMode:(TextFieldMode)mode
{
    _mode = mode;
    
    switch (mode) {
        case TextFieldModeNone :
        case TextFieldModeName :
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            break;
            
        case TextFieldModeAddress :
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            break;
            
        case TextFieldModeEmail :
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeEmailAddress;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
            
        case TextFieldModePassword :
            self.textField.secureTextEntry = YES;
            self.textField.keyboardType = UIKeyboardTypeDefault;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
            
        case TextFieldModePhoneNumber :
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypePhonePad;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
            
        case TextFieldModeRealNumber:
            self.textField.secureTextEntry = NO;
            self.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
            self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            break;
            
        default:
            break;
    }
}

#pragma mark - Text Field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.isInvalid = NO;
    
    if (textField.placeholder) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:kPlaceholderColor}];
    }
    
    if ([_delegate respondsToSelector:@selector(textFieldCellDidBeginEditing:)]) {
        [_delegate textFieldCellDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldCell:didEndEditingWithText:)]) {
        [self.delegate textFieldCell:self didEndEditingWithText:textField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_mode == TextFieldModeNone) {
        return YES;
    }
    
    NSCharacterSet * set = nil;
    
    if (_mode == TextFieldModePassword) {
        set = [NSCharacterSet whitespaceCharacterSet];
    }
    else if (_mode == TextFieldModeEmail) {
        NSMutableCharacterSet *mutSet = [[NSMutableCharacterSet alloc] init];
        [mutSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
        [mutSet addCharactersInString:@"+_.@"];
        set = [mutSet invertedSet];
    }
    else if (_mode == TextFieldModeName) {
        NSMutableCharacterSet *mutSet = [[NSMutableCharacterSet alloc] init];
        [mutSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
        [mutSet addCharactersInString:@"_. "];
        set = [mutSet invertedSet];
    }
    else if (_mode == TextFieldModeAddress) {
        NSMutableCharacterSet *mutSet = [[NSMutableCharacterSet alloc] init];
        [mutSet formUnionWithCharacterSet:[NSCharacterSet alphanumericCharacterSet]];
        [mutSet formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
        [mutSet addCharactersInString:@",-/"];
        set = [mutSet invertedSet];
    }
    else if (_mode == TextFieldModePhoneNumber) {
        set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    }
    else {
        NSMutableCharacterSet *mutSet = [[NSMutableCharacterSet alloc] init];
        [mutSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
        [mutSet addCharactersInString:@".-"];
        set = [mutSet invertedSet];
    }
    
    NSString *interim = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *result = [[interim componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    
    if (_mode == TextFieldModeName || _mode == TextFieldModePassword || _mode == TextFieldModeEmail || _mode == TextFieldModeAddress) {
        if ([interim isEqualToString:result]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    if (_mode == TextFieldModePhoneNumber) {
        if ([interim isEqualToString:result] && interim.length <= 10) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    
    // If there are 2 decimals being input, return
    if ([self occurrence:@"." inString:result] > 1) {
        return NO;
    }
    
    NSRange decRange = [result rangeOfString:@"."];
    if (decRange.location == result.length - 4) {
        return NO;
    }
    
    if (_mode == TextFieldModeRealNumber)
    {
        if ([self occurrence:@"-" inString:result] > 1) {
            return NO;
        }
        
        if ([self occurrence:@"-" inString:result] == 1) {
            NSRange decRange = [result rangeOfString:@"-"];
            if (decRange.location != 0) {
                return NO;
            }
        }
        
        if ([interim isEqualToString:result]) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    return YES;
}

- (NSInteger)occurrence:(NSString *)sub inString:(NSString *)string
{
    NSString *trimmed = [string stringByReplacingOccurrencesOfString:sub withString:@""];
    return [string length] - [trimmed length];
}

#pragma mark - Accessory view handling

- (UIToolbar *)addKeyBoardToolBar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:(CGRect) {0.0, 0.0, 320.0, 44.0}];
    toolbar.tintColor = kDarkBlueGrayColor;
    toolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 32.0;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow.left"] style:UIBarButtonItemStylePlain target:self action:@selector(toolBarPrevButtonPressed:)];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow.right"] style:UIBarButtonItemStylePlain target:self action:@selector(toolBarNextButtonPressed:)];
    UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarDoneButtonPressed:)];
    
    NSArray *barItems = @[down, flexSpace, left, fixed, right];
    [toolbar setItems:barItems animated:YES];
    
    return toolbar;
}

- (void)toolBarPrevButtonPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(textFieldCellShouldGoToPreviousOne:)]) {
        [_delegate textFieldCellShouldGoToPreviousOne:self];
    }
}

- (void)toolBarNextButtonPressed:(id)sender {
    if ([_delegate respondsToSelector:@selector(textFieldCellShouldReturn:)]) {
        [_delegate textFieldCellShouldReturn:self];
    }
}

- (void)toolBarDoneButtonPressed:(id)sender {
    if ([self.textField isFirstResponder])
        [self.textField resignFirstResponder];
}

@end
