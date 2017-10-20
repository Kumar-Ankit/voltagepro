//
//  ICViewController.h
//  Sparky
//
//  Created by Hung on 12/08/12.
//
//

#import "VPAutoDownloadViewController.h"
#import "DispPrice.h"
#import "DispRegionSum.h"
#import "IcFlows.h"
#import <QuartzCore/QuartzCore.h>

@interface ICViewController : VPAutoDownloadViewController{
    UILabel *dateLastUpdated;
    
    UILabel *saDemand;
    UILabel *saGen;
    UILabel *saNetIC;
    
    UILabel *qldDemand;
    UILabel *qldGen;
    UILabel *qldNetIC;
    
    UILabel *nswDemand;
    UILabel *nswGen;
    UILabel *nswNetIC;
    
    UILabel *vicDemand;
    UILabel *vicGen;
    UILabel *vicNetIC;
    
    UILabel *tasDemand;
    UILabel *tasGen;
    UILabel *tasNetIC;
    
    UILabel *vicPrice;
    UILabel *saPrice;
    UILabel *tasPrice;
    UILabel *qldPrice;
    UILabel *nswPrice;
    UILabel *priceLabel;
    
    UIView *terranoraICLine;
    UIView *qniICLine;
    UIView *basslinkICLine;
    UIView *murraylinkICLine;
    UIView *heywoodICLine;
    UIView *vicnswICLine;
    
    
    DispPrice *dispPrice;
    DispRegionSum *dispRegion;
    IcFlows *icFlows;
    
    UIButton *headingbut1;
    
    NSString *flowDir;
    
    NSString *msgText;
    
    NSInteger gradIndex;
    
    NSInteger priceIndex;
    
    UISegmentedControl *segTime;
    
    UIButton *nswQldQNI;
    UIButton *nswQldTer;
    UIButton *vicTasBass;
    
    UIButton *saVicMur;
    UIButton *saVicHey;
    UIButton *vicNsw;
    
    UIButton *constraintsBut;
    UIButton *historyBut;
    UILabel *constraintLabel;
    UILabel *historyLabel;
    
}

@property(nonatomic,retain) IBOutlet UIButton *constraintsBut;
@property(nonatomic,retain) IBOutlet UIButton *historyBut;
@property (nonatomic, strong) IBOutlet UILabel *constraintLabel;
@property (nonatomic, strong) IBOutlet UILabel *historyLabel;

@property(nonatomic,retain) IBOutlet UIView *terranoraICLine;
@property(nonatomic,retain) IBOutlet UIView *qniICLine;
@property(nonatomic,retain) IBOutlet UIView *basslinkICLine;
@property(nonatomic,retain) IBOutlet UIView *murraylinkICLine;
@property(nonatomic,retain) IBOutlet UIView *heywoodICLine;
@property(nonatomic,retain) IBOutlet UIView *vicnswICLine;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segTime;


@property(nonatomic,retain) IBOutlet UIButton *headingbut1;

@property(nonatomic,retain) IBOutlet UIButton *nswQldQNI;

@property(nonatomic,retain) IBOutlet UIButton *nswQldTer;

@property(nonatomic,retain) IBOutlet UIButton *vicTasBass;

@property(nonatomic,retain) IBOutlet UIButton *saVicMur;
@property(nonatomic,retain) IBOutlet UIButton *saVicHey;
@property(nonatomic,retain) IBOutlet UIButton *vicNsw;

@property (nonatomic, strong) DispPrice *dispPrice;
@property (nonatomic, strong) DispRegionSum *dispRegion;
@property (nonatomic, strong) IcFlows *icFlows;



@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;

@property (nonatomic, strong) IBOutlet UILabel *vicPrice;
@property (nonatomic, strong) IBOutlet UILabel *saPrice;
@property (nonatomic, strong) IBOutlet UILabel *tasPrice;
@property (nonatomic, strong) IBOutlet UILabel *qldPrice;
@property (nonatomic, strong) IBOutlet UILabel *nswPrice;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) IBOutlet UILabel *saDemand;
@property (nonatomic, strong) IBOutlet UILabel *saGen;
@property (nonatomic, strong) IBOutlet UILabel *saNetIC;

@property (nonatomic, strong) IBOutlet UILabel *qldDemand;
@property (nonatomic, strong) IBOutlet UILabel *qldGen;
@property (nonatomic, strong) IBOutlet UILabel *qldNetIC;

@property (nonatomic, strong) IBOutlet UILabel *nswDemand;
@property (nonatomic, strong) IBOutlet UILabel *nswGen;
@property (nonatomic, strong) IBOutlet UILabel *nswNetIC;

@property (nonatomic, strong) IBOutlet UILabel *vicDemand;
@property (nonatomic, strong) IBOutlet UILabel *vicGen;
@property (nonatomic, strong) IBOutlet UILabel *vicNetIC;

@property (nonatomic, strong) IBOutlet UILabel *tasDemand;
@property (nonatomic, strong) IBOutlet UILabel *tasGen;
@property (nonatomic, strong) IBOutlet UILabel *tasNetIC;


-(IBAction)N_Q_MNSP1_tapped:(id)sender;

-(IBAction)NSW_QLD_tapped:(id)sender;

-(IBAction)T_V_MNSP1_tapped:(id)sender;

-(IBAction)V_S_MNSP1_tapped:(id)sender;

-(IBAction)V_SA_tapped:(id)sender;

-(IBAction)VIC1_NSW1_tapped:(id)sender;

-(IBAction)refreshData:(id)sender;

- (IBAction)segmentControlTap:(UISegmentedControl *)sender;

@end
