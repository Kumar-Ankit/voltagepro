//
//  VPPickerViewCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <UIKit/UIKit.h>
#import "VPTableViewCell.h"
#import "VPPickerLabel.h"

typedef enum {
    PickerCellModePicker = 0,
    PickerCellModeDate = 1,
    PickerCellModeDateTime = 2
} PickerCellMode;

@class VPPickerViewCell;

@protocol VPPickerViewCellDelegate <NSObject>

- (void)shouldGoToPreviousCell:(VPPickerViewCell *)pickerCell;
- (void)shouldGoToNextCell :(VPPickerViewCell *)pickerCell;
- (void)pickerViewCellLabelBecomeFirstResponder:(VPPickerViewCell *)pickerCell;

@optional

- (void)pickerViewCell:(VPPickerViewCell *)pickerCell didSelectValueAtIndex:(NSInteger)index withText:(NSString *)text;
- (void)pickerViewCell:(VPPickerViewCell *)pickerCell didSelectDate:(NSDate *)date;

- (NSArray *)pickerViewCellValueArray:(VPPickerViewCell *)pickerCell;
- (NSInteger)pickerViewCurrentSelectedIndex:(VPPickerViewCell *)pickerCell;

- (NSDate *)pickerViewSelectedDate:(VPPickerViewCell *)pickerCell;
- (NSDate *)pickerViewMinimumDate:(VPPickerViewCell *)pickerCell;
- (NSDate *)pickerViewMaximumDate:(VPPickerViewCell *)pickerCell;
@end

@interface VPPickerViewCell : VPTableViewCell<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) PickerCellMode mode;
@property (nonatomic, weak) id <VPPickerViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *nextIndexPath;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

- (void)setValueLabelText:(NSString *)text;
- (void)beginSelection;;
- (void)resign;

@end
