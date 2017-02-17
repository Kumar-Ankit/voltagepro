//
//  SnapShotViewController.m
//  Sparky
//
//  Created by Hung on 11/08/12.
//
//

#import "SnapShotViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "BlinkingColors.h"
#import "BlinkingLabelOperation.h"
#import "VPDataManager.h"
#import "Utility.h"
@interface SnapShotViewController ()

@end

@implementation SnapShotViewController

@synthesize headingbut1, headingbut2, headingbut3, dateLastUpdated, dbPathCache, fileMgr, demandArrayNSW,demandArrayQLD,demandArraySA,demandArrayTAS,demandArrayVIC,priceArrayNSW,priceArrayQLD,priceArraySA,priceArrayTAS,priceArrayVIC,nswMinPrice,nswMaxPrice,nswAvgPrice, qldMinPrice, qldMaxPrice, qldAvgPrice, saMinPrice, saMaxPrice, saAvgPrice, tasMinPrice, tasMaxPrice, tasAvgPrice, vicMinPrice, vicMaxPrice, vicAvgPrice,
nswVWPrice, qldVWPrice, saVWPrice, tasVWPrice, vicVWPrice, nswCurPrice, qldCurPrice, saCurPrice, tasCurPrice,vicCurPrice,


nswAvgDemand,nswCurDemand, nswMaxDemand, nswMinDemand, qldAvgDemand, qldCurDemand, qldMaxDemand, qldMinDemand, saAvgDemand, saCurDemand, saMaxDemand, saMinDemand, tasAvgDemand, tasCurDemand, tasMaxDemand, tasMinDemand, vicAvgDemand, vicCurDemand, vicMaxDemand, vicMinDemand, segTime,

nswMvtPrice,qldMvtPrice,saMvtPrice,tasMvtPrice, vicMvtPrice, curDemLabel, curPriceLabel,

timeArrayNSW, timeArrayQLD, timeArraySA, timeArrayTAS, timeArrayVIC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    headingbut1=nil;
    headingbut2=nil;
    headingbut3=nil;
    dateLastUpdated=nil;
    dbPathCache=nil;
    fileMgr=nil;
    demandArrayNSW=nil;
    demandArrayQLD=nil;
    demandArraySA=nil;
    demandArrayTAS=nil;
    demandArrayVIC=nil;
    priceArrayNSW=nil;
    priceArrayQLD=nil;
    priceArraySA=nil;
    priceArrayTAS=nil;
    priceArrayVIC=nil;
    nswMinPrice=nil;
    nswMaxPrice=nil;
    nswAvgPrice=nil;
    qldMinPrice=nil;
    qldMaxPrice=nil;
    qldAvgPrice=nil;
    saMinPrice=nil;
    saMaxPrice=nil;
    saAvgPrice=nil;
    tasMinPrice=nil;
    tasMaxPrice=nil;
    tasAvgPrice=nil;
    vicMinPrice=nil;
    vicMaxPrice=nil;
    vicAvgPrice=nil;
    nswVWPrice=nil;
    qldVWPrice=nil;
    saVWPrice=nil;
    tasVWPrice=nil;
    vicVWPrice=nil;
    nswCurPrice=nil;
    qldCurPrice=nil;
    saCurPrice=nil;
    tasCurPrice=nil;
    vicCurPrice=nil;
    nswAvgDemand=nil;
    nswCurDemand=nil;
    nswMaxDemand=nil;
    nswMinDemand=nil;
    qldAvgDemand=nil;
    qldCurDemand=nil;
    qldMaxDemand=nil;
    qldMinDemand=nil;
    saAvgDemand=nil;
    saCurDemand=nil;
    saMaxDemand=nil;
    saMinDemand=nil;
    tasAvgDemand=nil;
    tasCurDemand=nil;
    tasMaxDemand=nil;
    tasMinDemand=nil;
    vicAvgDemand=nil;
    vicCurDemand=nil;
    vicMaxDemand=nil;
    vicMinDemand=nil;
}

- (void)setup
{
    //reset all cur min max price label fonts back to white
    nswMinPrice.backgroundColor = [UIColor clearColor];
    nswMaxPrice.backgroundColor = [UIColor clearColor];
    nswCurPrice.backgroundColor = [UIColor clearColor];
    
    qldMinPrice.backgroundColor = [UIColor clearColor];
    qldMaxPrice.backgroundColor = [UIColor clearColor];
    qldCurPrice.backgroundColor = [UIColor clearColor];
    
    saMinPrice.backgroundColor = [UIColor clearColor];
    saMaxPrice.backgroundColor = [UIColor clearColor];
    saCurPrice.backgroundColor = [UIColor clearColor];
    
    tasMinPrice.backgroundColor = [UIColor clearColor];
    tasMaxPrice.backgroundColor = [UIColor clearColor];
    tasCurPrice.backgroundColor = [UIColor clearColor];
    
    vicMinPrice.backgroundColor = [UIColor clearColor];
    vicMaxPrice.backgroundColor = [UIColor clearColor];
    vicCurPrice.backgroundColor = [UIColor clearColor];
    
    //Resetting text color
    nswMinPrice.textColor = [UIColor blackColor];
    nswMaxPrice.textColor = [UIColor blackColor];
    nswCurPrice.textColor = [UIColor blackColor];
    
    qldMinPrice.textColor = [UIColor blackColor];
    qldMaxPrice.textColor = [UIColor blackColor];
    qldCurPrice.textColor = [UIColor blackColor];
    
    saMinPrice.textColor = [UIColor blackColor];
    saMaxPrice.textColor = [UIColor blackColor];
    saCurPrice.textColor = [UIColor blackColor];
    
    tasMinPrice.textColor = [UIColor blackColor];
    tasMaxPrice.textColor = [UIColor blackColor];
    tasCurPrice.textColor = [UIColor blackColor];
    
    vicMinPrice.textColor = [UIColor blackColor];
    vicMaxPrice.textColor = [UIColor blackColor];
    vicCurPrice.textColor = [UIColor blackColor];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                  message:@"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [alertNoInternet show];
    }
    else
    {
        if(segTime.selectedSegmentIndex==0)
        {
            curPriceLabel.text=@"Current";
            curDemLabel.text=@"Current";
            headingbut3.titleLabel.text=@"min, max, avg stats relate to last 24hrs data";
            headingbut3.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self loadPart1_5];
        }
        else if(segTime.selectedSegmentIndex==1)
        {
            curPriceLabel.text=@"Current";
            curDemLabel.text=@"Current";
            headingbut3.titleLabel.text=@"min, max, avg stats relate to last 24hrs data";
            headingbut3.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self loadPart1_30];
        }
        else if(segTime.selectedSegmentIndex==2)
        {
            curPriceLabel.text=@"PreDispatch";
            curDemLabel.text=@"PreDispatch";
            headingbut3.titleLabel.text=@"";
            headingbut3.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self loadPart1_30PD];
        }
    }
}

-(IBAction)refreshData:(id)sender{
    NSLog(@"Data refresh tapped");
    [self setup];
}

