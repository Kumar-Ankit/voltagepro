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
    NotificationFieldTypePriceRange,
    NotificationFieldTypePrice,
    NotificationFieldTypeSound
}NotificationFieldType;

typedef enum{
    PriceForNone,
    PriceForGreaterThan,
    PriceForLessThan
}PriceForMode;

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
@property (nonatomic, strong) NSString *less_than;
@property (nonatomic, strong) NSString *sound;
@property (nonatomic, strong) NSString *is_mute;

@property (nonatomic, strong) NSString *priceFor;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, assign) PriceForMode priceForMode;

- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag;
- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag pickerIndex:(NSInteger)index;

@end
