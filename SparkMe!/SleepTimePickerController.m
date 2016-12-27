//
//  SleepTimePickerController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/24/16.
//
//

#import "SleepTimePickerController.h"
#import "VPPickerViewCell.h"
#import "Utility.h"
#import "VPDataManager.h"

@interface SleepTimePickerController ()<VPPickerViewCellDelegate>
@property (nonatomic, strong) NSMutableIndexSet *invalidIndex;
@end

@implementation SleepTimePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sleep Timings";
    self.view.backgroundColor = kAppBackgroundColor;
    self.tableView.tableFooterView = [UIView new];
    self.invalidIndex = [[NSMutableIndexSet alloc] init];

    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                    target:self
                                                                                    action:@selector(saveTapped:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        VPPickerViewCell *cell = [self pickerCellForID:@"fromCell" path:indexPath tag:SleepTimeTypeFrom
                                             titleText:@"From"
                                                tfText:self.from
                                            pickerMode:PickerCellModeTime];
        
        return cell;
    }
    else
    {
        VPPickerViewCell *cell = [self pickerCellForID:@"toCell" path:indexPath tag:SleepTimeTypeTo
                                             titleText:@"To"
                                                tfText:self.to
                                            pickerMode:PickerCellModeTime];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self activateIndex:indexPath];
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
    
    cell.isLastCell = isLastCell;
    
    return cell;
}

#pragma mark - VPPickerViewCellDelegate methods

- (void)pickerViewCell:(VPPickerViewCell *)pickerCell didSelectDate:(NSDate *)date{
    NSString *dString = [[[Utility shared] am_pm_formatter] stringFromDate:date];
    [pickerCell setValueLabelText:dString];
    if (pickerCell.tag == SleepTimeTypeFrom) {
        self.from = dString;
    }else{
        self.to = dString;
    }
}

- (NSDate *)pickerViewSelectedDate:(VPPickerViewCell *)pickerCell{
    if (pickerCell.tag == SleepTimeTypeFrom) {
        NSDate *date = [[[Utility shared] am_pm_formatter] dateFromString:self.from];
        return date;
    }else{
        NSDate *date = [[[Utility shared] am_pm_formatter] dateFromString:self.to];
        return date;
    }
}

- (void)pickerViewCellLabelBecomeFirstResponder:(VPPickerViewCell *)pickerCell{
    pickerCell.isInvalid = NO;
    if ([self.invalidIndex containsIndex:pickerCell.tag]) {
        [self.invalidIndex removeIndex:pickerCell.tag];
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

- (void)activateIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[VPPickerViewCell class]]) {
        VPPickerViewCell *pCell = (VPPickerViewCell *)cell;
        [pCell beginSelection];
    }
}


#pragma mark User Actions

- (BOOL)isAllEntryValid
{
    [self.view endEditing:YES];
    
    BOOL isValid = YES;
    
    if (!_from.length) {
        [self.invalidIndex addIndex:SleepTimeTypeFrom];
        isValid = NO;
    }
    
    if (!_to.length) {
        [self.invalidIndex addIndex:SleepTimeTypeTo];
        isValid = NO;
    }
    
    if (!isValid) {
        [self.tableView reloadData];
    }
    return isValid;
}


- (void)saveTapped:(id)sender{
    if ([self isAllEntryValid]) {
        [self makeWebServiceCall];
    }
}

- (void)makeWebServiceCall
{
    NSDictionary *parms = @{@"action" : @"sleepSettings",
                            @"username" : [Utility userName],
                            @"password" : [Utility password],
                            @"sleep" : @"1",
                            @"sleep_start_time" : [[Utility shared]time24FromTimeString:self.from],
                            @"sleep_end_time" : [[Utility shared]time24FromTimeString:self.to]
                            };
    
    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:@"Saving ..."];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
        }
        else{
            [Utility saveData:parms[@"sleep"] forKey:IS_SLEEP_KEY];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([_delegate respondsToSelector:@selector(didDismissSleepTimePickerController:)]) {
                [_delegate didDismissSleepTimePickerController:self];
            }
        }
    }];
}

@end