-(IBAction)segmentControlTap:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            //            5min tapped
            NSLog(@"5min button tapped");
            [self setup];
            break;

        case 1:
            //            30min tapped
            NSLog(@"30min button tapped");
            [self setup];
            break;
            
            
        case 2:
            //            30min predispatch tapped
            NSLog(@"30min PD button tapped");
            [self setup];
            break;
            
        default:
            break;
    }
}

- (void)loadPart1_5
{
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    hudUpdateUIView.yOffset = -70.f;
    [self performSelector:@selector(loadPart2_5) withObject:nil afterDelay:0];
}

- (void)loadPart2_5{

    NSDictionary *parameters = @{ @"timeScale": @[ @"5MIN" ] };
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] fetchAEMOData:parameters completion:^(NSDictionary *response, NSError *error) {
        [weakSelf process5minData:response withError:error];
    }];
}

- (void)process5minData:(NSDictionary *)response withError:(NSError *)error
{
    [Utility hideHUDForView:self.view];

    if (!response || error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    NSArray *jsonArray = [response objectForKey:@"5MIN"];
    
    //subset the jsonArray be desired region
    timeArrayNSW = [[NSMutableArray alloc] init];
    priceArrayNSW = [[NSMutableArray alloc] init];
    demandArrayNSW = [[NSMutableArray alloc] init];
    
    timeArrayQLD = [[NSMutableArray alloc] init];
    priceArrayQLD = [[NSMutableArray alloc] init];
    demandArrayQLD = [[NSMutableArray alloc] init];
    
    timeArrayVIC = [[NSMutableArray alloc] init];
    priceArrayVIC = [[NSMutableArray alloc] init];
    demandArrayVIC = [[NSMutableArray alloc] init];
    
    timeArraySA = [[NSMutableArray alloc] init];
    priceArraySA = [[NSMutableArray alloc] init];
    demandArraySA = [[NSMutableArray alloc] init];
    
    timeArrayTAS = [[NSMutableArray alloc] init];
    priceArrayTAS = [[NSMutableArray alloc] init];
    demandArrayTAS = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    for (NSInteger i = 0; i < jsonArray.count; i++)
    {
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"NSW1"])
        {
            // convert crappy dates to normal dates
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayNSW addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayNSW addObject:rrpNum];
            [demandArrayNSW addObject:demandNum];
        }
       
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"QLD1"])
        {
            
            // convert crappy dates to normal dates
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayQLD addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayQLD addObject:rrpNum];
            [demandArrayQLD addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"VIC1"])
        {
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayVIC addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayVIC addObject:rrpNum];
            [demandArrayVIC addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"SA1"])
        {
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArraySA addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArraySA addObject:rrpNum];
            [demandArraySA addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"TAS1"])
        {
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayTAS addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayTAS addObject:rrpNum];
            [demandArrayTAS addObject:demandNum];
        }
    }
    
    //===========  NSW
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    NSNumberFormatter *numberFormatterPrice = [[NSNumberFormatter alloc] init];
    [numberFormatterPrice setPositiveFormat:@"#,##0.0"];
    
    NSArray *subPriceArrayNSW = [priceArrayNSW subarrayWithRange:NSMakeRange(287, 288)];
    NSArray *subDemandArrayNSW = [demandArrayNSW subarrayWithRange:NSMakeRange(287, 288)];
    
    NSNumber *minPriceValueNSW = [subPriceArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueNSW = [subPriceArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueNSW = [subPriceArrayNSW valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueNSW = [subDemandArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueNSW = [subDemandArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueNSW = [subDemandArrayNSW valueForKeyPath:@"@avg.self"];
    
    nswMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueNSW];
    nswMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueNSW];
    nswAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueNSW];

    nswCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue]];
    nswMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] - [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-2] floatValue]];

    nswMinDemand.text = [numberFormatter stringFromNumber:minDemandValueNSW];
    nswMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueNSW];
    nswAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueNSW];
    nswCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayNSW objectAtIndex:[demandArrayNSW count]-1] floatValue]]];
    
    if([minPriceValueNSW compare:[NSNumber numberWithInt:0]] == -1)
    {
        nswMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueNSW compare:[NSNumber numberWithInt:100]] == 1)
    {
        nswMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    if([[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] < 0 || [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] >= 100){
        nswCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  QLD
    
    NSArray *subPriceArrayQLD = [priceArrayQLD subarrayWithRange:NSMakeRange(287, 288)];
    NSArray *subDemandArrayQLD = [demandArrayQLD subarrayWithRange:NSMakeRange(287, 288)];
    
    NSNumber *minPriceValueQLD = [subPriceArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueQLD = [subPriceArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueQLD = [subPriceArrayQLD valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueQLD = [subDemandArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueQLD = [subDemandArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueQLD = [subDemandArrayQLD valueForKeyPath:@"@avg.self"];
    
    qldMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueQLD];
    qldMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueQLD];
    qldAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueQLD];

    qldCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue]];
    qldMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] - [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-2] floatValue]];
    
    qldMinDemand.text = [numberFormatter stringFromNumber:minDemandValueQLD];
    qldMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueQLD];
    qldAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueQLD];
    qldCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayQLD objectAtIndex:[demandArrayQLD count]-1] floatValue]]];
    
    if([minPriceValueQLD compare:[NSNumber numberWithInt:0]] == -1){
        qldMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueQLD compare:[NSNumber numberWithInt:100]] == 1){
        qldMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] < 0 || [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] >= 100){
        qldCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    
    //===========  VIC
    
    NSArray *subPriceArrayVIC = [priceArrayVIC subarrayWithRange:NSMakeRange(287, 288)];
    NSArray *subDemandArrayVIC = [demandArrayVIC subarrayWithRange:NSMakeRange(287, 288)];
    
    
    NSNumber *minPriceValueVIC = [subPriceArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueVIC = [subPriceArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueVIC = [subPriceArrayVIC valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueVIC = [subDemandArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueVIC = [subDemandArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueVIC = [subDemandArrayVIC valueForKeyPath:@"@avg.self"];
    
    vicMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueVIC];
    vicMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueVIC];
    vicAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueVIC];
    
    vicCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue]];
    vicMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] - [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-2] floatValue]];
    
    vicMinDemand.text = [numberFormatter stringFromNumber:minDemandValueVIC];
    vicMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueVIC];
    vicAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueVIC];
    vicCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayVIC objectAtIndex:[demandArrayVIC count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    if([minPriceValueVIC compare:[NSNumber numberWithInt:0]] == -1){
        vicMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueVIC compare:[NSNumber numberWithInt:100]] == 1){
        vicMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] < 0 || [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] >= 100){
        vicCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  SA
    
    NSArray *subPriceArraySA = [priceArraySA subarrayWithRange:NSMakeRange(287, 288)];
    NSArray *subDemandArraySA = [demandArraySA subarrayWithRange:NSMakeRange(287, 288)];
    
    
    NSNumber *minPriceValueSA = [subPriceArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueSA = [subPriceArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueSA = [subPriceArraySA valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueSA = [subDemandArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueSA = [subDemandArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueSA = [subDemandArraySA valueForKeyPath:@"@avg.self"];
    
    saMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueSA];
    saMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueSA];
    saAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueSA];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    saCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue]];
    saMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] - [[priceArraySA objectAtIndex:[priceArraySA count]-2] floatValue]];
    
    
    
    saMinDemand.text = [numberFormatter stringFromNumber:minDemandValueSA];
    saMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueSA];
    saAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueSA];
    saCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArraySA objectAtIndex:[demandArraySA count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    if([minPriceValueSA compare:[NSNumber numberWithInt:0]] == -1){
        saMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueSA compare:[NSNumber numberWithInt:100]] == 1){
        saMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] < 0 || [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] >= 100){
        saCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    
    //===========  TAS
    
    NSArray *subPriceArrayTAS = [priceArrayTAS subarrayWithRange:NSMakeRange(287, 288)];
    NSArray *subDemandArrayTAS = [demandArrayTAS subarrayWithRange:NSMakeRange(287, 288)];
    
    
    NSNumber *minPriceValueTAS = [subPriceArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueTAS = [subPriceArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueTAS = [subPriceArrayTAS valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueTAS = [subDemandArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueTAS = [subDemandArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueTAS = [subDemandArrayTAS valueForKeyPath:@"@avg.self"];
    
    tasMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueTAS];
    tasMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueTAS];
    tasAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueTAS];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    tasCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue]];
    tasMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] - [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-2] floatValue]];
    
    
    
    tasMinDemand.text = [numberFormatter stringFromNumber:minDemandValueTAS];
    tasMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueTAS];
    tasAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueTAS];
    tasCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayTAS objectAtIndex:[demandArrayTAS count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    if([minPriceValueTAS compare:[NSNumber numberWithInt:0]] == -1){
        tasMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueTAS compare:[NSNumber numberWithInt:100]] == 1){
        tasMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] < 0 || [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] >= 100){
        tasCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    NSLog(@"When is this run???");
    
    dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]]]];
    
    [self.view setNeedsDisplay];
    
    demandArrayNSW=nil;
    demandArrayQLD=nil;
    demandArraySA=nil;
    demandArrayTAS=nil;
    demandArrayVIC=nil;
    priceArrayNSW=nil;
    priceArrayQLD=nil;
    priceArraySA=nil;
    priceArrayTAS=nil;
    priceArrayVIC=nil;
    timeArrayNSW=nil;
    timeArrayTAS=nil;
    timeArraySA=nil;
    timeArrayVIC=nil;
    timeArrayQLD=nil;
}


