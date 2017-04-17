//
//  VPNetworkManager.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <AFNetworking/AFNetworking.h>
#define kBaseUrl @"http://hvbroker.azurewebsites.net/pushnotification/voltagepropushnotificationV2.php"

@interface VPNetworkManager : AFHTTPSessionManager
+ (VPNetworkManager *)sharedManger;
+ (VPNetworkManager *)aemoManger;

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)createDeleteRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                      withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock;

- (void)cancelAllTasks;
- (void)updateAEMOHeaders;
+ (NSError *)generalError;

@end
