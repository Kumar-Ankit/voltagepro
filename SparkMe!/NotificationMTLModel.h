//
//  NotificationSettingsMTLModel.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <Mantle/Mantle.h>

typedef enum{
    NotificationFieldTypeNone,
    NotificationFieldTypeRegion,
    NotificationFieldTypeAlertFor,
    NotificationFieldTypeGreaterThan,
   // NotificationFieldTypeEquals,
    NotificationFieldTypeLessThan,
    NotificationFieldTypeSound
}NotificationFieldType;

@interface NotificationMTLModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign) BOOL isAllMute;
@property (nonatomic, assign) BOOL isSleep;
@property (nonatomic, strong) NSString *sleepEndTime;
@property (nonatomic, strong) NSString *sleepStartTime;
@property (nonatomic, strong) NSArray *settings;
@end

@interface NotificationSettings : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *n_id;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *alert_for;
@property (nonatomic, strong) NSString *greater_than;
//@property (nonatomic, strong) NSString *equals_to;
@property (nonatomic, strong) NSString *less_than;
@property (nonatomic, strong) NSString *sound;
@property (nonatomic, strong) NSString *is_mute;

- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag;

@end