- (void)loadPart1_30 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    hudUpdateUIView.yOffset = -70.f;
    
    [self performSelector:@selector(loadPart2_30) withObject:nil afterDelay:0];
}

- (void)loadPart2_30 {
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date30minLastUpdateSnapShot"];
    
    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    NSLog(@"Lastest file has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFile]);
    
    //    Display current date time
    NSDate *dateNow = [NSDate date];
    NSLog(@"Current time stamp is %@",[dateFormatCur stringFromDate:dateNow]);
    
    //    FOR 30 MIN VIEW, NEM TIME IS LAGGING BY CURRENT TIME, IE. NEM PERIOD IS BEHIND...
    
    //    Perform logic check here to compare date of latestest stored file vs. current date
    //    if current date time is < NEM time stamp + 28mins then don't do web call use last stored file
    
    //    if dateLastFile does not exist that means there is no historical stored data file, then force the webcall
    //    also force the web call if DateLastFile is greater than NEM time mins let say 28mins
    
    NSDate *DateLastFileAdj = [DateLastFile dateByAddingTimeInterval:60*28];
    
    NSLog(@"Lastest file ADJ has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFileAdj]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30ACT.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    DateLastFile=nil;
    
    if (DateLastFile == NULL ||
       ([DateLastFileAdj compare:dateNow] == NSOrderedAscending) ||
       jsonArray == nil ||
       [jsonArray count] == 0)
    {
        NSLog(@"Current time is greater than ADJ time - PERFORM WEB QUERY");
        //        do web call
        [self loadPart3_30_www];
    }
    else{
        NSLog(@"Current time is less than ADJ time - USE LOCAL FILE");
        [self loadPart3_30_local];
    }
}

-(void) loadPart3_30_www
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{ @"timeScale": @[ @"30MIN" ] };
    [[VPDataManager sharedManager] fetchAEMOData:parameters completion:^(NSDictionary *response, NSError *error) {
        [weakSelf process30minData:response withError:error];
    }];
}

- (void)process30minData:(NSDictionary *)response withError:(NSError *)error{
    [Utility hideHUDForView:self.view];
    if (!response || error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    {
        
        NSArray *jsonArray = [response objectForKey:@"5MIN"];
        
        
        // save the array to file
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30ACT.CSV"];
        
        [jsonArray writeToFile:dbPathCache atomically:YES];
        
        //                                                        subset the jsonArray be desired region
        
        
        timeArrayNSW = [[NSMutableArray alloc] init];
        priceArrayNSW = [[NSMutableArray alloc] init];
        demandArrayNSW = [[NSMutableArray alloc] init];
        
        timeArrayQLD = [[NSMutableArray alloc] init];
        priceArrayQLD = [[NSMutableArray alloc] init];
        demandArrayQLD = [[NSMutableArray alloc] init];
        
        timeArrayVIC = [[NSMutableArray alloc] init];
        priceArrayVIC = [[NSMutableArray alloc] init];
        demandArrayVIC = [[NSMutableArray alloc] init];
        
        timeArraySA = [[NSMutableArray alloc] init];
        priceArraySA = [[NSMutableArray alloc] init];
        demandArraySA = [[NSMutableArray alloc] init];
        
        timeArrayTAS = [[NSMutableArray alloc] init];
        priceArrayTAS = [[NSMutableArray alloc] init];
        demandArrayTAS = [[NSMutableArray alloc] init];
        //NSLog(@"This is the data!!! %@", jsonResult);
        
        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
        
        
        //                                                        NSLog(@"date value is %@", jsonArray);
        
        
        
        for(int i=0; i<[jsonArray count]; i++){
            
            
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"NSW1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ) {
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayNSW addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayNSW addObject:rrpNum];
                [demandArrayNSW addObject:demandNum];
                
                
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"QLD1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayQLD addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayQLD addObject:rrpNum];
                [demandArrayQLD addObject:demandNum];
                
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"VIC1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayVIC addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayVIC addObject:rrpNum];
                [demandArrayVIC addObject:demandNum];
                
                
            }
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"SA1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArraySA addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArraySA addObject:rrpNum];
                [demandArraySA addObject:demandNum];
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"TAS1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayTAS addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayTAS addObject:rrpNum];
                [demandArrayTAS addObject:demandNum];
                
                
            }
            
        }
        
        //                                                        NSLog(@"This is price!!! %@, %@, %@", timeArrayRaw, priceArrayRaw, demandArrayRaw);
        
    }
    
    
    
    
    
    
    
    //===========  NSW
    
    //NSLog(@"price array value is %@", priceArrayNSW);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    NSNumberFormatter *numberFormatterPrice = [[NSNumberFormatter alloc] init];
    [numberFormatterPrice setPositiveFormat:@"#,##0.0"];
    
    
    NSNumber *minPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@avg.self"];
    
    nswMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueNSW];
    nswMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueNSW];
    nswAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueNSW];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    nswCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue]];
    nswMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] - [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-2] floatValue]];
    
    
    
    nswMinDemand.text = [numberFormatter stringFromNumber:minDemandValueNSW];
    nswMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueNSW];
    nswAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueNSW];
    nswCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayNSW objectAtIndex:[demandArrayNSW count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueNSW compare:[NSNumber numberWithInt:0]] == -1){
        nswMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueNSW compare:[NSNumber numberWithInt:100]] == 1){
        nswMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] < 0 || [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] >= 100){
        nswCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        
    }
    
    
    //===========  QLD
    
    
    
    NSNumber *minPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@avg.self"];
    
    qldMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueQLD];
    qldMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueQLD];
    qldAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueQLD];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    qldCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue]];
    qldMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] - [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-2] floatValue]];
    
    
    
    qldMinDemand.text = [numberFormatter stringFromNumber:minDemandValueQLD];
    qldMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueQLD];
    qldAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueQLD];
    qldCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayQLD objectAtIndex:[demandArrayQLD count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueQLD compare:[NSNumber numberWithInt:0]] == -1){
        qldMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueQLD compare:[NSNumber numberWithInt:100]] == 1){
        qldMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] < 0 || [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] >= 100){
        qldCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    
    //===========  VIC
    
    
    NSNumber *minPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@avg.self"];
    
    vicMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueVIC];
    vicMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueVIC];
    vicAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueVIC];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    vicCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue]];
    vicMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] - [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-2] floatValue]];
    
    
    
    vicMinDemand.text = [numberFormatter stringFromNumber:minDemandValueVIC];
    vicMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueVIC];
    vicAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueVIC];
    vicCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayVIC objectAtIndex:[demandArrayVIC count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueVIC compare:[NSNumber numberWithInt:0]] == -1){
        vicMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueVIC compare:[NSNumber numberWithInt:100]] == 1){
        vicMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] < 0 || [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] >= 100){
        vicCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  SA
    
    
    NSNumber *minPriceValueSA = [priceArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueSA = [priceArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueSA = [priceArraySA valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueSA = [demandArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueSA = [demandArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueSA = [demandArraySA valueForKeyPath:@"@avg.self"];
    
    saMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueSA];
    saMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueSA];
    saAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueSA];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    saCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue]];
    saMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] - [[priceArraySA objectAtIndex:[priceArraySA count]-2] floatValue]];
    
    
    
    saMinDemand.text = [numberFormatter stringFromNumber:minDemandValueSA];
    saMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueSA];
    saAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueSA];
    saCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArraySA objectAtIndex:[demandArraySA count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueSA compare:[NSNumber numberWithInt:0]] == -1){
        saMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueSA compare:[NSNumber numberWithInt:100]] == 1){
        saMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] < 0 || [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] >= 100){
        saCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    
    //===========  TAS
    
    
    NSNumber *minPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@avg.self"];
    
    tasMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueTAS];
    tasMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueTAS];
    tasAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueTAS];
    
    
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    tasCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue]];
    tasMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] - [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-2] floatValue]];
    
    
    
    tasMinDemand.text = [numberFormatter stringFromNumber:minDemandValueTAS];
    tasMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueTAS];
    tasAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueTAS];
    tasCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayTAS objectAtIndex:[demandArrayTAS count]-1] floatValue]]];
    
    //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
    //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
    //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
    
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueTAS compare:[NSNumber numberWithInt:0]] == -1){
        tasMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueTAS compare:[NSNumber numberWithInt:100]] == 1){
        tasMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] < 0 || [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] >= 100){
        tasCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    NSLog(@"When is this run???");
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]]]];
    
    //    now save date stamp latest NEM period
    
    [[NSUserDefaults standardUserDefaults] setObject:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]] forKey:@"date30minLastUpdateSnapShot"];
    
    [self.view setNeedsDisplay];
    
    demandArrayNSW=nil;
    demandArrayQLD=nil;
    demandArraySA=nil;
    demandArrayTAS=nil;
    demandArrayVIC=nil;
    priceArrayNSW=nil;
    priceArrayQLD=nil;
    priceArraySA=nil;
    priceArrayTAS=nil;
    priceArrayVIC=nil;
    timeArrayNSW=nil;
    timeArrayTAS=nil;
    timeArraySA=nil;
    timeArrayVIC=nil;
    timeArrayQLD=nil;
    
    [Utility hideHUDForView:self.view];
    


}

