//
//  NotificationAddEditController.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <UIKit/UIKit.h>
#import "NotificationSettingsMTLModel.h"

typedef enum{
    NotificationSettingsTypeAdd,
    NotificationSettingsTypeEdit,
}NotificationSettingsType;

@class NotificationAddEditController;

@protocol NotificationAddEditControllerDelegate <NSObject>
- (void)didDismissAddEditController:(NotificationAddEditController*)controller;
@end

@interface NotificationAddEditController : UITableViewController
@property (nonatomic, assign) NotificationSettingsType settingsType;
@property (nonatomic, strong) NotificationSettingsMTLModel *model;
@property (nonatomic, weak) id<NotificationAddEditControllerDelegate> delegate;

@end
