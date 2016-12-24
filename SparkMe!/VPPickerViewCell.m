//
//  VPPickerViewCell.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "VPPickerViewCell.h"
#import "Utility.h"

@interface VPPickerViewCell ()
@property (nonatomic, strong) VPPickerLabel *label;
@end

@implementation VPPickerViewCell

- (void)setup
{
    [super setup];
    
    self.label = [[VPPickerLabel alloc]initWithFrame:self.contentView.bounds];
    self.textLabel.textColor = kTableTitleColor;
    self.label.font = kTableViewCellMainFont;
    self.label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.label];
}

- (void)updateColors
{
    [super updateColors];
    
    if (self.isInvalid) {
        self.label.textColor = kAppSelectionRedColor;
    }
    else if (self.isPlaceholder) {
        self.label.textColor = kPlaceholderColor;
    }
    else if (self.isDetailMode) {
        self.label.textColor = kTableViewCellMainColor;
    }
    else {
        self.label.textColor = kTableViewCellDescColor;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.textLabel intrinsicContentSize];
    CGRect rect = self.contentView.bounds;
    float remain = rect.size.width - 2.0 * kDefaultSidePadding - kDefaultInteritemPadding - size.width;
    
    float x = rect.size.width - remain - kDefaultSidePadding;
    float y = CenteredOrigin(rect.size.height, size.height);
    
    self.label.frame = (CGRect) {x, y, remain, size.height};
}


- (void)dateChange:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    if ([_delegate respondsToSelector:@selector(pickerViewCell:didSelectDate:)]) {
        [_delegate pickerViewCell:self didSelectDate:picker.date];
    }
}

#pragma mark - Picker View Data source

- (NSArray *)pickerValueArray
{
    NSArray *array = nil;
    if ([_delegate respondsToSelector:@selector(pickerViewCellValueArray:)]) {
        array = [_delegate pickerViewCellValueArray:self];
    }
    return array;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self pickerValueArray].count;
}

#pragma mark - Picker View Delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[self pickerValueArray] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([_delegate respondsToSelector:@selector(pickerViewCell:didSelectValueAtIndex:withText:)]) {
        [_delegate pickerViewCell:self didSelectValueAtIndex:row withText:[[self pickerValueArray] objectAtIndex:row]];
        self.label.text = [[self pickerValueArray] objectAtIndex:row];
        self.isPlaceholder = NO;
    }
}

- (void)setValueLabelText:(NSString *)text
{
    self.label.text = text;
    [self setNeedsLayout];
}

- (void)beginSelection;
{
    if ([_delegate respondsToSelector:@selector(pickerViewCellLabelBecomeFirstResponder:)]) {
        [_delegate pickerViewCellLabelBecomeFirstResponder:self];
    }
    
    if (_mode != PickerCellModePicker) {
        UIDatePicker *datepickerView = [[UIDatePicker alloc] init];
        datepickerView.backgroundColor = kAppBackgroundColor;
        if (_mode == PickerCellModeDate ) {
            datepickerView.datePickerMode = _mode == PickerCellModeDate;
        }else if (_mode == PickerCellModeDateTime){
            datepickerView.datePickerMode = UIDatePickerModeDateAndTime;
        }else{
            datepickerView.datePickerMode = UIDatePickerModeTime;
        }
        
        if ([_delegate respondsToSelector:@selector(pickerViewMaximumDate:)]) {
            datepickerView.maximumDate = [_delegate pickerViewMaximumDate:self];
        }
        
        if ([_delegate respondsToSelector:@selector(pickerViewMinimumDate:)]) {
            datepickerView.minimumDate = [_delegate pickerViewMinimumDate:self];
        }
        
        if ([_delegate respondsToSelector:@selector(pickerViewSelectedDate:)]) {
            datepickerView.date = [_delegate pickerViewSelectedDate:self];
        }
        
        [datepickerView addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.label setInputView:datepickerView andToolbar:[self addKeyBoardToolBar]];
    }
    else {
        
        NSInteger index = 0;
        if ([_delegate respondsToSelector:@selector(pickerViewCurrentSelectedIndex:)]) {
            index = [_delegate pickerViewCurrentSelectedIndex:self];
        }
        
        UIPickerView *picker = [[UIPickerView alloc] init];
        picker.backgroundColor = kAppBackgroundColor;
        picker.delegate = self;
        picker.dataSource = self;
        picker.backgroundColor = [UIColor clearColor];
        picker.showsSelectionIndicator = YES;
        [picker selectRow:index inComponent:0 animated:NO];
        
        [self.label setInputView:picker andToolbar:[self addKeyBoardToolBar]];
    }
    [self.label becomeFirstResponder];
}

- (UIToolbar *)addKeyBoardToolBar
{
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

- (void)toolBarPrevButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldGoToPreviousCell:)]) {
        [_delegate shouldGoToPreviousCell:self];
    }
}

- (void)toolBarNextButtonPressed:(id)sender
{
    if ([_delegate respondsToSelector:@selector(shouldGoToNextCell:)]) {
        [_delegate shouldGoToNextCell:self];
    }
}

- (void)toolBarDoneButtonPressed:(id)sender
{
    if ([self.label isFirstResponder]) {
        [self.label resignFirstResponder];
    }
}

- (void)resign
{
    [self.label resignFirstResponder];
}

@end
