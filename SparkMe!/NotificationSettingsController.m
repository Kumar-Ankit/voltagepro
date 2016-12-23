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

@interface NotificationSettingsController ()<NotificationAddEditControllerDelegate,VPSwitchCellDelegate>
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, assign) BOOL isAllMute;
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
    NotificationAddEditController *controller = [[NotificationAddEditController alloc] initWithStyle:UITableViewStyleGrouped];
    if (indexPath) {
        NotificationSettingsMTLModel *setting = self.notifications[indexPath.row];
        controller.model = setting;
        self.tableView.editing = NO;
    }
    controller.delegate = self;
    controller.settingsType = type;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
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
    [[VPDataManager sharedManager] setNotificationSettings:parms completion:^(BOOL status, NSError *error) {
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
    [[VPDataManager sharedManager] setNotificationSettings:parms completion:^(BOOL status, NSError *error) {
        [Utility hideHUDForView:weakSelf.view];
        if (error || !status) {
            [Utility showErrorAlertTitle:error.localizedFailureReason withMessage:error.localizedDescription];
        }
        else{
            [weakSelf downloadData];
        }
    }];
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
    if (section == 1) {
        return @"Your Notification Settings";
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }
    return 52.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.notifications.count ? self.notifications.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VPSwitchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"switchCell"];
        if (!cell) {
            cell = [[VPSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchCell"];
        }
        cell.delegate = self;
        cell.currentIndexPath = indexPath;
        [cell.prioritySwitch setOn:self.isAllMute];
        cell.textLabel.text = @"Mute all notifications";
        BOOL isLastCell = [self tableView:self.tableView numberOfRowsInSection:indexPath.section] -1 == indexPath.row;
        cell.isLastCell = isLastCell;
        return cell;
    }
    
    // For NO data
    if (!self.notifications.count) {
        static NSString *identifier = @"noDataCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor clearColor];
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
    
    BOOL isLastCell = [self tableView:self.tableView numberOfRowsInSection:indexPath.section] -1 == indexPath.row;
    cell.isLastCell = isLastCell;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && self.notifications.count) {
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
    self.isAllMute = cell.prioritySwitch.on;
    
    NSDictionary *parms = @{@"action" : @"muteAllAction",
                            @"username" : [Utility userName],
                            @"password" : [Utility password],
                            @"mute" : self.isAllMute ? @"1" : @"0"};
    
    __weak typeof(self) weakSelf = self;
    [Utility showHUDonView:self.view title:self.isAllMute ? @"Muting all notifications..." : @"Unmuting all notifications..."];
    [[VPDataManager sharedManager] setNotificationSettings:parms completion:^(BOOL status, NSError *error) {
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
@end
