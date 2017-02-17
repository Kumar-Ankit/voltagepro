//
//  VPNetworkManager.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPNetworkManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#define AEMO_URL @"http://aemo.com.au/aemo/apps/api/report/5MIN"
#define kShowNetworkResponses 1

typedef enum{
    VPNetworkManagerModeNotification,
    VPNetworkManagerModeAEMO
}VPNetworkManagerMode;

@implementation VPNetworkManager

// For hvbpreproduction.azurewebsites.net Network Call
+(VPNetworkManager *)sharedManger
{
    static dispatch_once_t onceToken;
    static VPNetworkManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSURL alloc] initWithString:kBaseUrl];
        sharedManager = [[self alloc] initWithBaseURL:url mode:VPNetworkManagerModeNotification];
    });
    return sharedManager;
}

// For aemo.com.au Network Call
+(VPNetworkManager *)aemoManger
{
    static dispatch_once_t onceToken;
    static VPNetworkManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSURL alloc] initWithString:AEMO_URL];
        sharedManager = [[self alloc] initWithBaseURL:url mode:VPNetworkManagerModeAEMO];
        [sharedManager updateAEMOHeaders];
    });
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url mode:(VPNetworkManagerMode)mode
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        AFJSONResponseSerializer *responseSer = [AFJSONResponseSerializer serializer];
        responseSer.removesKeysWithNullValues = YES;
        responseSer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        self.responseSerializer = responseSer;
        
        if (mode == VPNetworkManagerModeAEMO) {
            self.requestSerializer = [AFJSONRequestSerializer serializer];
        }else{
            self.requestSerializer = [AFHTTPRequestSerializer serializer];
        }
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateAEMOHeaders
{
    NSDictionary *headers = @{ @"origin": @"http://aemo.com.au",
                               @"accept": @"*/*",
                               @"referer": @"http://aemo.com.au/aemo/apps/visualisations/elec-priceanddemand.html",
                               @"accept-encoding": @"gzip, deflate",
                               @"accept-language": @"en-US,en;q=0.8",
                               @"cache-control": @"no-cache"};
    
    for (NSString *key in [headers allKeys]) {
        NSString *value = headers[key];
        [self.requestSerializer setValue:value forHTTPHeaderField:key];
    }
}

- (void)processNetworkError:(NSError *)error task:(NSURLSessionDataTask *)task withCompletion:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (kShowNetworkResponses) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSInteger code = httpResponse.statusCode;
        
        NSLog(@"Network Error : %@, %i, %@", task.originalRequest.URL, (int)code, error.localizedDescription);
    }
    
    if (completionBlock) {
        completionBlock(nil, error);
    }
}

- (void)processNetworkResponse:(id)responseObject task:(NSURLSessionDataTask *)task withCompletion:(void(^)(id responseObject, NSError *error))completionBlock
{
    @try
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSInteger code = httpResponse.statusCode;
        
        if (kShowNetworkResponses) {
            NSLog(@"Network Response : %@, %i, %@", task.originalRequest.URL, (int)code, responseObject);
        }
        
        if (completionBlock) {
            completionBlock(responseObject, nil);
        }
    }
    @catch (NSException *e)
    {
        if (completionBlock) {
            completionBlock(nil, [VPNetworkManager generalError]);
        }
    }
}

- (void)createPostRequestWithParameters:(NSDictionary *)parameters
                        withRequestPath:(NSString *)requestPath
                    withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (![VPNetworkManager isNetworkAvailable]) {
        if (completionBlock) {
            completionBlock(nil,nil);
        }
        return;
    }
    
    NSLog(@"POST :%@%@, %@", self.baseURL, requestPath, parameters);
    __weak typeof(self) weakSelf = self;
    
    [self POST:requestPath parameters:parameters progress: nil
       success:^(NSURLSessionDataTask *task, id responseObject) {
           [weakSelf processNetworkResponse:responseObject task:task withCompletion:completionBlock];
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           [weakSelf processNetworkError:error task:task withCompletion:completionBlock];
       }];
}

- (void)createGetRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (![VPNetworkManager isNetworkAvailable]) {
        if (completionBlock) {
            completionBlock(nil,nil);
        }
        return;
    }
    
    NSLog(@"GET :%@%@, %@", self.baseURL, requestPath, parameters);
    __weak typeof(self) weakSelf = self;
    
    [self GET:requestPath parameters:parameters progress: nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          [weakSelf processNetworkResponse:responseObject task:task withCompletion:completionBlock];
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [weakSelf processNetworkError:error task:task withCompletion:completionBlock];
      }];
}

- (void)createPutRequestWithParameters:(NSDictionary *)parameters
                       withRequestPath:(NSString *)requestPath
                   withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (![VPNetworkManager isNetworkAvailable]) {
        if (completionBlock) {
            completionBlock(nil,nil);
        }
        return;
    }
    
    NSLog(@"PUT :%@%@, %@", self.baseURL, requestPath, parameters);
    __weak typeof(self) weakSelf = self;
    
    [self PUT:requestPath parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [weakSelf processNetworkResponse:responseObject task:task withCompletion:completionBlock];
     }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          [weakSelf processNetworkError:error task:task withCompletion:completionBlock];
      }];
}

- (void)createDeleteRequestWithParameters:(NSDictionary *)parameters
                          withRequestPath:(NSString *)requestPath
                      withCompletionBlock:(void(^)(id responseObject, NSError *error))completionBlock
{
    if (![VPNetworkManager isNetworkAvailable]) {
        if (completionBlock) {
            completionBlock(nil,nil);
        }
        return;
    }
    
    NSLog(@"DELETE : %@, %@", requestPath, parameters);
    __weak typeof(self) weakSelf = self;
    [self DELETE:requestPath parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             [weakSelf processNetworkResponse:responseObject task:task withCompletion:completionBlock];
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             [weakSelf processNetworkError:error task:task withCompletion:completionBlock];
         }];
}

- (void)cancelAllTasks
{
    for (NSURLSessionDataTask *task in self.tasks){
        [task cancel];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

+ (NSError *)generalError
{
    NSError *error;
    if ([VPNetworkManager isNetworkAvailable]) {
        error = [NSError errorWithDomain:@"VoltagePro" code:1986
                                    userInfo:@{NSLocalizedDescriptionKey : @"Something seems to have gone wrong. Please try again later."}];
    }
    else
    {
        error = [NSError errorWithDomain:@"VoltagePro" code:-1009
                                userInfo:@{NSLocalizedFailureReasonErrorKey : @"No Internet Connection",
                                           NSLocalizedDescriptionKey : @"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."}];

    }
    return error;
}

+ (BOOL)isNetworkAvailable {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return NO;
    }
    else {
        return YES;
    }
}



@end
