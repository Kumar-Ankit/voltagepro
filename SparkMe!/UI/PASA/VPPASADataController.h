//
//  VPPASADataController.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/10/17.
//

#import "VPAutoDownloadViewController.h"
@class PASAModel;


@interface VPPASADataController : VPAutoDownloadViewController
@property (nonatomic, strong) PASAModel *pasa;
@property (nonatomic, assign) PASAType controllerType;
@property (nonatomic, assign) NSInteger defaultStateIndex;
@end
