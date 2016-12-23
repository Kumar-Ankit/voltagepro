//
//  SnapShotViewController.h
//  Sparky
//
//  Created by Hung on 11/08/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SnapShotViewController : UIViewController{
    
    
    UIButton *headingbut1;
    UIButton *headingbut2;
    UIButton *headingbut3;
    UILabel *dateLastUpdated;
    
    NSString *dbPathCache;
    
    NSFileManager *fileMgr;
    
    
    NSInteger nemTotalRows;
    NSMutableArray *priceArrayNSW;
    NSMutableArray *demandArrayNSW;
    NSMutableArray *timeArrayNSW;
    
    NSMutableArray *priceArrayQLD;
    NSMutableArray *demandArrayQLD;
    NSMutableArray *timeArrayQLD;
    
    NSMutableArray *priceArraySA;
    NSMutableArray *demandArraySA;
    NSMutableArray *timeArraySA;
    
    NSMutableArray *priceArrayTAS;
    NSMutableArray *demandArrayTAS;
    NSMutableArray *timeArrayTAS;
    
    NSMutableArray *priceArrayVIC;
    NSMutableArray *demandArrayVIC;
    NSMutableArray *timeArrayVIC;
    
    UILabel *curPriceLabel;
    UILabel *curDemLabel;
    
    UILabel *nswMinPrice;
    UILabel *nswMaxPrice;
    UILabel *nswAvgPrice;
    UILabel *nswVWPrice;
    UILabel *nswCurPrice;
    UILabel *nswMvtPrice;
    
    
    UILabel *qldwMinPrice;
    UILabel *qldMaxPrice;
    UILabel *qldAvgPrice;
    UILabel *qldVWPrice;
    UILabel *qldCurPrice;
    UILabel *qldMvtPrice;
    
    UILabel *saMinPrice;
    UILabel *saMaxPrice;
    UILabel *saAvgPrice;
    UILabel *saVWPrice;
    UILabel *saCurPrice;
    UILabel *saMvtPrice;
    
    UILabel *tasMinPrice;
    UILabel *tasMaxPrice;
    UILabel *tasAvgPrice;
    UILabel *tasVWPrice;
    UILabel *tasCurPrice;
    UILabel *tasMvtPrice;
    
    UILabel *vicMinPrice;
    UILabel *vicMaxPrice;
    UILabel *vicAvgPrice;
    UILabel *vicVWPrice;
    UILabel *vicCurPrice;
    UILabel *vicMvtPrice;
    
    UILabel *nswMinDemand;
    UILabel *nswMaxDemand;
    UILabel *nswAvgDemand;
    UILabel *nswCurDemand;
    
    
    UILabel *qldwMinDemand;
    UILabel *qldMaxDemand;
    UILabel *qldAvgDemand;
    UILabel *qldCurDemand;
    
    UILabel *saMinDemand;
    UILabel *saMaxDemand;
    UILabel *saAvgDemand;
    UILabel *saCurDemand;
    
    UILabel *tasMinDemand;
    UILabel *tasMaxDemand;
    UILabel *tasAvgDemand;
    UILabel *tasCurDemand;
    
    UILabel *vicMinDemand;
    UILabel *vicMaxDemand;
    UILabel *vicAvgDemand;
    UILabel *vicCurDemand;
    
    UISegmentedControl *segTime;
    
}

-(IBAction)refreshData:(id)sender;

-(IBAction)segmentControlTap:(UISegmentedControl *)sender;

@property (nonatomic,strong) IBOutlet UISegmentedControl *segTime;

@property(nonatomic,retain) IBOutlet UIButton *headingbut1;
@property(nonatomic,retain) IBOutlet UIButton *headingbut2;
@property(nonatomic,retain) IBOutlet UIButton *headingbut3;
@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;

@property (nonatomic, copy) NSString *dbPathCache;

@property (nonatomic, copy) NSFileManager *fileMgr;

@property (nonatomic, strong) NSMutableArray *priceArrayNSW;
@property (nonatomic, strong) NSMutableArray *demandArrayNSW;
@property (nonatomic, strong) NSMutableArray *timeArrayNSW;

