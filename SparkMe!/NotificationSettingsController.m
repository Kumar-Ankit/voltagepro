//
//  NotificationSettingsController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "NotificationSettingsController.h"
#import "NotificationAddEditController.h"
#import "Utility.h"
#import "VPDataManager.h"
#import "NotificationSettingsMTLModel.h"
#import "VPTableViewCell.h"
#import "VPSwitchCell.h"
#import "VPSleepFooterView.h"
#import "SleepTimePickerController.h"

@interface NotificationSettingsController ()<NotificationAddEditControllerDelegate,VPSwitchCellDelegate>
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, assign) BOOL isAllMute;
@property (nonatomic, assign) BOOL isSleep;
@end

@implementation NotificationSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notification Settings";
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = kAppBackgroundColor;
    
    UIBarButtonItem *bBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                           target:nil action:nil];
    self.navigationItem.backBarButtonItem = bBtn;
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(dismissView:)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addNotification:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [self downloadData];
}

- (void)downloadData
{
    NSDictionary *params = @{@"action" : @"getNotificationSettings",
                             @"username" : [Utility userName],
                             @"password" : [Utility password],
                             };
    
    __weak typeof(self) weakSelf = self;
    
    [Utility showHUDonView:self.view];
    [[VPDataManager sharedManager] getNotificationSettings:params completion:^(NSArray *response, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        [weakSelf processData:response withError:error];
    }];
}

- (void)processData:(NSArray *)notifications withError:(NSError *)error{
    
    if (error) {
        [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
    }
    self.notifications = notifications;
    self.isAllMute = [[Utility dataForKey:IS_ALL_MUTE_KEY] boolValue];
    self.isSleep = [[Utility dataForKey:IS_SLEEP_KEY] boolValue];
    [self.tableView reloadData];
}

#pragma mark UserActions

- (void)dismissView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addNotification:(id)sender{
    [self openAddEditController:NotificationSettingsTypeAdd withIndexPath:nil];
}

- (void)openAddEditController:(NotificationSettingsType)type withIndexPath:(NSIndexPath *)indexPath
{
    NotificationAddEditController *controller = [[NotificationAddEditController alloc] initWithStyle:UITableViewStylePlain];
    if (type == NotificationSettingsTypeEdit) {
        NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
        controller.model = setting;
        self.tableView.editing = NO;
    }
    controller.delegate = self;
    controller.settingsType = type;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)muteActionForIndexPath:(NSIndexPath *)indexPath
{
    NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
    NSString *muteText;
    if (setting.is_mute.boolValue == YES) {
        muteText = @"0";
    }else{
        muteText = @"1";
    }
    NSDictionary *parms = @{@"action" : @"muteAction",
                            @"mute" : muteText,
                            @"id":  setting.n_id};

    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:muteText.boolValue ? @"Muting..." : @"Unmuting..."];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
        }
        else{
            [weakSelf downloadData];
        }
    }];
}

- (void)deleteSettings:(NSIndexPath *)indexPath
{
    NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
    
    NSDictionary *parms = @{@"action" : @"deleteNotificationSetting",
                            @"id":  setting.n_id};
    
    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:@"Deleting ..."];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
        }
        else{
            [weakSelf downloadData];
        }
    }];
}

- (void)editSleepTimingsTapped:(id)sender
{
    SleepTimePickerController *sleep = [[SleepTimePickerController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:sleep animated:YES];
}

#pragma mark Utils

- (NSString *)labelText:(NotificationSettingsMTLModel *)setting{
    NSString *string = [NSString stringWithFormat:@"Region: %@ | %@",setting.region,setting.alert_for];
    return string;
}

- (NSString *)detailLabelText:(NotificationSettingsMTLModel *)setting
{
    NSString *detailText = @"";
    
    if (setting.less_than.length) {
        detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@"Price < %@",[[Utility shared]                                                                                                   currencyStringFromString:setting.less_than]]];
    }
    
    if (setting.equals_to.length) {
        
        if (detailText.length) {
            detailText = [detailText stringByAppendingString:@" | "];
        }
        
        detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@"Price = %@",[[Utility shared]                                                                                                   currencyStringFromString:setting.equals_to]]];
    }
    
    if (setting.greater_than.length) {
        
        if (detailText.length) {
            detailText = [detailText stringByAppendingString:@" | "];
        }
        
        detailText = [detailText stringByAppendingString:[NSString stringWithFormat:@"Price > %@",[[Utility shared]                                                                                                   currencyStringFromString:setting.greater_than]]];
    }
    
    return detailText;
}


