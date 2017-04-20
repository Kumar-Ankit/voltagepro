//
//  VPDataManager.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPDataManager.h"
#import "VPNetworkManager.h"
#import "Utility.h"

@interface VPDataManager ()
@property (nonatomic, strong) NSMutableArray *activeURLs;
@end

@implementation VPDataManager

+(VPDataManager * )sharedManager
{
    static dispatch_once_t onceToken;
    static VPDataManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        [self initialize];
        sharedManager = [[super allocWithZone:nil] init];
        [sharedManager setup];
    });
    return sharedManager;
}

- (void)setup{
    self.activeURLs = [NSMutableArray new];
}

- (void)getNotificationSettings:(NSDictionary *)parameters completion:(void (^)(NotificationMTLModel *, NSError *))completionBlock
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
            
            NSError *mtlError;
            NotificationMTLModel *settings = [MTLJSONAdapter modelOfClass:[NotificationMTLModel class]
                                                       fromJSONDictionary:responseObject error:&mtlError];
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

- (void)setSettings:(NSDictionary *)parameters completion:(void (^)(BOOL, NSError *))completionBlock
{
    if (!parameters) {
        if (completionBlock) {
            completionBlock (NO, [VPNetworkManager generalError]);
            return;
        }
    }
    
    [[VPNetworkManager sharedManger] createPostRequestWithParameters:parameters withRequestPath:kBaseUrl withCompletionBlock:^(id responseObject, NSError *error) {
        
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

- (void)fetchAEMOData:(NSDictionary *)parameters completion:(void (^)(NSDictionary *, NSError *))completionBlock
{
    if (!parameters) {
        parameters = @{};
    }

    if ([self.activeURLs containsObject:parameters]) {
        return;
    }else{
        [self.activeURLs addObject:parameters];
    }
    
    [[VPNetworkManager aemoManger] createPostRequestWithParameters:parameters withRequestPath:@"" withCompletionBlock:^(id responseObject, NSError *error) {
        
        [self.activeURLs removeObject:parameters];
        
        if (error)
        {
            if (completionBlock) {
                completionBlock (nil ,error);
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            if (completionBlock) {
                completionBlock (responseObject , nil);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock (nil, [VPNetworkManager generalError]);
                return;
            }
        }
    }];
}

- (void)loadDataWithContentsOfURL:(NSString *)ulrStr withSelectedIndex:(NSInteger)index completion:(void (^)(NSData *, NSError *, NSInteger))completionBlock
{
    if (!ulrStr) {
        if (completionBlock) {
            completionBlock (nil, [VPNetworkManager generalError], index);
            return;
        }
    }
    
    NSString *keyUrl = [NSString stringWithFormat:@"%@_%ld",ulrStr,index];
    if ([self.activeURLs containsObject:keyUrl]) {
        return;
    }else{
        [self.activeURLs addObject:keyUrl];
    }
    
    NSURL *url = [NSURL URLWithString:ulrStr];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSError *error;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        [self.activeURLs removeObject:keyUrl];
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(data, error, index);
            });
        }
    });
}

- (void)postDataForPathWithParams:(NSDictionary *)parameters completion:(void (^)(BOOL, NSError *))completionBlock
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