-(void) loadPart3_30_local
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30ACT.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    timeArrayNSW = [[NSMutableArray alloc] init];
    priceArrayNSW = [[NSMutableArray alloc] init];
    demandArrayNSW = [[NSMutableArray alloc] init];
    
    timeArrayQLD = [[NSMutableArray alloc] init];
    priceArrayQLD = [[NSMutableArray alloc] init];
    demandArrayQLD = [[NSMutableArray alloc] init];
    
    timeArrayVIC = [[NSMutableArray alloc] init];
    priceArrayVIC = [[NSMutableArray alloc] init];
    demandArrayVIC = [[NSMutableArray alloc] init];
    
    timeArraySA = [[NSMutableArray alloc] init];
    priceArraySA = [[NSMutableArray alloc] init];
    demandArraySA = [[NSMutableArray alloc] init];
    
    timeArrayTAS = [[NSMutableArray alloc] init];
    priceArrayTAS = [[NSMutableArray alloc] init];
    demandArrayTAS = [[NSMutableArray alloc] init];
    //NSLog(@"This is the data!!! %@", jsonResult);
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    for(int i=0; i<[jsonArray count]; i++)
    {
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"NSW1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ) {
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayNSW addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayNSW addObject:rrpNum];
            [demandArrayNSW addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"QLD1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayQLD addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayQLD addObject:rrpNum];
            [demandArrayQLD addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"VIC1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayVIC addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayVIC addObject:rrpNum];
            [demandArrayVIC addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"SA1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArraySA addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArraySA addObject:rrpNum];
            [demandArraySA addObject:demandNum];
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"TAS1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayTAS addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayTAS addObject:rrpNum];
            [demandArrayTAS addObject:demandNum];
        }
    }
    
    //===========  NSW
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    NSNumberFormatter *numberFormatterPrice = [[NSNumberFormatter alloc] init];
    [numberFormatterPrice setPositiveFormat:@"#,##0.0"];
    
    NSNumber *minPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@avg.self"];
    
    nswMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueNSW];
    nswMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueNSW];
    nswAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueNSW];
    
    nswCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue]];
    nswMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] - [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-2] floatValue]];
    
    nswMinDemand.text = [numberFormatter stringFromNumber:minDemandValueNSW];
    nswMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueNSW];
    nswAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueNSW];
    nswCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayNSW objectAtIndex:[demandArrayNSW count]-1] floatValue]]];
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueNSW compare:[NSNumber numberWithInt:0]] == -1){
        nswMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueNSW compare:[NSNumber numberWithInt:100]] == 1){
        nswMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] < 0 || [[priceArrayNSW objectAtIndex:[priceArrayNSW count]-1] floatValue] >= 100){
        nswCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    
    //===========  QLD
    
    NSNumber *minPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@avg.self"];
    
    qldMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueQLD];
    qldMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueQLD];
    qldAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueQLD];

    qldCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue]];
    qldMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] - [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-2] floatValue]];
    
    qldMinDemand.text = [numberFormatter stringFromNumber:minDemandValueQLD];
    qldMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueQLD];
    qldAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueQLD];
    qldCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayQLD objectAtIndex:[demandArrayQLD count]-1] floatValue]]];

    NSLog(@"NSW array allocated");
    
    if([minPriceValueQLD compare:[NSNumber numberWithInt:0]] == -1){
        qldMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueQLD compare:[NSNumber numberWithInt:100]] == 1){
        qldMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] < 0 || [[priceArrayQLD objectAtIndex:[priceArrayQLD count]-1] floatValue] >= 100){
        qldCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  VIC
    NSNumber *minPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@avg.self"];
    
    vicMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueVIC];
    vicMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueVIC];
    vicAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueVIC];

    vicCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue]];
    vicMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] - [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-2] floatValue]];
    
    vicMinDemand.text = [numberFormatter stringFromNumber:minDemandValueVIC];
    vicMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueVIC];
    vicAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueVIC];
    vicCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayVIC objectAtIndex:[demandArrayVIC count]-1] floatValue]]];

    NSLog(@"NSW array allocated");
    
    if([minPriceValueVIC compare:[NSNumber numberWithInt:0]] == -1){
        vicMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueVIC compare:[NSNumber numberWithInt:100]] == 1){
        vicMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] < 0 || [[priceArrayVIC objectAtIndex:[priceArrayVIC count]-1] floatValue] >= 100){
        vicCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  SA
    
    NSNumber *minPriceValueSA = [priceArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueSA = [priceArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueSA = [priceArraySA valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueSA = [demandArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueSA = [demandArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueSA = [demandArraySA valueForKeyPath:@"@avg.self"];
    
    saMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueSA];
    saMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueSA];
    saAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueSA];

    saCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue]];
    saMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] - [[priceArraySA objectAtIndex:[priceArraySA count]-2] floatValue]];
    
    
    saMinDemand.text = [numberFormatter stringFromNumber:minDemandValueSA];
    saMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueSA];
    saAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueSA];
    saCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArraySA objectAtIndex:[demandArraySA count]-1] floatValue]]];

    NSLog(@"NSW array allocated");
    
    if([minPriceValueSA compare:[NSNumber numberWithInt:0]] == -1){
        saMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueSA compare:[NSNumber numberWithInt:100]] == 1){
        saMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] < 0 || [[priceArraySA objectAtIndex:[priceArraySA count]-1] floatValue] >= 100){
        saCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  TAS
    NSNumber *minPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@avg.self"];
    
    tasMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueTAS];
    tasMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueTAS];
    tasAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueTAS];

    tasCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue]];
    tasMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] - [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-2] floatValue]];
    
    tasMinDemand.text = [numberFormatter stringFromNumber:minDemandValueTAS];
    tasMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueTAS];
    tasAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueTAS];
    tasCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayTAS objectAtIndex:[demandArrayTAS count]-1] floatValue]]];
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueTAS compare:[NSNumber numberWithInt:0]] == -1){
        tasMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueTAS compare:[NSNumber numberWithInt:100]] == 1){
        tasMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] < 0 || [[priceArrayTAS objectAtIndex:[priceArrayTAS count]-1] floatValue] >= 100){
        tasCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    NSLog(@"When is this run???");
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]]]];
    
    [self.view setNeedsDisplay];
    
    demandArrayNSW=nil;
    demandArrayQLD=nil;
    demandArraySA=nil;
    demandArrayTAS=nil;
    demandArrayVIC=nil;
    priceArrayNSW=nil;
    priceArrayQLD=nil;
    priceArraySA=nil;
    priceArrayTAS=nil;
    priceArrayVIC=nil;
    timeArrayNSW=nil;
    timeArrayTAS=nil;
    timeArraySA=nil;
    timeArrayVIC=nil;
    timeArrayQLD=nil;
    
    [Utility hideHUDForView:self.view];
}