@property (nonatomic, strong) NSMutableArray *priceArrayQLD;
@property (nonatomic, strong) NSMutableArray *demandArrayQLD;
@property (nonatomic, strong) NSMutableArray *timeArrayQLD;


@property (nonatomic, strong) NSMutableArray *priceArraySA;
@property (nonatomic, strong) NSMutableArray *demandArraySA;
@property (nonatomic, strong) NSMutableArray *timeArraySA;


@property (nonatomic, strong) NSMutableArray *priceArrayTAS;
@property (nonatomic, strong) NSMutableArray *demandArrayTAS;
@property (nonatomic, strong) NSMutableArray *timeArrayTAS;

@property (nonatomic, strong) NSMutableArray *priceArrayVIC;
@property (nonatomic, strong) NSMutableArray *demandArrayVIC;
@property (nonatomic, strong) NSMutableArray *timeArrayVIC;

//Label

@property (nonatomic, strong) IBOutlet UILabel *curPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *curDemLabel;

//Price

@property (nonatomic, strong) IBOutlet UILabel *nswMinPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswMaxPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswVWPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswCurPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswMvtPrice;

@property (nonatomic, strong) IBOutlet UILabel *qldMinPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldMaxPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldVWPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldCurPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldMvtPrice;

@property (nonatomic, strong) IBOutlet UILabel *saMinPrice;
@property (nonatomic, strong) IBOutlet UILabel *saMaxPrice;
@property (nonatomic, strong) IBOutlet UILabel *saAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *saVWPrice;
@property (nonatomic, strong) IBOutlet UILabel *saCurPrice;
@property (nonatomic, strong) IBOutlet UILabel *saMvtPrice;

@property (nonatomic, strong) IBOutlet UILabel *tasMinPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasMaxPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasVWPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasCurPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasMvtPrice;

@property (nonatomic, strong) IBOutlet UILabel *vicMinPrice;
@property (nonatomic, strong) IBOutlet UILabel *vicMaxPrice;
@property (nonatomic, strong) IBOutlet UILabel *vicAvgPrice;
@property (nonatomic, strong) IBOutlet UILabel *vicVWPrice;
@property (nonatomic, strong) IBOutlet UILabel *vicCurPrice;
@property (nonatomic, strong) IBOutlet UILabel *vicMvtPrice;

//Demand

@property (nonatomic, strong) IBOutlet UILabel *nswMinDemand;
@property (nonatomic, strong) IBOutlet UILabel *nswMaxDemand;
@property (nonatomic, strong) IBOutlet UILabel *nswAvgDemand;
@property (nonatomic, strong) IBOutlet UILabel *nswCurDemand;


@property (nonatomic, strong) IBOutlet UILabel *qldMinDemand;
@property (nonatomic, strong) IBOutlet UILabel *qldMaxDemand;
@property (nonatomic, strong) IBOutlet UILabel *qldAvgDemand;
@property (nonatomic, strong) IBOutlet UILabel *qldCurDemand;


@property (nonatomic, strong) IBOutlet UILabel *saMinDemand;
@property (nonatomic, strong) IBOutlet UILabel *saMaxDemand;
@property (nonatomic, strong) IBOutlet UILabel *saAvgDemand;
@property (nonatomic, strong) IBOutlet UILabel *saCurDemand;

@property (nonatomic, strong) IBOutlet UILabel *tasMinDemand;
@property (nonatomic, strong) IBOutlet UILabel *tasMaxDemand;
@property (nonatomic, strong) IBOutlet UILabel *tasAvgDemand;
@property (nonatomic, strong) IBOutlet UILabel *tasCurDemand;

@property (nonatomic, strong) IBOutlet UILabel *vicMinDemand;
@property (nonatomic, strong) IBOutlet UILabel *vicMaxDemand;
@property (nonatomic, strong) IBOutlet UILabel *vicAvgDemand;
@property (nonatomic, strong) IBOutlet UILabel *vicCurDemand;


@end
