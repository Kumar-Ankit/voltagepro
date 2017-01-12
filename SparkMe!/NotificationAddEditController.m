//
//  NotificationAddEditController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "NotificationAddEditController.h"
#import "VPDetailTextFieldCell.h"
#import "VPPickerViewCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "VPDataManager.h"
#import "Utility.h"

@interface NotificationAddEditController ()<VPTextFieldCellDelegate,VPPickerViewCellDelegate>
@property (nonatomic, strong) NSMutableIndexSet *invalidIndex;
@property (nonatomic, strong) NSArray *regions;
@property (nonatomic, strong) NSArray *sounds;
@property (nonatomic, strong) NSArray *alerts;
@end

@implementation NotificationAddEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppBackgroundColor;
<<<<<<< Updated upstream
    
    self.regions = @[@"NSW",@"QLD",@"SA",@"TAS",@"VIC"];
=======
    self.regions = @[@"NSW",@"QLD",@"SA",@"TAS",@"VIC",@"ALL"];
>>>>>>> Stashed changes
    self.alerts = @[@"5 MIN",@"5 MIN PreDesp.",@"30 MIN PreDesp."];
    self.sounds = @[@"Bird",@"Cat",@"Cashregister",@"Chewbacca",@"Chewy",@"Cow",@"Doh",@"Dolphin",
                    @"Elephant",@"Frog",@"Gameover",@"Horse",@"Pig",@"Raven"];

    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = (UIEdgeInsets) {-1.0, 0.0, 0.0, 0.0};;
    
    self.invalidIndex = [[NSMutableIndexSet alloc] init];
    
    if (_settingsType == NotificationSettingsTypeAdd)
    {
        self.title = @"Add Notification";
        self.model = [[NotificationSettings alloc] init];
        
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                        target:self
                                                                                        action:@selector(saveCellTapped:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
    }
    else
    {
        self.title = @"Edit Notification";
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(saveCellTapped:)];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"Your text here Your text here Your text here Your text here";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0)
    {
        VPPickerViewCell *cell = [self pickerCellForID:@"regionCell" path:indexPath tag:NotificationFieldTypeRegion titleText:@"Region" tfText:self.model.region pickerMode:PickerCellModePicker];
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        VPPickerViewCell *cell = [self pickerCellForID:@"alertForCell" path:indexPath tag:NotificationFieldTypeAlertFor titleText:@"Alert For" tfText:self.model.alert_for pickerMode:PickerCellModePicker];
        
        return cell;
    }
    else if (indexPath.row == 2)
    {
        VPDetailTextFieldCell *cell = [self tfCellForID:@"gtCell" path:indexPath tag:NotificationFieldTypeGreaterThan
                                              titleText:@"Greater Than" tfText:self.model.greater_than tfMode:TextFieldModeRealNumber];
        return cell;
    }
    else if (indexPath.row == 3)
    {
        VPDetailTextFieldCell *cell = [self tfCellForID:@"etCell" path:indexPath tag:NotificationFieldTypeEquals
                                              titleText:@"Equals To" tfText:self.model.equals_to tfMode:TextFieldModeRealNumber];
        return cell;
    }
    else if (indexPath.row == 4)
    {
        VPDetailTextFieldCell *cell = [self tfCellForID:@"ltCell" path:indexPath tag:NotificationFieldTypeLessThan
                                              titleText:@"Less Than" tfText:self.model.less_than tfMode:TextFieldModeRealNumber];
        return cell;
    }
    else
    {
        VPPickerViewCell *cell = [self pickerCellForID:@"soundCell" path:indexPath tag:NotificationFieldTypeSound titleText:@"Sound" tfText:self.model.sound pickerMode:PickerCellModePicker];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self activateIndex:indexPath];
}

