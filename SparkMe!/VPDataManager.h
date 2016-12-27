//
//  VPDataManager.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <Foundation/Foundation.h>
#import "NotificationMTLModel.h"

@interface VPDataManager : NSObject
+ (VPDataManager *)sharedManager;

- (void)getNotificationSettings:(NSDictionary *)parameters
                     completion:(void (^)(NotificationMTLModel *response, NSError *error))completionBlock;

- (void)setSettings:(NSDictionary *)parameters
                     completion:(void (^)(BOOL status, NSError *error))completionBlock;

@end
