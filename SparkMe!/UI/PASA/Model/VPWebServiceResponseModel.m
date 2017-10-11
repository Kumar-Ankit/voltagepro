//
//  VPWebServiceResponseModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import "VPWebServiceResponseModel.h"

@implementation VPWebServiceResponseModel
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)stringValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    
    return nil;
}

- (NSNumber *)numberValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    
    if ([value isKindOfClass:[NSString class]]) {
        return @([value doubleValue]);
    }
    
    return nil;
}

@end
