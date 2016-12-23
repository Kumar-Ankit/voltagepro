//
//  VPNetworkManager.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import "VPNetworkManager.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

#define kBaseUrl @"http://crimsonbeans.com/cbprojects/pushnotification/voltagepropushnotification.php"
#define kShowNetworkResponses 1


@implementation VPNetworkManager

+(VPNetworkManager *)sharedManger
{
    static dispatch_once_t onceToken;
    static VPNetworkManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        NSURL *url = [[NSURL alloc] initWithString:kBaseUrl];
        sharedManager = [[self alloc] initWithBaseURL:url];
    });
    return sharedManager;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        AFJSONResponseSerializer *responseSer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        responseSer.removesKeysWithNullValues = YES;
        responseSer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        self.responseSerializer = responseSer;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateHeaders
{
    NSDictionary *dict = @{};
    for (NSString *key in [dict allKeys]) {
        NSString *value = dict[key];
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
