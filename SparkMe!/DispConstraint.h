//
//  DispConstraint.h
//  Sparky
//
//  Created by Hung on 1/12/12.
//
//

#import <Foundation/Foundation.h>

@interface DispConstraint : NSObject

@property (nonatomic, strong) NSMutableArray *consId;
@property (nonatomic, strong) NSMutableArray *rhs;
@property (nonatomic, strong) NSMutableArray *marginalValue;
@property (nonatomic, strong) NSMutableArray *violDegree;
@property (nonatomic, strong) NSMutableArray *genconidEffDate;
@property (nonatomic, strong) NSMutableArray *lhs;

@end
