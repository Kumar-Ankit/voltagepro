//
//  VPPASADataModel.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import "VPWebServiceResponseModel.h"
@class VPPASAItem;

@interface VPPASADataModel : VPWebServiceResponseModel
@property (nonatomic, strong) NSString *publish_date;
@property (nonatomic, strong) NSArray *pasaItems;
@end


@interface VPPASAItem : VPWebServiceResponseModel
@property (nonatomic, strong) NSNumber *mt_pasa;
@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSNumber *pasa_delta;
@end
