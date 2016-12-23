//
//  PVTextFieldCell.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <UIKit/UIKit.h>
#import "VPTextField.h"
#import "VPTableViewCell.h"

typedef enum {
    TextFieldModeNone,
    TextFieldModeName,
    TextFieldModeEmail,
    TextFieldModeAddress,
    TextFieldModePassword,
    TextFieldModePhoneNumber,
    TextFieldModeRealNumber
} TextFieldMode;

@class VPTextFieldCell;

@protocol VPTextFieldCellDelegate <NSObject>

- (void)textFieldCell:(VPTextFieldCell *)textFieldCell didEndEditingWithText:(NSString *)text;
- (void)textFieldCellDidBeginEditing:(VPTextFieldCell *)textFieldCell;
- (void)textFieldCellShouldReturn:(VPTextFieldCell *)textFieldCell;
- (void)textFieldCellShouldGoToPreviousOne:(VPTextFieldCell *)textFieldCell;

@end


@interface VPTextFieldCell : VPTableViewCell
@property (nonatomic, weak) id <VPTextFieldCellDelegate> delegate;
@property (nonatomic, assign) TextFieldMode mode;

@property (nonatomic, strong) VPTextField *textField;
@property (nonatomic, strong) NSIndexPath *nextIndexPath;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) NSIndexPath *previousIndexPath;

@end
