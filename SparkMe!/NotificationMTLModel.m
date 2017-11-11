//
//  NotificationSettingsMTLModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "NotificationMTLModel.h"

@implementation NotificationMTLModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"isAllMute" : @"isAllMute",
             @"isSleep" : @"isSleep",
             @"sleepEndTime" : @"sleepEndTime",
             @"sleepStartTime" : @"sleepStartTime",
             @"settings": @"ResponseData"};
}

+ (NSValueTransformer *)settingsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NotificationSettings class]];
}

- (NSString *)sleepEndTime{
    if (!_sleepEndTime.length) {
        return @"07:00";
    }
    return _sleepEndTime;
}

- (NSString *)sleepStartTime{
    if (!_sleepStartTime.length) {
        return @"22:00";
    }
    return _sleepStartTime;
}

@end

@implementation NotificationSettings

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"n_id"  : @"id",
             @"region" : @"region",
             @"alert_for" : @"alert_for",
             @"greater_than"    : @"greater_than",
             @"less_than"   : @"less_than",
             @"price" : @[@"less_than",@"greater_than"],
             @"sound" : @"sound",
             @"is_mute" : @"is_mute"
             };
}

- (id)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error{
    
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        if (self.less_than.length) {
            self.priceForMode = PriceForLessThan;
        }
        else if (self.greater_than.length) {
            self.priceForMode = PriceForGreaterThan;
        }
        else{
            self.priceForMode = PriceForNone;
        }
    }
    
    return self;
}

+ (NSValueTransformer *)priceJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id values, BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *less_than = values[@"less_than"];
        NSString *greater_than = values[@"greater_than"];
        
        if (less_than.length) {
            return less_than;
        }
        else if (greater_than.length) {
            return greater_than;
        }else{
            return nil;
        }
    }];
}

- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag{
    [self setText:text withFieldTag:tag pickerIndex:NSNotFound];
}

- (void)setText:(id)text withFieldTag:(NotificationFieldType)tag pickerIndex:(NSInteger)index
{
    if (tag == NotificationFieldTypeRegion){
        self.region = text;
    }
    else if (tag == NotificationFieldTypeAlertFor){
        self.alert_for = text;
    }
    else if (tag == NotificationFieldTypePrice){
        self.price = text;
        
        switch (self.priceForMode) {
            case PriceForLessThan:
                self.less_than = text;
                self.greater_than = nil;
                break;
                
            case PriceForGreaterThan:
                self.less_than = nil;
                self.greater_than = text;
                break;
                
            case PriceForNone:
                self.less_than = nil;
                self.greater_than = nil;
                break;
        }
    }
    else if (tag == NotificationFieldTypeSound){
        self.sound = text;
    }
    else if (tag == NotificationFieldTypePriceRange)
    {
        self.priceFor = text;
        
        switch (index) {
            case 0:
                self.priceForMode = PriceForLessThan;
                self.less_than = self.price;
                self.greater_than = nil;
                break;
                
            case 1:
                self.priceForMode = PriceForGreaterThan;
                self.greater_than = self.price;
                self.less_than = nil;
                break;
                
            default:
                self.priceForMode = PriceForNone;
                self.less_than = nil;
                self.greater_than = nil;
                break;
        }
    }
}

@end
