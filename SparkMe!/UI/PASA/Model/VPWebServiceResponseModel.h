//
//  VPWebServiceResponseModel.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/11/17.
//

#import <Foundation/Foundation.h>

@interface VPWebServiceResponseModel : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSString *)stringValue:(id)value;
- (NSNumber *)numberValue:(id)value;
@end