- (void)loadPart1_30PD {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    hudUpdateUIView.yOffset = -70.f;
    
    [self performSelector:@selector(loadPart2_30PD) withObject:nil afterDelay:0];
}

- (void)loadPart2_30PD {
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date30minPDLastUpdateSnapShot"];
    
    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    NSLog(@"Lastest file has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFile]);
    
    
    //    Display current date time
    
    NSDate *dateNow = [NSDate date];
    
    NSLog(@"Current time stamp is %@",[dateFormatCur stringFromDate:dateNow]);
    
    
    //    FOR 30 MIN VIEW, NEM TIME IS LAGGING BY CURRENT TIME, IE. NEM PERIOD IS BEHIND...
    
    //    Perform logic check here to compare date of latestest stored file vs. current date
    //    if current date time is < NEM time stamp + 28mins then don't do web call use last stored file
    
    //    if dateLastFile does not exist that means there is no historical stored data file, then force the webcall
    //    also force the web call if DateLastFile is greater than NEM time mins let say 28mins
    
    
    NSDate *DateLastFileAdj = [DateLastFile dateByAddingTimeInterval:-60*2];
    
    NSLog(@"Lastest file ADJ has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFileAdj]);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30PD.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    DateLastFile=nil;
    if(DateLastFile==NULL || ([DateLastFileAdj compare:dateNow]==NSOrderedAscending) || jsonArray == nil || [jsonArray count] == 0)
        
    {
        NSLog(@"Current time is greater than ADJ time - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_30PD_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than ADJ time - USE LOCAL FILE");
        
        [self loadPart3_30PD_local];
    }
    
}

- (void)process30PDminData:(NSDictionary *)response withError:(NSError *)error
{
    [Utility hideHUDForView:self.view];
    
    if (!response || error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    {

        NSArray *jsonArray = [response objectForKey:@"5MIN"];
        
        // save the array to file
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30PD.CSV"];
        
        [jsonArray writeToFile:dbPathCache atomically:YES];
        
        //                                                        subset the jsonArray be desired region
        
        
        timeArrayNSW = [[NSMutableArray alloc] init];
        priceArrayNSW = [[NSMutableArray alloc] init];
        demandArrayNSW = [[NSMutableArray alloc] init];
        
        timeArrayQLD = [[NSMutableArray alloc] init];
        priceArrayQLD = [[NSMutableArray alloc] init];
        demandArrayQLD = [[NSMutableArray alloc] init];
        
        timeArrayVIC = [[NSMutableArray alloc] init];
        priceArrayVIC = [[NSMutableArray alloc] init];
        demandArrayVIC = [[NSMutableArray alloc] init];
        
        timeArraySA = [[NSMutableArray alloc] init];
        priceArraySA = [[NSMutableArray alloc] init];
        demandArraySA = [[NSMutableArray alloc] init];
        
        timeArrayTAS = [[NSMutableArray alloc] init];
        priceArrayTAS = [[NSMutableArray alloc] init];
        demandArrayTAS = [[NSMutableArray alloc] init];
        //NSLog(@"This is the data!!! %@", jsonResult);
        
        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
        
        
        //                                                        NSLog(@"date value is %@", jsonArray);
        
        
        
        for(int i=0; i<[jsonArray count]; i++){
            
            
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"NSW1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ) {
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayNSW addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayNSW addObject:rrpNum];
                [demandArrayNSW addObject:demandNum];
                
                
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"QLD1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayQLD addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayQLD addObject:rrpNum];
                [demandArrayQLD addObject:demandNum];
                
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"VIC1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayVIC addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayVIC addObject:rrpNum];
                [demandArrayVIC addObject:demandNum];
                
                
            }
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"SA1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArraySA addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArraySA addObject:rrpNum];
                [demandArraySA addObject:demandNum];
                
                
            }
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"TAS1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
                
                // convert crappy dates to normal dates
                
                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                
                // NSLog(@"date value is %@", dTrim);
                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                
                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                
                [timeArrayTAS addObject:[dateFormatTrim stringFromDate:dTrim]];
                [priceArrayTAS addObject:rrpNum];
                [demandArrayTAS addObject:demandNum];
                
                
            }
            
        }
        
        //                                                        NSLog(@"This is price!!! %@, %@, %@", timeArrayRaw, priceArrayRaw, demandArrayRaw);
        
    }
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        //===========  NSW
        
        //NSLog(@"price array value is %@", priceArrayNSW);
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"#,##0"];
        
        NSNumberFormatter *numberFormatterPrice = [[NSNumberFormatter alloc] init];
        [numberFormatterPrice setPositiveFormat:@"#,##0.0"];
        
        
        NSNumber *minPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@min.self"];
        NSNumber *maxPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@max.self"];
        NSNumber *avgPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@avg.self"];
        
        NSNumber *minDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@min.self"];
        NSNumber *maxDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@max.self"];
        NSNumber *avgDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@avg.self"];
        
        nswMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueNSW];
        nswMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueNSW];
        nswAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueNSW];
        
        
        
        //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
        nswCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:0] floatValue]];
        nswMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:1] floatValue] - [[priceArrayNSW objectAtIndex:0] floatValue]];
        
        
        
        nswMinDemand.text = [numberFormatter stringFromNumber:minDemandValueNSW];
        nswMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueNSW];
        nswAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueNSW];
        nswCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayNSW objectAtIndex:0] floatValue]]];
        
        //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
        //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
        //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
        
        
        NSLog(@"NSW array allocated");
        
        if([minPriceValueNSW compare:[NSNumber numberWithInt:0]] == -1){
            nswMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            nswMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //returns -1  if a < b, 0 if a == b and 1 if a > b
        if([maxPriceValueNSW compare:[NSNumber numberWithInt:100]] == 1){
            nswMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            nswMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        if([[priceArrayNSW objectAtIndex:0] floatValue] < 0 || [[priceArrayNSW objectAtIndex:0] floatValue] >= 100){
            nswCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            nswCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        
        //===========  QLD
        
        
        
        NSNumber *minPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@min.self"];
        NSNumber *maxPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@max.self"];
        NSNumber *avgPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@avg.self"];
        
        NSNumber *minDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@min.self"];
        NSNumber *maxDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@max.self"];
        NSNumber *avgDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@avg.self"];
        
        qldMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueQLD];
        qldMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueQLD];
        qldAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueQLD];
        
        
        
        //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
        qldCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:0] floatValue]];
        qldMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:1] floatValue] - [[priceArrayQLD objectAtIndex:0] floatValue]];
        
        
        
        qldMinDemand.text = [numberFormatter stringFromNumber:minDemandValueQLD];
        qldMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueQLD];
        qldAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueQLD];
        qldCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayQLD objectAtIndex:0] floatValue]]];
        
        //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
        //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
        //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
        
        
        NSLog(@"NSW array allocated");
        
        if([minPriceValueQLD compare:[NSNumber numberWithInt:0]] == -1){
            qldMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            qldMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //returns -1  if a < b, 0 if a == b and 1 if a > b
        if([maxPriceValueQLD compare:[NSNumber numberWithInt:100]] == 1){
            qldMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            qldMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        if([[priceArrayQLD objectAtIndex:0] floatValue] < 0 || [[priceArrayQLD objectAtIndex:0] floatValue] >= 100){
            qldCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            qldCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        
        //===========  VIC
        
        
        NSNumber *minPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@min.self"];
        NSNumber *maxPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@max.self"];
        NSNumber *avgPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@avg.self"];
        
        NSNumber *minDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@min.self"];
        NSNumber *maxDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@max.self"];
        NSNumber *avgDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@avg.self"];
        
        vicMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueVIC];
        vicMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueVIC];
        vicAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueVIC];
        
        
        
        //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
        vicCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:0] floatValue]];
        vicMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:1] floatValue] - [[priceArrayVIC objectAtIndex:0] floatValue]];
        
        
        
        vicMinDemand.text = [numberFormatter stringFromNumber:minDemandValueVIC];
        vicMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueVIC];
        vicAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueVIC];
        vicCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayVIC objectAtIndex:0] floatValue]]];
        
        //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
        //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
        //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
        
        
        NSLog(@"NSW array allocated");
        
        if([minPriceValueVIC compare:[NSNumber numberWithInt:0]] == -1){
            vicMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            vicMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //returns -1  if a < b, 0 if a == b and 1 if a > b
        if([maxPriceValueVIC compare:[NSNumber numberWithInt:100]] == 1){
            vicMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            vicMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        if([[priceArrayVIC objectAtIndex:0] floatValue] < 0 || [[priceArrayVIC objectAtIndex:0] floatValue] >= 100){
            vicCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            vicCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //===========  SA
        
        
        NSNumber *minPriceValueSA = [priceArraySA valueForKeyPath:@"@min.self"];
        NSNumber *maxPriceValueSA = [priceArraySA valueForKeyPath:@"@max.self"];
        NSNumber *avgPriceValueSA = [priceArraySA valueForKeyPath:@"@avg.self"];
        
        NSNumber *minDemandValueSA = [demandArraySA valueForKeyPath:@"@min.self"];
        NSNumber *maxDemandValueSA = [demandArraySA valueForKeyPath:@"@max.self"];
        NSNumber *avgDemandValueSA = [demandArraySA valueForKeyPath:@"@avg.self"];
        
        saMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueSA];
        saMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueSA];
        saAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueSA];
        
        
        
        //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
        saCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:0] floatValue]];
        saMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:1] floatValue] - [[priceArraySA objectAtIndex:0] floatValue]];
        
        
        
        saMinDemand.text = [numberFormatter stringFromNumber:minDemandValueSA];
        saMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueSA];
        saAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueSA];
        saCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArraySA objectAtIndex:0] floatValue]]];
        
        //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
        //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
        //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
        
        
        NSLog(@"NSW array allocated");
        
        if([minPriceValueSA compare:[NSNumber numberWithInt:0]] == -1){
            saMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            saMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //returns -1  if a < b, 0 if a == b and 1 if a > b
        if([maxPriceValueSA compare:[NSNumber numberWithInt:100]] == 1){
            saMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            saMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        if([[priceArraySA objectAtIndex:0] floatValue] < 0 || [[priceArraySA objectAtIndex:0] floatValue] >= 100){
            saCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            saCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        
        //===========  TAS
        
        
        NSNumber *minPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@min.self"];
        NSNumber *maxPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@max.self"];
        NSNumber *avgPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@avg.self"];
        
        NSNumber *minDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@min.self"];
        NSNumber *maxDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@max.self"];
        NSNumber *avgDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@avg.self"];
        
        tasMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueTAS];
        tasMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueTAS];
        tasAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueTAS];
        
        
        
        //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
        tasCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:0] floatValue]];
        tasMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:1] floatValue] - [[priceArrayTAS objectAtIndex:0] floatValue]];
        
        
        
        tasMinDemand.text = [numberFormatter stringFromNumber:minDemandValueTAS];
        tasMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueTAS];
        tasAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueTAS];
        tasCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayTAS objectAtIndex:0] floatValue]]];
        
        //            nswMinDemand.text = [NSString stringWithFormat:@"%0.0f", minDemand];
        //            nswMaxDemand.text = [NSString stringWithFormat:@"%0.0f", maxDemand];
        //            nswCurDemand.text = [NSString stringWithFormat:@"%0.0f", [[demandArrayNSW objectAtIndex:287] floatValue]];
        
        
        NSLog(@"NSW array allocated");
        
        if([minPriceValueTAS compare:[NSNumber numberWithInt:0]] == -1){
            tasMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            tasMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        //returns -1  if a < b, 0 if a == b and 1 if a > b
        if([maxPriceValueTAS compare:[NSNumber numberWithInt:100]] == 1){
            tasMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            tasMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        if([[priceArrayTAS objectAtIndex:0] floatValue] < 0 || [[priceArrayTAS objectAtIndex:0] floatValue] >= 100){
            tasCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
            tasCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        }
        
        NSLog(@"When is this run???");
        
        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
        
        NSDateFormatter *dateFormatEnd = [[NSDateFormatter alloc] init];
        [dateFormatEnd setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatEnd setDateFormat:@"dd/MM HH:mm"];
        
        dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:0]]]];
        
        //    now save date stamp latest NEM period
        
        headingbut3.titleLabel.text=[NSString stringWithFormat:@"min, max, avg stats for period till %@",[dateFormatEnd stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]]]];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:0]] forKey:@"date30minPDLastUpdateSnapShot"];
        
        [self.view setNeedsDisplay];
        
        demandArrayNSW=nil;
        demandArrayQLD=nil;
        demandArraySA=nil;
        demandArrayTAS=nil;
        demandArrayVIC=nil;
        priceArrayNSW=nil;
        priceArrayQLD=nil;
        priceArraySA=nil;
        priceArrayTAS=nil;
        priceArrayVIC=nil;
        timeArrayNSW=nil;
        timeArrayTAS=nil;
        timeArraySA=nil;
        timeArrayVIC=nil;
        timeArrayQLD=nil;
        
        [Utility hideHUDForView:self.view];
        
    });
}


