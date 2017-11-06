//
//  PASAModel.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/30/17.
//

#import "VPWebServiceResponseModel.h"
@class STPASAParameterModel;


@interface PASAModel: NSObject
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) STPASAParameterModel *activeSTParameter;
@property (nonatomic, strong, readonly) NSArray <STPASAParameterModel *> *stAllParams;
- (NSURL *)MTPASAWebViewURL;
- (NSURL *)STPASAWebViewURL;

@end

@interface STPASAParameterModel : VPWebServiceResponseModel
@property (nonatomic, strong) NSString *actualText;
@property (nonatomic, strong) NSString *shortText;
@property (nonatomic, strong) NSString *serverText;
+ (NSArray *)rawData;
@end
