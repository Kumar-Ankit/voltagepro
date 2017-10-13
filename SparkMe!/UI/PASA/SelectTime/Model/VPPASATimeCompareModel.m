//
//  VPPASATimeCompareModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/14/17.
//

#import "VPPASATimeCompareModel.h"

@implementation VPPASATimeCompareModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    
    if (self) {
        self.time = dictionary[@"time"];
        self.time_id = dictionary[@"id"];
    }
    
    return self;
}

@end