-(void) loadPart3_30PD_www
{
    NSDictionary *parameters = @{ @"timeScale": @[ @"30MIN" ] };
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] fetchAEMOData:parameters completion:^(NSDictionary *response, NSError *error) {
        [weakSelf process30PDminData:response withError:error];
    }];
}

-(void) loadPart3_30PD_local{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"SNAPSHOT_30PD.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    
    timeArrayNSW = [[NSMutableArray alloc] init];
    priceArrayNSW = [[NSMutableArray alloc] init];
    demandArrayNSW = [[NSMutableArray alloc] init];
    
    timeArrayQLD = [[NSMutableArray alloc] init];
    priceArrayQLD = [[NSMutableArray alloc] init];
    demandArrayQLD = [[NSMutableArray alloc] init];
    
    timeArrayVIC = [[NSMutableArray alloc] init];
    priceArrayVIC = [[NSMutableArray alloc] init];
    demandArrayVIC = [[NSMutableArray alloc] init];
    
    timeArraySA = [[NSMutableArray alloc] init];
    priceArraySA = [[NSMutableArray alloc] init];
    demandArraySA = [[NSMutableArray alloc] init];
    
    timeArrayTAS = [[NSMutableArray alloc] init];
    priceArrayTAS = [[NSMutableArray alloc] init];
    demandArrayTAS = [[NSMutableArray alloc] init];
    //NSLog(@"This is the data!!! %@", jsonResult);
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    
    //                                                        NSLog(@"date value is %@", jsonArray);
    
    
    
    for(int i=0; i<[jsonArray count]; i++){
        
        
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"NSW1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ) {
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            // NSLog(@"date value is %@", dTrim);
            //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
            
            // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
            
            [timeArrayNSW addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayNSW addObject:rrpNum];
            [demandArrayNSW addObject:demandNum];
            
            
            
            
        }
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"QLD1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            // NSLog(@"date value is %@", dTrim);
            //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
            
            // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
            
            [timeArrayQLD addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayQLD addObject:rrpNum];
            [demandArrayQLD addObject:demandNum];
            
            
            
        }
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"VIC1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            // NSLog(@"date value is %@", dTrim);
            //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
            
            // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
            
            [timeArrayVIC addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayVIC addObject:rrpNum];
            [demandArrayVIC addObject:demandNum];
            
            
        }
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"SA1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArraySA addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArraySA addObject:rrpNum];
            [demandArraySA addObject:demandNum];
        }
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:@"TAS1"] && [[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"FORECAST"] ){
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            [timeArrayTAS addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayTAS addObject:rrpNum];
            [demandArrayTAS addObject:demandNum];
        }
    }
    
    //===========  NSW
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    NSNumberFormatter *numberFormatterPrice = [[NSNumberFormatter alloc] init];
    [numberFormatterPrice setPositiveFormat:@"#,##0.0"];
    
    
    NSNumber *minPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueNSW = [priceArrayNSW valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueNSW = [demandArrayNSW valueForKeyPath:@"@avg.self"];
    
    nswMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueNSW];
    nswMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueNSW];
    nswAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueNSW];
    
    nswCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:0] floatValue]];
    nswMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayNSW objectAtIndex:1] floatValue] - [[priceArrayNSW objectAtIndex:0] floatValue]];

    nswMinDemand.text = [numberFormatter stringFromNumber:minDemandValueNSW];
    nswMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueNSW];
    nswAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueNSW];
    nswCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayNSW objectAtIndex:0] floatValue]]];

    NSLog(@"NSW array allocated");
    
    if([minPriceValueNSW compare:[NSNumber numberWithInt:0]] == -1){
        nswMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueNSW compare:[NSNumber numberWithInt:100]] == 1){
        nswMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayNSW objectAtIndex:0] floatValue] < 0 || [[priceArrayNSW objectAtIndex:0] floatValue] >= 100){
        nswCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        nswCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  QLD
    NSNumber *minPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueQLD = [priceArrayQLD valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueQLD = [demandArrayQLD valueForKeyPath:@"@avg.self"];
    
    qldMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueQLD];
    qldMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueQLD];
    qldAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueQLD];
    
    qldCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:0] floatValue]];
    qldMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayQLD objectAtIndex:1] floatValue] - [[priceArrayQLD objectAtIndex:0] floatValue]];
    
    qldMinDemand.text = [numberFormatter stringFromNumber:minDemandValueQLD];
    qldMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueQLD];
    qldAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueQLD];
    qldCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayQLD objectAtIndex:0] floatValue]]];

    NSLog(@"NSW array allocated");
    
    if([minPriceValueQLD compare:[NSNumber numberWithInt:0]] == -1){
        qldMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueQLD compare:[NSNumber numberWithInt:100]] == 1){
        qldMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayQLD objectAtIndex:0] floatValue] < 0 || [[priceArrayQLD objectAtIndex:0] floatValue] >= 100){
        qldCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        qldCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  VIC
    NSNumber *minPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueVIC = [priceArrayVIC valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueVIC = [demandArrayVIC valueForKeyPath:@"@avg.self"];
    
    vicMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueVIC];
    vicMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueVIC];
    vicAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueVIC];
    
    vicCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:0] floatValue]];
    vicMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayVIC objectAtIndex:1] floatValue] - [[priceArrayVIC objectAtIndex:0] floatValue]];
    
    vicMinDemand.text = [numberFormatter stringFromNumber:minDemandValueVIC];
    vicMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueVIC];
    vicAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueVIC];
    vicCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayVIC objectAtIndex:0] floatValue]]];
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueVIC compare:[NSNumber numberWithInt:0]] == -1){
        vicMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueVIC compare:[NSNumber numberWithInt:100]] == 1){
        vicMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayVIC objectAtIndex:0] floatValue] < 0 || [[priceArrayVIC objectAtIndex:0] floatValue] >= 100){
        vicCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        vicCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  SA
    NSNumber *minPriceValueSA = [priceArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueSA = [priceArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueSA = [priceArraySA valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueSA = [demandArraySA valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueSA = [demandArraySA valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueSA = [demandArraySA valueForKeyPath:@"@avg.self"];
    
    saMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueSA];
    saMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueSA];
    saAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueSA];
    
    saCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:0] floatValue]];
    saMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArraySA objectAtIndex:1] floatValue] - [[priceArraySA objectAtIndex:0] floatValue]];
    
    saMinDemand.text = [numberFormatter stringFromNumber:minDemandValueSA];
    saMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueSA];
    saAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueSA];
    saCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArraySA objectAtIndex:0] floatValue]]];
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueSA compare:[NSNumber numberWithInt:0]] == -1){
        saMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueSA compare:[NSNumber numberWithInt:100]] == 1){
        saMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArraySA objectAtIndex:0] floatValue] < 0 || [[priceArraySA objectAtIndex:0] floatValue] >= 100){
        saCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        saCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //===========  TAS
    NSNumber *minPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgPriceValueTAS = [priceArrayTAS valueForKeyPath:@"@avg.self"];
    
    NSNumber *minDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@min.self"];
    NSNumber *maxDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@max.self"];
    NSNumber *avgDemandValueTAS = [demandArrayTAS valueForKeyPath:@"@avg.self"];
    
    tasMinPrice.text = [numberFormatterPrice stringFromNumber:minPriceValueTAS];
    tasMaxPrice.text = [numberFormatterPrice stringFromNumber:maxPriceValueTAS];
    tasAvgPrice.text = [numberFormatterPrice stringFromNumber:avgPriceValueTAS];
    
    //nswVWPrice.text = [NSString stringWithFormat:@"%0.2f", (priceDemand / sumDemand)];
    tasCurPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:0] floatValue]];
    tasMvtPrice.text = [NSString stringWithFormat:@"%0.2f", [[priceArrayTAS objectAtIndex:1] floatValue] - [[priceArrayTAS objectAtIndex:0] floatValue]];
    
    tasMinDemand.text = [numberFormatter stringFromNumber:minDemandValueTAS];
    tasMaxDemand.text = [numberFormatter stringFromNumber:maxDemandValueTAS];
    tasAvgDemand.text = [numberFormatter stringFromNumber:avgDemandValueTAS];
    tasCurDemand.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[demandArrayTAS objectAtIndex:0] floatValue]]];
    
    NSLog(@"NSW array allocated");
    
    if([minPriceValueTAS compare:[NSNumber numberWithInt:0]] == -1){
        tasMinPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMinPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    //returns -1  if a < b, 0 if a == b and 1 if a > b
    if([maxPriceValueTAS compare:[NSNumber numberWithInt:100]] == 1){
        tasMaxPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasMaxPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    if([[priceArrayTAS objectAtIndex:0] floatValue] < 0 || [[priceArrayTAS objectAtIndex:0] floatValue] >= 100){
        tasCurPrice.backgroundColor = [UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1];
        tasCurPrice.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    }
    
    NSLog(@"When is this run???");
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    NSDateFormatter *dateFormatEnd = [[NSDateFormatter alloc] init];
    [dateFormatEnd setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatEnd setDateFormat:@"dd/MM HH:mm"];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:0]]]];
    
    //    now save date stamp latest NEM period
    headingbut3.titleLabel.text=[NSString stringWithFormat:@"min, max, avg stats for period till %@",[dateFormatEnd stringFromDate:[dateFormatTrim dateFromString:[timeArrayNSW objectAtIndex:[timeArrayNSW count]-1]]]];
    
    
    [self.view setNeedsDisplay];
    
    demandArrayNSW=nil;
    demandArrayQLD=nil;
    demandArraySA=nil;
    demandArrayTAS=nil;
    demandArrayVIC=nil;
    priceArrayNSW=nil;
    priceArrayQLD=nil;
    priceArraySA=nil;
    priceArrayTAS=nil;
    priceArrayVIC=nil;
    timeArrayNSW=nil;
    timeArrayTAS=nil;
    timeArraySA=nil;
    timeArrayVIC=nil;
    timeArrayQLD=nil;
    
    [Utility hideHUDForView:self.view];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