- (VPDetailTextFieldCell *)tfCellForID:(NSString *)indentifier path:(NSIndexPath *)indexPath
                                   tag:(NSInteger)tag titleText:(NSString *)titleText
                                tfText:(NSString *)tfText tfMode:(TextFieldMode)mode
{
    VPDetailTextFieldCell *tfCell = [self.tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!tfCell) {
        tfCell = [[VPDetailTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:indentifier];
    }
    
    tfCell.currentIndexPath = indexPath;
    tfCell.delegate = self;
    tfCell.textField.placeholder = @"Price";
    tfCell.nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    tfCell.previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    tfCell.textField.tag = tag;
    tfCell.isInvalid = [self.invalidIndex containsIndex:tfCell.textField.tag];
    tfCell.titleText = titleText;
    tfCell.mode = mode;
    tfCell.textField.text = tfText;
    
    BOOL isFirstCell = indexPath.section == 0 && indexPath.row == 0;
    BOOL isLastCell = [self tableView:self.tableView numberOfRowsInSection:indexPath.section] -1 == indexPath.row;
    
    if (isFirstCell) {
        tfCell.previousIndexPath = nil;
    }
    
    if (isLastCell) {
        tfCell.nextIndexPath = nil;
    }
    
    if (self.tableView.style == UITableViewStylePlain) {
        tfCell.isLastCell = isLastCell;
    }
    return tfCell;
}

- (VPPickerViewCell *)pickerCellForID:(NSString *)indentifier path:(NSIndexPath *)indexPath
                              tag:(NSInteger)tag titleText:(NSString *)titleText
                                tfText:(NSString *)tfText pickerMode:(PickerCellMode)mode
{
    VPPickerViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[VPPickerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = tag;
    cell.textLabel.text = titleText;
    cell.previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    cell.nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    cell.currentIndexPath = indexPath;
    cell.mode = mode;
    cell.delegate = self;
    cell.isInvalid = [self.invalidIndex containsIndex:cell.tag];
    cell.isDetailMode = YES;
    if (tfText.length > 0) {
        [cell setValueLabelText:tfText];
        cell.isPlaceholder = NO;
    }
    else {
        cell.isPlaceholder = YES;
        [cell setValueLabelText:@"Required"];
    }
    
    BOOL isFirstCell = indexPath.section == 0 && indexPath.row == 0;
    BOOL isLastCell = [self tableView:self.tableView numberOfRowsInSection:indexPath.section] -1 == indexPath.row;
    
    if (isFirstCell) {
        cell.previousIndexPath = nil;
    }
    
    if (isLastCell) {
        cell.nextIndexPath = nil;
    }
    
    if (self.tableView.style == UITableViewStylePlain) {
        cell.isLastCell = isLastCell;
    }
    return cell;
}


#pragma mark - GRTextFieldCellDelegate method

- (void)textFieldCellDidBeginEditing:(VPTextFieldCell *)textFieldCell
{
    textFieldCell.isInvalid = NO;
    if ([self.invalidIndex containsIndex:textFieldCell.textField.tag]) {
        [self.invalidIndex removeIndex:textFieldCell.textField.tag];
    }
}
- (void)textFieldCell:(VPTextFieldCell *)textFieldCell didEndEditingWithText:(NSString *)text{
    [self.model setText:text withFieldTag:(NotificationFieldType)textFieldCell.textField.tag];
}

- (void)textFieldCellShouldGoToPreviousOne:(VPTextFieldCell *)textFieldCell
{
    if (textFieldCell.previousIndexPath) {
        [self activateIndex:textFieldCell.previousIndexPath];
    } else {
        [textFieldCell.textField resignFirstResponder];
    }
}

- (void)textFieldCellShouldReturn:(VPTextFieldCell *)textFieldCell
{
    if (textFieldCell.nextIndexPath) {
        [self activateIndex:textFieldCell.nextIndexPath];
    } else {
        [textFieldCell.textField resignFirstResponder];
    }
}

- (void)activateIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[VPTextFieldCell class]]) {
        VPTextFieldCell *dCell = (VPTextFieldCell *)cell;
        [dCell.textField becomeFirstResponder];
    }
    else if ([cell isKindOfClass:[VPPickerViewCell class]]) {
        VPPickerViewCell *pCell = (VPPickerViewCell *)cell;
        [pCell beginSelection];
    }
}

#pragma mark - VPPickerViewCellDelegate methods

- (void)pickerViewCellLabelBecomeFirstResponder:(VPPickerViewCell *)pickerCell{
    pickerCell.isInvalid = NO;
    if ([self.invalidIndex containsIndex:pickerCell.tag]) {
        [self.invalidIndex removeIndex:pickerCell.tag];
    }
    
    NSInteger index = [self pickerViewCurrentSelectedIndex:pickerCell];
    
    if (pickerCell.tag == NotificationFieldTypeRegion)
    {
        NSString *text = [self.regions objectAtIndex:index];
        [pickerCell setValueLabelText:text];
        [self.model setText:text withFieldTag:(NotificationFieldType)pickerCell.tag];
        pickerCell.isPlaceholder = NO;
    }
    else if (pickerCell.tag == NotificationFieldTypeAlertFor)
    {
        NSString *text = [self.alerts objectAtIndex:index];
        [pickerCell setValueLabelText:text];
        [self.model setText:text withFieldTag:(NotificationFieldType)pickerCell.tag];
        pickerCell.isPlaceholder = NO;
    }
    else if (pickerCell.tag == NotificationFieldTypeSound)
    {
        NSString *text = [self.sounds objectAtIndex:index];
        [pickerCell setValueLabelText:text];
        [self.model setText:text withFieldTag:(NotificationFieldType)pickerCell.tag];
        pickerCell.isPlaceholder = NO;
        [self playSound:text];
    }
}

