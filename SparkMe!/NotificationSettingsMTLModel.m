//
//  NotificationSettingsMTLModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "NotificationSettingsMTLModel.h"

@implementation NotificationSettingsMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"n_id"  : @"id",
             @"region" : @"region",
             @"alert_for" : @"alert_for",
             @"greater_than"    : @"greater_than",
             @"equals_to" : @"equals_to",
             @"less_than"   : @"less_than",
             @"sound" : @"sound",
             @"is_mute" : @"is_mute"
             };
}

- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag
{
    if (tag == NotificationFieldTypeRegion){
        self.region = text;
    }
    else if (tag == NotificationFieldTypeAlertFor){
        self.alert_for = text;
    }
    else if (tag == NotificationFieldTypeGreaterThan){
        self.greater_than = text;
    }
    else if (tag == NotificationFieldTypeEquals){
        self.equals_to = text;
    }
    else if (tag == NotificationFieldTypeLessThan){
        self.less_than = text;
    }
    else if (tag == NotificationFieldTypeSound){
        self.sound = text;
    }
}

@end
