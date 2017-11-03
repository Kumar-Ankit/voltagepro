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
        self.timeId = @"0";
        self.paramId = @"NONE";
        self.regionId = @"NSW";
        
        self.stAllParams = [PASAModel stParamsArray];
    }
    return self;
}

+ (NSArray *)stParamsArray{
    return @[@"NONE",
             @"demand10",
             @"demand50",
             @"demand90",
             @"NonSchedGen"];
}

+ (NSString *)shortNameForParamId:(NSString *)parmaId
{
    
    if ([parmaId isEqualToString:@"NONE"]) {
        return @"None";
    }
    
    if ([parmaId isEqualToString:@"demand10"]) {
        return @"DEM10";
    }
    
    if ([parmaId isEqualToString:@"demand50"]) {
        return @"DEM50";
    }
    
    if ([parmaId isEqualToString:@"demand90"]) {
        return @"DEM90";
    }
    
    if ([parmaId isEqualToString:@"NonSchedGen"]) {
        return @"Wind";
    }
    
    
    return @"Params";
}

- (NSURL *)MTPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/mtpasa_chart.php?region=%@1&id=%@",self.regionId,self.timeId];
    return [NSURL URLWithString:string];
}

- (NSURL *)STPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/stpasa_chart.php?region=%@1&id=%@&id1=%@",self.regionId,self.timeId,self.paramId];
    return [NSURL URLWithString:string];
}

@end