#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 2 && self.notifications.count) {
        return @"Your Notification Settings";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        VPSleepFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VPSleepFooterView"];
        if (!footer) {
            footer = [[VPSleepFooterView alloc] initWithReuseIdentifier:@"VPSleepFooterView"];
        }
        [footer.btnEdit addTarget:self action:@selector(editSleepTimingsTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
        [footer setFrom:@"10:00 PM" to:@"7:10 AM"];
        return footer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return [VPSleepFooterView heightForWidth:tableView.bounds.size.width];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 52.0;
    }
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 2) {
        return self.notifications.count ? self.notifications.count : 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        VPSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"VPSwitchCell"];
        if (!cell) {
            cell = [[VPSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VPSwitchCell"];
        }
        cell.delegate = self;
        cell.currentIndexPath = indexPath;
        if (indexPath.section == 0) {
            [cell.prioritySwitch setOn:self.isAllMute];
            cell.textLabel.text = @"Mute all notifications";
            cell.switchCellMode = VPSwitchCellModeMute;
        }else{
            [cell.prioritySwitch setOn:self.isSleep];
            cell.textLabel.text = @"Sleep";
            cell.switchCellMode = VPSwitchCellModeSleep;
        }
        return cell;
    }
    else
    {
        // For NO data
        if (!self.notifications.count) {
            static NSString *identifier = @"noDataCell";
            VPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[VPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.isDetailMode = YES;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.textLabel.text = @"Oops! You don't any notification settings.";
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return cell;
        }
        
        // Poupulating Notifications Settings
        static NSString *identifier = @"dataCell";
        VPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[VPTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
        cell.textLabel.text = [self labelText:setting];
        cell.detailTextLabel.text = [self detailLabelText:setting];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && self.notifications.count) {
        [self openAddEditController:NotificationSettingsTypeEdit withIndexPath:indexPath];
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                            title:@"Delete"
                                                                          handler:^(UITableViewRowAction *action, NSIndexPath *swipedIndexPath) {
                                                                              [self deleteSettings:swipedIndexPath];
                                                                          }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:@"Edit"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *swipedIndexPath) {
                                                                            [self openAddEditController:NotificationSettingsTypeEdit withIndexPath:swipedIndexPath];
                                                                        }];
    
    NSString *muteText;
    NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
    if (setting.is_mute.boolValue == YES) {
        muteText = @"Unmute";
    }else{
        muteText = @"Mute";
    }
    
    UITableViewRowAction *muteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
                                                                          title:muteText
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *swipedIndexPath) {
                                                                            [self muteActionForIndexPath:swipedIndexPath];
                                                                        }];

    muteAction.backgroundColor = GRAY(0.85);
    deleteAction.backgroundColor = kAppSelectionRedColor;
    editAction.backgroundColor = kAppSelectionBlueColor;
    return @[deleteAction,editAction,muteAction];
}


#pragma mark - NotificationAddEditControllerDelegate

- (void)didDismissAddEditController:(NotificationAddEditController *)controller{
    [self downloadData];
}

#pragma mark VPSwitchCellDelegate
- (void)switchButtonValueChangeWithCell:(VPSwitchCell *)cell{
    if (cell.switchCellMode == VPSwitchCellModeMute) {
        self.isAllMute = cell.prioritySwitch.on;
        [self processMuteCellAction];
    }
    else if (cell.switchCellMode == VPSwitchCellModeSleep) {
        self.isSleep = cell.prioritySwitch.on;
        [self processSleepCellAction];
    }
}

- (void)processMuteCellAction
{
    NSDictionary *parms = @{@"action" : @"muteAllAction",
                            @"username" : [Utility userName],
                            @"password" : [Utility password],
                            @"mute" : self.isAllMute ? @"1" : @"0"};
    
    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:self.isAllMute ? @"Muting all notifications..." : @"Unmuting all notifications..."];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
            weakSelf.isAllMute = !weakSelf.isAllMute;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            [Utility saveData:parms[@"mute"] forKey:IS_ALL_MUTE_KEY];
            [weakSelf downloadData];
        }
    }];
}

- (void)processSleepCellAction
{
    NSDictionary *parms = @{@"action" : @"sleepSettings",
                            @"username" : [Utility userName],
                            @"password" : [Utility password],
                            @"sleep" : self.isSleep ? @"1" : @"0",
                            @"sleep_start_time" : @"22:00",
                            @"sleep_end_time" : @"07:00",
                            };
    
    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:self.isSleep ? @"Sleep On" : @"Sleep Off"];
    [[VPDataManager sharedManager] setSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
            weakSelf.isSleep = !weakSelf.isSleep;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                                      withRowAnimation:UITableViewRowAnimationFade];
        }
        else{
            [Utility saveData:parms[@"sleep"] forKey:IS_SLEEP_KEY];
            [weakSelf downloadData];
        }
    }];
}

@end
