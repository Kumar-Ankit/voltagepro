//
//  VPDataManager.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/18/16.
//
//

#import <Foundation/Foundation.h>
#import "NotificationMTLModel.h"
#import "VPPASADataModel.h"
#import "Utility.h"

@interface VPDataManager : NSObject
+ (VPDataManager *)sharedManager;

- (void)getNotificationSettings:(NSDictionary *)parameters
                     completion:(void (^)(NotificationMTLModel *response, NSError *error))completionBlock;

- (void)setSettings:(NSDictionary *)parameters
                     completion:(void (^)(BOOL status, NSError *error))completionBlock;

- (void)fetchAEMOData:(NSDictionary *)parameters
           completion:(void (^)(NSDictionary* response, NSError *error))completionBlock;

- (void)loadDataWithContentsOfURL:(NSString *)ulrStr withSelectedIndex:(NSInteger)index completion:(void (^)(NSData* response, NSError *error, NSInteger index))completionBlock;

- (void)fetchPASADataWithStateName:(NSString *)stateName withSelectedIndex:(NSInteger)index completion:(void (^)(VPPASADataModel* response, NSError *error, NSInteger index))completionBlock;

@end
