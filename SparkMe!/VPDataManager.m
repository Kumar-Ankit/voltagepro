//
//  VPDataManager.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPDataManager.h"
#import "VPNetworkManager.h"
#import "NotificationSettingsMTLModel.h"
#import "Utility.h"

@implementation VPDataManager

+(VPDataManager * )sharedManager
{
    static dispatch_once_t onceToken;
    static VPDataManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        [self initialize];
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}

- (void)getNotificationSettings:(NSDictionary *)parameters completion:(void (^)(NSArray *, NSError *))completionBlock
{
    if (!parameters) {
        if (completionBlock) {
            completionBlock (nil, [VPNetworkManager generalError]);
            return;
        }
    }
    
    [[VPNetworkManager sharedManger] createPostRequestWithParameters:parameters withRequestPath:@"" withCompletionBlock:^(id responseObject, NSError *error) {
        
        if (error){
            if (completionBlock) {
                completionBlock (nil ,error);
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]){
            
            [Utility saveData:responseObject[@"isAllMute"] forKey:IS_ALL_MUTE_KEY];
            NSArray *responseData = responseObject[@"ResponseData"];
            NSError *mtlError;
            NSArray *settings = [MTLJSONAdapter modelsOfClass:[NotificationSettingsMTLModel class]
                                                fromJSONArray:responseData error:&mtlError];
            if (completionBlock) {
                completionBlock (settings , nil);
            }
        }
        else{
            if (completionBlock) {
                completionBlock (nil, [VPNetworkManager generalError]);
                return;
            }
        }
    }];
}

- (void)setNotificationSettings:(NSDictionary *)parameters completion:(void (^)(BOOL, NSError *))completionBlock
{
    if (!parameters) {
        if (completionBlock) {
            completionBlock (NO, [VPNetworkManager generalError]);
            return;
        }
    }
    
    [[VPNetworkManager sharedManger] createPostRequestWithParameters:parameters withRequestPath:@"" withCompletionBlock:^(id responseObject, NSError *error) {
        
        if (error){
            if (completionBlock) {
                completionBlock (NO ,error);
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSString *code = responseObject[@"ResponseCode"];
            if (completionBlock) {
                completionBlock (!code.boolValue , nil);
            }
        }
        else{
            if (completionBlock) {
                completionBlock (NO, [VPNetworkManager generalError]);
                return;
            }
        }
    }];
}

@end
