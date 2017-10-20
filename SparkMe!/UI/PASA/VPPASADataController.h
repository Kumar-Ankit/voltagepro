//
//  VPPASADataController.h
//  Sparky
//
//  Created by Shivam Jaiswal on 10/10/17.
//

#import "VPAutoDownloadViewController.h"
@class VPPASATimeCompareModel;


@interface VPPASADataController : VPAutoDownloadViewController
@property (nonatomic, strong) VPPASATimeCompareModel *timeModel;
@property (nonatomic, assign) PASAType controllerType;
@end
