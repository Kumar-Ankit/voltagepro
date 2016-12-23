//
//  VPNetworkManager.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <AFNetworking/AFNetworking.h>

@interface VPNetworkManager : AFHTTPSessionManager
+ (VPNetworkManager *)sharedManger;

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
- (void)updateHeaders;
+ (NSError *)generalError;

@end