- (void)pickerViewCell:(VPPickerViewCell *)pickerCell didSelectValueAtIndex:(NSInteger)index withText:(NSString *)text{
    [self.model setText:text withFieldTag:(NotificationFieldType)pickerCell.tag];
    
    if (pickerCell.tag == NotificationFieldTypeSound) {
        [self playSound:text];
    }
}

- (NSArray *)pickerViewCellValueArray:(VPPickerViewCell *)pickerCell{
    
    if (pickerCell.tag == NotificationFieldTypeRegion) {
        return self.regions;
    }else if (pickerCell.tag == NotificationFieldTypeAlertFor){
        return self.alerts;
    }else if (pickerCell.tag == NotificationFieldTypeSound){
        return self.sounds;
    }else{
        return @[];
    }
}

- (NSInteger)pickerViewCurrentSelectedIndex:(VPPickerViewCell *)pickerCell{
    
    if (pickerCell.tag == NotificationFieldTypeRegion)
    {
        if (self.model.region) {
            NSInteger index = [self.regions indexOfObject:self.model.region];
            if (index == NSNotFound) {
                return 0;
            }else{
                return index;
            }
        }
        return 0;
    }
    else if (pickerCell.tag == NotificationFieldTypeAlertFor)
    {
        if (self.model.alert_for) {
            NSInteger index = [self.alerts indexOfObject:self.model.alert_for];
            if (index == NSNotFound) {
                return 0;
            }else{
                return index;
            }
        }
        return 0;
    }
    else if (pickerCell.tag == NotificationFieldTypeSound)
    {
        if (self.model.sound) {
            NSInteger index = [self.sounds indexOfObject:self.model.sound];
            if (index == NSNotFound) {
                return 0;
            }else{
                return index;
            }
        }
        return 0;
    }
    else{
        return 0;
    }
}

- (void)shouldGoToNextCell:(VPPickerViewCell *)pickerCell
{
    if (pickerCell.nextIndexPath) {
        [self activateIndex:pickerCell.nextIndexPath];
    } else {
        [pickerCell resign];
    }
}

- (void)shouldGoToPreviousCell:(VPPickerViewCell *)pickerCell
{
    if (pickerCell.previousIndexPath) {
        [self activateIndex:pickerCell.previousIndexPath];
    }
    else {
        [pickerCell resign];
    }
}

-(void) playSound:(NSString *)sound
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:sound ofType:@"caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}

#pragma mark UserActions

- (BOOL)isAllEntryValid
{
    [self.view endEditing:YES];
    
    BOOL isValid = YES;
    
    if (!_model.region.length) {
        [self.invalidIndex addIndex:NotificationFieldTypeRegion];
        isValid = NO;
    }
    
    if (!_model.alert_for.length) {
        [self.invalidIndex addIndex:NotificationFieldTypeAlertFor];
        isValid = NO;
    }
    
    if (!_model.greater_than.length && !_model.equals_to.length  && !_model.less_than.length ) {
        [self.invalidIndex addIndex:NotificationFieldTypeGreaterThan];
        [self.invalidIndex addIndex:NotificationFieldTypeEquals];
        [self.invalidIndex addIndex:NotificationFieldTypeLessThan];
        isValid = NO;
    }
    
    if (!_model.sound.length) {
        [self.invalidIndex addIndex:NotificationFieldTypeSound];
        isValid = NO;
    }
    
    if (!isValid) {
        [self.tableView reloadData];
    }
    return isValid;
}

- (void)saveCellTapped:(id)sender{
    [self.view endEditing:YES];
    
    BOOL isValid = [self isAllEntryValid];
    if (isValid) {
        [self makeSaveWebService];
    }
}

- (void)makeSaveWebService
{
    if (!_model.greater_than) {
        self.model.greater_than = @"";
    }
    
    if (!_model.equals_to) {
        self.model.equals_to = @"";
    }
    
    if (!_model.less_than) {
        self.model.less_than = @"";
    }
    
    NSString *action, *n_id;
    if (_settingsType == NotificationSettingsTypeAdd) {
        action = @"setNotificationSettings";
        n_id = @"";
    }else{
        action = @"updateNotificationSettings";
        n_id = self.model.n_id;
    }

    NSDictionary *parms = @{@"action" : action,
                            @"id" : n_id,
                            @"username" : [Utility userName],
                            @"password" : [Utility password],
                            @"region" : self.model.region,
                            @"alert_for" : self.model.alert_for,
                            @"greater_than" : self.model.greater_than,
                            @"equals_to" : self.model.equals_to,
                            @"less_than" : self.model.less_than,
                            @"sound" : self.model.sound};
    
    __weak typeof(self)weakSelf = self;
    [Utility showHUDonView:self.view title:@"Saving ..."];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:self.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
        }else{
            if ([_delegate respondsToSelector:@selector(didDismissAddEditController:)]) {
                [_delegate didDismissAddEditController:self];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }   
        }
    }];
}

@end
