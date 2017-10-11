//
//  VPPASADataModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import "VPPASADataModel.h"
#import "Utility.h"

@implementation VPPASADataModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {

        self.publish_date = dictionary[@"publish_date"];
        
        NSMutableArray *temp = [NSMutableArray new];
        if ([dictionary[@"ResponseData"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *itemDict in dictionary[@"ResponseData"]) {
                VPPASAItem *item = [[VPPASAItem alloc] initWithDictionary:itemDict];
                [temp addObject:item];
            }
        }
        
        self.pasaItems = [NSArray arrayWithArray:temp];
        
    }
    return self;
}

@end

@implementation VPPASAItem

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        
        self.mt_pasa = [self numberValue:dictionary[@"mt_pasa"]];
        self.pasa_delta = [self numberValue:dictionary[@"pasa_delta"]];
        
        NSString *dateTime = dictionary[@"day"];
        if (dateTime.length) {
            self.day = [[Utility shared] pasaDateFromServerDate:dateTime];
        }
    }
    return self;
}

@end
