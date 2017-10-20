//
//  List30minViewController.h
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "VPAutoDownloadViewController.h"


@interface List30minViewController : VPAutoDownloadViewController<MBProgressHUDDelegate>{
    NSArray *nem5min;
    
    NSMutableArray *priceArray;
    NSMutableArray *demandArray;
    NSMutableArray *timeArray;
    NSMutableArray *typeArray;
    
    NSMutableArray *tableViewLabel;
    NSArray *components;
    NSString *stateURL;
    NSString *stateSelected;
    
    NSString *dbPathCache;
    NSFileManager *fileMgr;
    UILabel *dateLastUpdated;
    UILabel *settingsLabel;
    UITableView *mytableView;
    UISegmentedControl *segVal;
    
    NSMutableArray *priceArrayRaw;
    NSMutableArray *timeArrayRaw;
    NSMutableArray *demandArrayRaw;
    NSMutableArray *typeArrayRaw;
    
    NSNumber *minPrice;
    NSNumber *maxPrice;
    NSNumber *avgPrice;
    
    MBProgressHUD *HUD;
    
    
}

@property (nonatomic, strong) NSArray *nem5min;

@property (nonatomic, strong) NSArray *components;
@property (nonatomic, strong) NSMutableArray *tableViewLabel;
@property (nonatomic, strong) NSMutableArray *priceArray;
@property (nonatomic, strong) NSMutableArray *demandArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *typeArray;

@property (nonatomic, strong) NSMutableArray *priceArrayRaw;
@property (nonatomic, strong) NSMutableArray *timeArrayRaw;
@property (nonatomic, strong) NSMutableArray *demandArrayRaw;
@property (nonatomic, strong) NSMutableArray *typeArrayRaw;

@property (nonatomic, copy) NSNumber *minPrice;
@property (nonatomic, copy) NSNumber *maxPrice;
@property (nonatomic, copy) NSNumber *avgPrice;

@property (nonatomic, copy) NSString *stateURL;
@property (nonatomic, copy) NSString *stateSelected;

@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;
@property (nonatomic, strong) IBOutlet UILabel *settingsLabel;

@property (nonatomic, copy) NSString *dbPathCache;

@property (nonatomic, copy) NSFileManager *fileMgr;

@property (nonatomic,strong) IBOutlet UITableView *mytableView;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segVal;



-(IBAction)refreshData:(id)sender;

-(IBAction)segmentControlTap:(UISegmentedControl *)sender;

-(IBAction)scrollTableView:(id)sender;

- (void) updateMaxPriceDemand;

@end


