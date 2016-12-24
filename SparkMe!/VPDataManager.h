//
//  VPDataManager.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <Foundation/Foundation.h>

@interface VPDataManager : NSObject
+ (VPDataManager *)sharedManager;

- (void)getNotificationSettings:(NSDictionary *)parameters
                     completion:(void (^)(NSArray *response, NSError *error))completionBlock;

- (void)setSettings:(NSDictionary *)parameters
                     completion:(void (^)(BOOL status, NSError *error))completionBlock;

@end
