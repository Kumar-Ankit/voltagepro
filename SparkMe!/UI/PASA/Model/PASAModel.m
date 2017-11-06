//
//  PASAModel.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/30/17.
//

#import "PASAModel.h"

@interface PASAModel()
@property (nonatomic, strong, readwrite) NSArray *stAllParams;
@end

@implementation PASAModel

- (id)init{
    self = [super init];
    if (self) {
        
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *dict in [STPASAParameterModel rawData]) {
            STPASAParameterModel *param = [[STPASAParameterModel alloc] initWithDictionary:dict];
            [temp addObject:param];
        }
        
        self.stAllParams = [NSArray arrayWithArray:temp];
        
        self.timeId = @"0";
        self.activeSTParameter = [self.stAllParams firstObject];
        self.regionId = @"NSW";

    }
    return self;
}



- (NSURL *)MTPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/mtpasa_chart.php?region=%@1&id=%@",self.regionId,self.timeId];
    return [NSURL URLWithString:string];
}

- (NSURL *)STPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/stpasa_chart.php?region=%@1&id=%@&id1=%@",self.regionId,self.timeId,self.activeSTParameter.serverText];
    return [NSURL URLWithString:string];
}

@end

#pragma mark - STALLParameters Model

@interface STPASAParameterModel()
@end

@implementation STPASAParameterModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self){
        self.actualText = dictionary[@"actualText"];
        self.shortText = dictionary[@"shortText"];
        self.serverText = dictionary[@"serverText"];
    }
    return self;
}

+ (NSArray *)rawData
{
    return @[
             @{@"actualText" : @"None",
               @"shortText"  : @"None" ,
               @"serverText" : @"NONE"},
             
             @{@"actualText" : @"10 POE Demand",
               @"shortText"  : @"10 POE" ,
               @"serverText" : @"demand10"},
             
             @{@"actualText" : @"50 POE demand",
               @"shortText"  : @"50 POE" ,
               @"serverText" : @"demand50"},
             
             @{@"actualText" : @"90 POE demand",
               @"shortText"  : @"90 POE" ,
               @"serverText" : @"demand90"},
             
             @{@"actualText" : @"Non sched gen (wind)",
               @"shortText"  : @"Wind" ,
               @"serverText" : @"NonSchedGen"},
             ];
}

@end
