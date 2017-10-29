//
//  PASAModel.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/30/17.
//

#import <Foundation/Foundation.h>

@interface PASAModel: NSObject
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *paramId;
@property (nonatomic, strong, readonly) NSArray *stAllParams;
- (NSURL *)MTPASAWebViewURL;
- (NSURL *)STPASAWebViewURL;
+ (NSString *)shortNameForParamId:(NSString *)parmaId;

@end
