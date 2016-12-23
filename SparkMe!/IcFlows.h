//
//  IcFlows.h
//  Sparky
//
//  Created by Hung on 14/08/12.
//
//

#import <Foundation/Foundation.h>

@interface IcFlows : NSObject

@property (nonatomic, strong) NSMutableArray *icID;
@property (nonatomic, strong) NSMutableArray *meterFlow;
@property (nonatomic, strong) NSMutableArray *mwFlow;
@property (nonatomic, strong) NSMutableArray *mwLosses;
@property (nonatomic, strong) NSMutableArray *exportLimit;
@property (nonatomic, strong) NSMutableArray *importLimit;

@property (nonatomic, strong) NSMutableArray *exportConId;
@property (nonatomic, strong) NSMutableArray *importConId;

@end
