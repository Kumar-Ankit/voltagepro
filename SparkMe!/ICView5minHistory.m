//
//  ICViewController.m
//  Sparky
//
//  Created by Hung on 12/08/12.
//
//

#import "ICView5minHistory.h"
#import "TFHpple.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

#import "DispPrice.h"
#import "DispRegionSum.h"
#import "IcFlows.h"


// Still need to save history csv file for historical constraints view to work

@interface ICView5minHistory ()

@end

@implementation ICView5minHistory

@synthesize dateLastUpdated, saDemand, saGen, saNetIC, qldDemand, qldGen, qldNetIC, nswDemand, nswGen, nswNetIC, vicDemand, vicGen, vicNetIC, tasDemand, tasGen, tasNetIC, dispPrice, dispRegion, icFlows,  headingbut1, saPrice, vicPrice, qldPrice, nswPrice, tasPrice, priceLabel, segTime, nswQldQNI, nswQldTer, vicTasBass,
saVicHey, saVicMur, vicNsw, terranoraICLine, qniICLine, basslinkICLine, murraylinkICLine, heywoodICLine, vicnswICLine, periodStepper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)revealUnderRight:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECLeft];
    
}

//- (IBAction)SwipeLeft:(id)sender {
//
//        [self.slidingViewController anchorTopViewTo:ECLeft];
//}


- (IBAction)valueChanged:(UIStepper *)sender {
    NSInteger stepperValue = periodStepper.value;
    
    NSLog(@"Price stepper value change to is %ld", (long)stepperValue);
    
    [[NSUserDefaults standardUserDefaults] setInteger:stepperValue forKey:@"IndexValue5minHistory"];
    
    [self viewDidLoad];
}



-(IBAction)segmentControlTap:(UISegmentedControl *)sender{
    
    
    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            //            5min tapped
            NSLog(@"5min button tapped");
            [self viewDidLoad];
            break;
            
            
            
        case 1:
            //            30min tapped
            NSLog(@"30min button tapped");
            [self viewDidLoad];
            break;
            
            
        default:
            break;
            
    }
    
    
}


- (void)loadPart1_5 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2_5) withObject:nil afterDelay:0];
}


- (void)loadPart2_5 {
    
    
    //    If index value is one then run local file from main ICViewController and set history file as latest file
    
    NSInteger fileIndexValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"IndexValue5minHistory"];
    
    if(fileIndexValue==0 || fileIndexValue==1)
    {
        //        NSLog(@"Current time is greater than NEM time minus 2mins (ADJ time) - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_5_local];
        
        NSLog(@"local file - current time stamp run");
        
    }
    else{
        
        //        NSLog(@"Current time is less than NEM time minus 2mins (ADJ time) - USE LOCAL FILE");
        
        [self loadPart3_5_www];
        
        NSLog(@"historical time stamp created - current time stamp run");
    }
    
    [self loadPart4_arrows];
    
    BOOL didRunBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"didRunBefore"];
    
    if (!didRunBefore) {
        //Your Launch Code
        
        [self.slidingViewController anchorTopViewTo:ECLeft];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didRunBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


- (void)loadPart3_5_local {
    
    
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN.CSV"];
    
    NSString *dbPathCacheLastHist = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN_HIST.CSV"];
    
    
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCacheLast encoding:NSUTF8StringEncoding error:nil];
    //
    //    NSLog(@"%@", dataStr);
    
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    trim white space
    
    
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    
    //    vic5min = [dataStr componentsSeparatedByString: @","];
    
    
    //    NSMutableArray *priceArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *regionSumArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *icArray = [[NSMutableArray alloc] init];
    
    dispPrice = [[DispPrice alloc] init];
    dispPrice.state = [[NSMutableArray alloc] init];
    dispPrice.price = [[NSMutableArray alloc] init];
    
    dispRegion = [[DispRegionSum alloc] init];
    dispRegion.state = [[NSMutableArray alloc] init];
    dispRegion.totDem = [[NSMutableArray alloc] init];
    dispRegion.disGen = [[NSMutableArray alloc] init];
    dispRegion.disLoad = [[NSMutableArray alloc] init];
    dispRegion.netInchg = [[NSMutableArray alloc] init];
    
    icFlows = [[IcFlows alloc] init];
    icFlows.icID = [[NSMutableArray alloc] init];
    icFlows.meterFlow = [[NSMutableArray alloc] init];
    icFlows.mwFlow = [[NSMutableArray alloc] init];
    icFlows.mwLosses = [[NSMutableArray alloc] init];
    icFlows.exportLimit = [[NSMutableArray alloc] init];
    icFlows.importLimit = [[NSMutableArray alloc] init];
    
    icFlows.exportConId = [[NSMutableArray alloc] init];
    icFlows.importConId = [[NSMutableArray alloc] init];
    
    //    extract NEM time from cell in file
    
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    NSArray *components = [[disp5min objectAtIndex:2] componentsSeparatedByString:@","];
    
    //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
    
    [icDateTime addObject:[components objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"date time stamp from file is %@",icDateTimeStripped);
    
    NSString *dateStr = icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date5min = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    NSString *st = [dateFormat stringFromDate:date5min];
    NSLog(@"converted date time stamp from file is %@",st);
    
    dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date5min]];
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"PRICE"]){
            
            priceIndex = i;
            break;
            
        }
        
        
        
        
    }
    
    
    NSLog(@"The value of the price row is %li", (long)priceIndex);
    
    for(long i=priceIndex; i< priceIndex + 6; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:9]];
        
    }
    
    for(long i=priceIndex + 6; i< priceIndex + 12; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:9]];
        [dispRegion.disGen addObject: [components objectAtIndex:13]];
        [dispRegion.disLoad addObject: [components objectAtIndex:14]];
        [dispRegion.netInchg addObject: [components objectAtIndex:15]];
        
        
    }
    
    for(long i=priceIndex + 12; i< priceIndex + 19; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [icFlows.icID addObject: [components objectAtIndex:6]];
        [icFlows.meterFlow addObject: [components objectAtIndex:9]];
        [icFlows.mwFlow addObject: [components objectAtIndex:10]];
        [icFlows.mwLosses addObject: [components objectAtIndex:11]];
        [icFlows.exportLimit addObject: [components objectAtIndex:15]];
        [icFlows.importLimit addObject: [components objectAtIndex:16]];
        
        [icFlows.exportConId addObject: [components objectAtIndex:18]];
        [icFlows.importConId addObject: [components objectAtIndex:19]];
        
        
    }
    
    
    NSLog(@"%@    %@", dispPrice.state, dispPrice.price);
    NSLog(@"%@   %@     %@     %@     %@", dispRegion.state, dispRegion.totDem, dispRegion.disGen, dispRegion.disLoad, dispRegion.netInchg);
    
    NSLog(@"%@   %@     %@     %@     %@     %@", icFlows.icID, icFlows.meterFlow, icFlows.mwFlow, icFlows.mwLosses, icFlows.exportLimit, icFlows.importLimit);
    
    
    
    //    assign values to fields
    saDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:3] floatValue]];
    saGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:3] floatValue]];
    saNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:3] floatValue]];
    
    qldDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:2] floatValue]];
    qldGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:2] floatValue]];
    qldNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:2] floatValue]];
    
    nswDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:1] floatValue]];
    nswGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:1] floatValue]];
    nswNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:1] floatValue]];
    
    vicDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:5] floatValue]];
    vicGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:5] floatValue]];
    vicNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:5] floatValue]];
    
    tasDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:4] floatValue]];
    tasGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:4] floatValue]];
    tasNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:4] floatValue]];
    
    //    assign conditional formatting to NetIC values
    
    NSLog(@"pass 1");
    
    if([[dispRegion.netInchg objectAtIndex:3] floatValue] < 0){
        saNetIC.textColor = [UIColor redColor];
    } else {
        saNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:2] floatValue] < 0){
        qldNetIC.textColor = [UIColor redColor];
    } else {
        qldNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:1] floatValue] < 0){
        nswNetIC.textColor = [UIColor redColor];
    } else {
        nswNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:5] floatValue] < 0){
        vicNetIC.textColor = [UIColor redColor];
    } else {
        vicNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:4] floatValue] < 0){
        tasNetIC.textColor = [UIColor redColor];
    } else {
        tasNetIC.textColor = [UIColor yellowColor];
    }
    
    
    NSLog(@"pass 2");
    
    //    add labels for state/region price
    
    NSLog(@"Index SA Price is %lu",(unsigned long)[dispPrice.state indexOfObject:@"SA1"]);
    
    NSInteger indexSAPrice = [dispPrice.state indexOfObject:@"SA1"];
    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    saPrice.layer.borderWidth = 1.0;
    
    NSLog(@"pass 3a");
    
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    tasPrice.layer.borderWidth = 1.0;
    
    
    
    NSLog(@"pass 3");
    
    NSLog(@"SA region index is %li",(long)indexSAPrice);
    
    NSLog(@"SA Price is %@",indexSAPriceVal);
    
    
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //    copy current DISPATCHIS5MIN.CSV to file DISPATCHIS5MIN_HIST.CSV
    
    // Attempt to delete the last stored file DISPATCHIS5MIN.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLastHist error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    //    NSLog(@"last stored CSV file DISPATCHIS5MIN_HIST.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr copyItemAtPath:dbPathCacheLast toPath:dbPathCacheLastHist error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
}



- (void)loadPart3_5_www {
    
    
    
    // 4
    NSArray *nemFiles = [[NSMutableArray alloc] init];
    
    //    load up saved NEM file list
    
    nemFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"nemFiles5mKey"];
    
    //    Use index from menu selection to choose 5min period
    
    NSInteger fileIndexValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"IndexValue5minHistory"];
    
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-fileIndexValue];
    
    //    NSLog(@"Last item in array : %@", latestFileName);
    
    //    Now fetch the file
    
    
    NSString *urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/DispatchIS_Reports/" stringByAppendingString:latestFileName];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //    copy zip file from www
    NSData *fetchedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    //    unzipped filename will be same as zip file but with csv extension
    
    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    
    //    NSLog(@"filname is : %@", fileNameNoExt);
    
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    
    //    NSLog(@"CSV filname is : %@", unzippedFileName);
    
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN_HIST.CSV"];
    
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS.zip"];
    //
    NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    //
    //    //copy zip file
    //
    [fetchedData writeToFile:dbPathCacheZip atomically:YES];
    //    NSLog(@"copy zip file successful from www to cache directory");
    
    
    //
    
    //
    //    //    then unzip to folder
    //
    //
    [SSZipArchive unzipFileAtPath:dbPathCacheZip toDestination:zipPath];
    //
    //    NSLog(@"unzipping file successful");
    //
    //    //    delete zip file in cache directory
    //
    [fileMgr removeItemAtPath:dbPathCacheZip error:nil];
    
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
    //
    //    NSLog(@"%@", dataStr);
    
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    trim white space
    
    
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    
    //    vic5min = [dataStr componentsSeparatedByString: @","];
    
    
    //    NSMutableArray *priceArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *regionSumArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *icArray = [[NSMutableArray alloc] init];
    
    dispPrice = [[DispPrice alloc] init];
    dispPrice.state = [[NSMutableArray alloc] init];
    dispPrice.price = [[NSMutableArray alloc] init];
    
    dispRegion = [[DispRegionSum alloc] init];
    dispRegion.state = [[NSMutableArray alloc] init];
    dispRegion.totDem = [[NSMutableArray alloc] init];
    dispRegion.disGen = [[NSMutableArray alloc] init];
    dispRegion.disLoad = [[NSMutableArray alloc] init];
    dispRegion.netInchg = [[NSMutableArray alloc] init];
    
    icFlows = [[IcFlows alloc] init];
    icFlows.icID = [[NSMutableArray alloc] init];
    icFlows.meterFlow = [[NSMutableArray alloc] init];
    icFlows.mwFlow = [[NSMutableArray alloc] init];
    icFlows.mwLosses = [[NSMutableArray alloc] init];
    icFlows.exportLimit = [[NSMutableArray alloc] init];
    icFlows.importLimit = [[NSMutableArray alloc] init];
    
    icFlows.exportConId = [[NSMutableArray alloc] init];
    icFlows.importConId = [[NSMutableArray alloc] init];
    
    //    extract NEM time from cell in file
    
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    NSArray *components = [[disp5min objectAtIndex:2] componentsSeparatedByString:@","];
    
    //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
    
    [icDateTime addObject:[components objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"date time stamp from file is %@",icDateTimeStripped);
    
    NSString *dateStr = icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date5min = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    //    NSString *st = [dateFormat stringFromDate:date5min];
    //    NSLog(@"converted date time stamp from file is %@",st);
    
    dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date5min]];
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"PRICE"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    //NSLog(@"The value of the price row is %i", priceIndex);
    
    
    for(long i=priceIndex; i< priceIndex + 6; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:9]];
        
    }
    
    for(long i=priceIndex + 6; i< priceIndex + 12; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:9]];
        [dispRegion.disGen addObject: [components objectAtIndex:13]];
        [dispRegion.disLoad addObject: [components objectAtIndex:14]];
        [dispRegion.netInchg addObject: [components objectAtIndex:15]];
        
        
    }
    
    for(long i=priceIndex + 12; i< priceIndex + 19; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [icFlows.icID addObject: [components objectAtIndex:6]];
        [icFlows.meterFlow addObject: [components objectAtIndex:9]];
        [icFlows.mwFlow addObject: [components objectAtIndex:10]];
        [icFlows.mwLosses addObject: [components objectAtIndex:11]];
        [icFlows.exportLimit addObject: [components objectAtIndex:15]];
        [icFlows.importLimit addObject: [components objectAtIndex:16]];
        
        [icFlows.exportConId addObject: [components objectAtIndex:18]];
        [icFlows.importConId addObject: [components objectAtIndex:19]];
        
        
        
        
    }
    
    
    //    NSLog(@"%@    %@", dispPrice.state, dispPrice.price);
    //    NSLog(@"%@   %@     %@     %@     %@", dispRegion.state, dispRegion.totDem, dispRegion.disGen, dispRegion.disLoad, dispRegion.netInchg);
    //
    //    NSLog(@"%@   %@     %@     %@     %@     %@", icFlows.icID, icFlows.meterFlow, icFlows.mwFlow, icFlows.mwLosses, icFlows.exportLimit, icFlows.importLimit);
    
    //    before deleting, move/rename file to DISPATCHIS5MIN.CSV
    
    //    attempt the move
    // For error information
    NSError *error;
    
    //    delete previous existing file
    
    // Attempt to delete the last stored file DISPATCHIS5MIN.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    //    NSLog(@"last stored CSV file DISPATCHIS5MIN_HIST.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    //    NSLog(@"unzipped %@ file renamed to DISPATCHIS5MIN.CSV", unzippedFileName);
    
    
    //    now save date stamp of last stored file
    
    //    [[NSUserDefaults standardUserDefaults] setObject:date5min forKey:@"date5minLastUpdate"];
    
    
    
    
    //    no need for below section as it wastes resources calling file from online store just to get the date stamp of file plus it's not so accurate as it does not provide NEM time interval
    
    //    get file date
    
    //    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]
    //                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    //
    //    NSHTTPURLResponse *response;
    //    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //    if( [response respondsToSelector:@selector( allHeaderFields )] )
    //    {
    //        NSDictionary *metaData = [response allHeaderFields];
    //
    //
    //        NSString *lastModifiedString = [metaData objectForKey:@"Last-Modified"];  //get
    //
    //
    //        //        determine date and time of file
    //
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //
    //        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //        [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    //
    //        NSDate *date_www = [dateFormatter dateFromString:lastModifiedString];
    //        NSLog(@"Date in AEST format: %@", [dateFormatter stringFromDate:date_www]);
    //
    //        dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date_www]];
    //
    //        //        for (id key in metaData) {
    //        //            NSLog(@"key: %@, value: %@ \n", key, [metaData objectForKey:key]);
    //        //        }
    //    }
    
    
    //    assign values to fields
    saDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:3] floatValue]];
    saGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:3] floatValue]];
    saNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:3] floatValue]];
    
    qldDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:2] floatValue]];
    qldGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:2] floatValue]];
    qldNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:2] floatValue]];
    
    nswDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:1] floatValue]];
    nswGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:1] floatValue]];
    nswNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:1] floatValue]];
    
    vicDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:5] floatValue]];
    vicGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:5] floatValue]];
    vicNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:5] floatValue]];
    
    tasDemand.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.totDem objectAtIndex:4] floatValue]];
    tasGen.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.disGen objectAtIndex:4] floatValue]];
    tasNetIC.text = [NSString stringWithFormat:@"%.0f MW",[[dispRegion.netInchg objectAtIndex:4] floatValue]];
    
    //    assign conditional formatting to NetIC values
    
    //    NSLog(@"pass 1");
    
    if([[dispRegion.netInchg objectAtIndex:3] floatValue] < 0){
        saNetIC.textColor = [UIColor redColor];
    } else {
        saNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:2] floatValue] < 0){
        qldNetIC.textColor = [UIColor redColor];
    } else {
        qldNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:1] floatValue] < 0){
        nswNetIC.textColor = [UIColor redColor];
    } else {
        nswNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:5] floatValue] < 0){
        vicNetIC.textColor = [UIColor redColor];
    } else {
        vicNetIC.textColor = [UIColor yellowColor];
    }
    
    if([[dispRegion.netInchg objectAtIndex:4] floatValue] < 0){
        tasNetIC.textColor = [UIColor redColor];
    } else {
        tasNetIC.textColor = [UIColor yellowColor];
    }
    
    
    //    NSLog(@"pass 2");
    
    //    add labels for state/region price
    
    //    NSLog(@"Index SA Price is %i",[dispPrice.state indexOfObject:@"SA1"]);
    
    NSInteger indexSAPrice = [dispPrice.state indexOfObject:@"SA1"];
    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    saPrice.layer.borderWidth = 1.0;
    
    //    NSLog(@"pass 3a");
    
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    tasPrice.layer.borderWidth = 1.0;
    
    
    
    //    NSLog(@"pass 3");
    
    //    NSLog(@"SA region index is %i",indexSAPrice);
    
    //    NSLog(@"SA Price is %@",indexSAPriceVal);
    
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
}


-(void) loadPart4_arrows{
    
    
    
    //    Define terranora IC line
    
    if(
       
       //       if qld price is higher than nsw price and ic flows from qld to nsw then highlight red
       //       if nsw price is higher than qld price and ic flows from nsw to qld then highlight red
       
       (([qldPrice.text floatValue] > [nswPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0))
       
       ||
       
       
       (([qldPrice.text floatValue] < [nswPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:1] floatValue] > 0))
       
       )
        
    {
        terranoraICLine.backgroundColor=[UIColor redColor];
        
    }
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:1] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:1] floatValue] > 0)){
    //
    //            terranoraICLine.backgroundColor=[UIColor whiteColor];
    //
    //        }
    
    else
        
    {
        
        terranoraICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    //    Define QNI IC line
    
    if(
       
       
       (([qldPrice.text floatValue] > [nswPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:2] floatValue] < 0))
       
       ||
       
       
       (([qldPrice.text floatValue] < [nswPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:2] floatValue] > 0))
       
       )
        
    {
        qniICLine.backgroundColor=[UIColor redColor];
        
    }
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:2] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:2] floatValue] > 0)){
    //
    //        qniICLine.backgroundColor=[UIColor whiteColor];
    //
    //    }
    
    else {
        
        qniICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    //    Define BassLink IC line
    
    if(
       
       
       (([vicPrice.text floatValue] > [tasPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:3] floatValue] < 0))
       
       ||
       
       
       (([vicPrice.text floatValue] < [tasPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:3] floatValue] > 0))
       
       )
        
    {
        basslinkICLine.backgroundColor=[UIColor redColor];
        
    }
    
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:3] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:3] floatValue] > 0)){
    //
    //        basslinkICLine.backgroundColor=[UIColor whiteColor];
    //
    //    }
    
    
    
    else {
        
        basslinkICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    //    Define Murraylink IC line
    
    if(
       
       
       (([saPrice.text floatValue] > [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:4] floatValue] < 0))
       
       ||
       
       
       (([saPrice.text floatValue] < [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:4] floatValue] > 0))
       
       )
        
    {
        murraylinkICLine.backgroundColor=[UIColor redColor];
        
    }
    
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:4] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:4] floatValue] > 0)){
    //
    //        murraylinkICLine.backgroundColor=[UIColor whiteColor];
    //
    //    }
    
    
    else {
        
        murraylinkICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    //    Define Heywood IC line
    
    if(
       
       
       (([saPrice.text floatValue] > [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:5] floatValue] < 0))
       
       ||
       
       
       (([saPrice.text floatValue] < [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:5] floatValue] > 0))
       
       )
        
    {
        heywoodICLine.backgroundColor=[UIColor redColor];
        
    }
    
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:5] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:5] floatValue] > 0)){
    //
    //        heywoodICLine.backgroundColor=[UIColor whiteColor];
    //
    //    }
    
    
    else {
        
        heywoodICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    //    Define vic->nsw IC line
    
    if(
       
       
       (([nswPrice.text floatValue] > [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:6] floatValue] < 0))
       
       ||
       
       
       (([nswPrice.text floatValue] < [vicPrice.text floatValue])  &&  ([[icFlows.mwFlow objectAtIndex:6] floatValue] > 0))
       
       )
        
    {
        vicnswICLine.backgroundColor=[UIColor redColor];
        
    }
    
    //    else if ((segTime.selectedSegmentIndex==0) && ([[icFlows.exportLimit objectAtIndex:6] floatValue] < 0 || [[icFlows.importLimit objectAtIndex:6] floatValue] > 0)){
    //
    //        vicnswICLine.backgroundColor=[UIColor whiteColor];
    //
    //    }
    
    
    else {
        
        vicnswICLine.backgroundColor=[UIColor yellowColor];
        
    }
    
    
    //    UIView *terranorralineView = [[UIView alloc] initWithFrame:CGRectMake(253, 190, 1, 40)];
    //    terranorralineView.backgroundColor = [UIColor yellowColor];
    //    [self.view addSubview:terranorralineView];
    //    terranorralineView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    //
    //    terranorralineView=nil;
    
    
    double speedValue = 0.50;
    
    
    //    nsw to qld terranorra
    
    
    
    
    if ([[icFlows.mwFlow objectAtIndex:1] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.nswQldTer setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.nswQldTer setTitle:@"=" forState:UIControlStateNormal];
        [self.nswQldTer setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        nswQldTer.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        
    }
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    else if  (
              
              (segTime.selectedSegmentIndex==0)
              
              &&
              
              
              (
               
               ([[icFlows.mwFlow objectAtIndex:1] floatValue] >= [[icFlows.exportLimit objectAtIndex:1] floatValue]-.01)
               
               ||
               
               ([[icFlows.mwFlow objectAtIndex:1] floatValue] <= [[icFlows.importLimit objectAtIndex:1] floatValue]+.01)
               
               )
              
              
              //       (
              //
              //        ([[icFlows.mwFlow objectAtIndex:1] floatValue] > 0 && ([[icFlows.mwFlow objectAtIndex:1] floatValue] >= [[icFlows.exportLimit objectAtIndex:1] floatValue]-.01))
              //
              //        ||
              //
              //        ([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0 && ([[icFlows.mwFlow objectAtIndex:1] floatValue] <= [[icFlows.importLimit objectAtIndex:1] floatValue]+.01))
              //
              //        )
              
              
              
              
              )
        
    {
        
        //        set to red
        
        //        NSLog(@"Set terranorra to red");
        
        if([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0){
            [self.nswQldTer setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
            
            nswQldTer.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
             [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
             nil];
            nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldTer.imageView startAnimating];
        } else {
            
            [self.nswQldTer setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
            
            nswQldTer.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
             [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
             nil];
            nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldTer.imageView startAnimating];
            
        }
        
        
    }
    
    
    
    else {
        
        //        set to yellow
        
        //        NSLog(@"Set terranorra to yellow");
        
        if([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0){
            [self.nswQldTer setImage:[UIImage imageNamed:@"down-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            nswQldTer.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1-yellow.png"],
             [UIImage imageNamed:@"down-arrow-2-yellow.png"], [UIImage imageNamed:@"down-arrow-3-yellow.png"],
             nil];
            nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldTer.imageView startAnimating];
        } else {
            
            [self.nswQldTer setImage:[UIImage imageNamed:@"up-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            nswQldTer.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1-yellow.png"],
             [UIImage imageNamed:@"up-arrow-2-yellow.png"], [UIImage imageNamed:@"up-arrow-3-yellow.png"],
             nil];
            nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldTer.imageView startAnimating];
            
        }
        
        
    }
    
    
    
    //    if([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0){
    //        [self.nswQldTer setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        nswQldTer.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
    //         [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
    //         nil];
    //        nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [nswQldTer.imageView startAnimating];
    //    } else {
    //
    //        [self.nswQldTer setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        nswQldTer.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
    //         [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
    //         nil];
    //        nswQldTer.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [nswQldTer.imageView startAnimating];
    //
    //    }
    
    //    [self.view bringSubviewToFront:nswQldTer];
    
    
    
    //    nsw to qld QNI ic
    
    
    //    nsw to qld QNI
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    
    if ([[icFlows.mwFlow objectAtIndex:2] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.nswQldQNI setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.nswQldQNI setTitle:@"=" forState:UIControlStateNormal];
        [self.nswQldQNI setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        nswQldQNI.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        
    }
    
    else if
        
        (
         
         (segTime.selectedSegmentIndex==0)
         
         &&
         
         (
          
          ([[icFlows.mwFlow objectAtIndex:2] floatValue] >= [[icFlows.exportLimit objectAtIndex:2] floatValue]-.01)
          
          ||
          
          ([[icFlows.mwFlow objectAtIndex:2] floatValue] <= [[icFlows.importLimit objectAtIndex:2] floatValue]+.01)
          
          )
         
         
         )
    {
        
        //        set to red
        
        //        NSLog(@"Set QNI to red");
        
        if([[icFlows.mwFlow objectAtIndex:2] floatValue] < 0){
            [self.nswQldQNI setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
            
            nswQldQNI.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
             [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
             nil];
            nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldQNI.imageView startAnimating];
        } else {
            [self.nswQldQNI setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
            
            nswQldQNI.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
             [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
             nil];
            nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldQNI.imageView startAnimating];
        }
        
        
    }
    
    
    
    else {
        
        //        NSLog(@"Set QNI to yellow");
        
        if([[icFlows.mwFlow objectAtIndex:2] floatValue] < 0){
            [self.nswQldQNI setImage:[UIImage imageNamed:@"down-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            nswQldQNI.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1-yellow.png"],
             [UIImage imageNamed:@"down-arrow-2-yellow.png"], [UIImage imageNamed:@"down-arrow-3-yellow.png"],
             nil];
            nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldQNI.imageView startAnimating];
        } else {
            [self.nswQldQNI setImage:[UIImage imageNamed:@"up-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            nswQldQNI.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1-yellow.png"],
             [UIImage imageNamed:@"up-arrow-2-yellow.png"], [UIImage imageNamed:@"up-arrow-3-yellow.png"],
             nil];
            nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [nswQldQNI.imageView startAnimating];
        }
        
        
    }
    
    
    
    
    //    if([[icFlows.mwFlow objectAtIndex:2] floatValue] < 0){
    //        [self.nswQldQNI setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        nswQldQNI.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
    //         [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
    //         nil];
    //        nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [nswQldQNI.imageView startAnimating];
    //    } else {
    //        [self.nswQldQNI setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        nswQldQNI.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
    //         [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
    //         nil];
    //        nswQldQNI.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [nswQldQNI.imageView startAnimating];
    //    }
    
    //    vic to tas bass link ic
    
    
    
    
    
    
    if ([[icFlows.mwFlow objectAtIndex:3] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.vicTasBass setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.vicTasBass setTitle:@"=" forState:UIControlStateNormal];
        [self.vicTasBass setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        vicTasBass.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        
    }
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    else if(
            
            (segTime.selectedSegmentIndex==0)
            
            &&
            
            (
             
             ([[icFlows.mwFlow objectAtIndex:3] floatValue] >= [[icFlows.exportLimit objectAtIndex:3] floatValue]-.01)
             
             ||
             
             ([[icFlows.mwFlow objectAtIndex:3] floatValue] <= [[icFlows.importLimit objectAtIndex:3] floatValue]+.01)
             
             )
            
            
            ){
        
        //        set to red
        
        //        NSLog(@"Set basslink to red");
        
        if([[icFlows.mwFlow objectAtIndex:3] floatValue] < 0){
            [self.vicTasBass setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
            
            vicTasBass.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
             [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
             nil];
            vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicTasBass.imageView startAnimating];
        } else {
            [self.vicTasBass setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
            
            vicTasBass.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
             [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
             nil];
            vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicTasBass.imageView startAnimating];
        }
        
        
    }
    
    
    else {
        
        //        NSLog(@"Set basslink to yellow");
        
        
        if([[icFlows.mwFlow objectAtIndex:3] floatValue] < 0){
            [self.vicTasBass setImage:[UIImage imageNamed:@"down-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            vicTasBass.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1-yellow.png"],
             [UIImage imageNamed:@"down-arrow-2-yellow.png"], [UIImage imageNamed:@"down-arrow-3-yellow.png"],
             nil];
            vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicTasBass.imageView startAnimating];
        } else {
            [self.vicTasBass setImage:[UIImage imageNamed:@"up-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            vicTasBass.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1-yellow.png"],
             [UIImage imageNamed:@"up-arrow-2-yellow.png"], [UIImage imageNamed:@"up-arrow-3-yellow.png"],
             nil];
            vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicTasBass.imageView startAnimating];
        }
        
    }
    
    
    //    if([[icFlows.mwFlow objectAtIndex:3] floatValue] < 0){
    //        [self.vicTasBass setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        vicTasBass.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
    //         [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
    //         nil];
    //        vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [vicTasBass.imageView startAnimating];
    //    } else {
    //        [self.vicTasBass setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        vicTasBass.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
    //         [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
    //         nil];
    //        vicTasBass.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [vicTasBass.imageView startAnimating];
    //    }
    
    //    sa to vic murray ic
    
    
    if ([[icFlows.mwFlow objectAtIndex:4] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.saVicMur setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.saVicMur setTitle:@"||" forState:UIControlStateNormal];
        [self.saVicMur setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        saVicMur.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
    }
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    
    else if(
            
            (segTime.selectedSegmentIndex==0)
            
            &&
            
            (
             
             ([[icFlows.mwFlow objectAtIndex:4] floatValue] >= [[icFlows.exportLimit objectAtIndex:4] floatValue]-.01)
             
             ||
             
             ([[icFlows.mwFlow objectAtIndex:4] floatValue] <= [[icFlows.importLimit objectAtIndex:4] floatValue]+.01)
             
             )
            
            
            ){
        
        //        set to red
        
        //        NSLog(@"Set murraylink to red");
        
        if([[icFlows.mwFlow objectAtIndex:4] floatValue] < 0){
            [self.saVicMur setImage:[UIImage imageNamed:@"right-arrow-1.png"] forState:UIControlStateNormal];
            saVicMur.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1.png"],
             [UIImage imageNamed:@"right-arrow-2.png"], [UIImage imageNamed:@"right-arrow-3.png"],
             nil];
            saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicMur.imageView startAnimating];
        } else {
            [self.saVicMur setImage:[UIImage imageNamed:@"left-arrow-1.png"] forState:UIControlStateNormal];
            
            saVicMur.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1.png"],
             [UIImage imageNamed:@"left-arrow-2.png"], [UIImage imageNamed:@"left-arrow-3.png"],
             nil];
            saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicMur.imageView startAnimating];
        }
        
        
    }
    
    
    else {
        
        //            NSLog(@"Set murraylink to yellow");
        
        
        if([[icFlows.mwFlow objectAtIndex:4] floatValue] < 0){
            [self.saVicMur setImage:[UIImage imageNamed:@"right-arrow-1-yellow.png"] forState:UIControlStateNormal];
            saVicMur.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1-yellow.png"],
             [UIImage imageNamed:@"right-arrow-2-yellow.png"], [UIImage imageNamed:@"right-arrow-3-yellow.png"],
             nil];
            saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicMur.imageView startAnimating];
        } else {
            [self.saVicMur setImage:[UIImage imageNamed:@"left-arrow-1-yellow.png"] forState:UIControlStateNormal];
            
            saVicMur.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1-yellow.png"],
             [UIImage imageNamed:@"left-arrow-2-yellow.png"], [UIImage imageNamed:@"left-arrow-3-yellow.png"],
             nil];
            saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicMur.imageView startAnimating];
        }
    }
    
    
    //    if([[icFlows.mwFlow objectAtIndex:4] floatValue] < 0){
    //        [self.saVicMur setImage:[UIImage imageNamed:@"right-arrow-1.png"] forState:UIControlStateNormal];
    //        saVicMur.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1.png"],
    //         [UIImage imageNamed:@"right-arrow-2.png"], [UIImage imageNamed:@"right-arrow-3.png"],
    //         nil];
    //        saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [saVicMur.imageView startAnimating];
    //    } else {
    //        [self.saVicMur setImage:[UIImage imageNamed:@"left-arrow-1.png"] forState:UIControlStateNormal];
    //
    //        saVicMur.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1.png"],
    //         [UIImage imageNamed:@"left-arrow-2.png"], [UIImage imageNamed:@"left-arrow-3.png"],
    //         nil];
    //        saVicMur.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [saVicMur.imageView startAnimating];
    //    }
    
    //    sa to vic heywood ic
    
    if ([[icFlows.mwFlow objectAtIndex:5] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.saVicHey setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.saVicHey setTitle:@"||" forState:UIControlStateNormal];
        [self.saVicHey setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        saVicHey.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        
    }
    
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    
    else if(
            
            (segTime.selectedSegmentIndex==0)
            
            &&
            
            (
             
             ([[icFlows.mwFlow objectAtIndex:5] floatValue] >= [[icFlows.exportLimit objectAtIndex:5] floatValue]-.01)
             
             ||
             
             ([[icFlows.mwFlow objectAtIndex:5] floatValue] <= [[icFlows.importLimit objectAtIndex:5] floatValue]+.01)
             
             )
            
            
            ){
        
        //        set to red
        
        //        NSLog(@"Set heywood to red");
        
        if([[icFlows.mwFlow objectAtIndex:5] floatValue] < 0){
            [self.saVicHey setImage:[UIImage imageNamed:@"right-arrow-1.png"] forState:UIControlStateNormal];
            saVicHey.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1.png"],
             [UIImage imageNamed:@"right-arrow-2.png"], [UIImage imageNamed:@"right-arrow-3.png"],
             nil];
            saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicHey.imageView startAnimating];
        } else {
            [self.saVicHey setImage:[UIImage imageNamed:@"left-arrow-1.png"] forState:UIControlStateNormal];
            saVicHey.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1.png"],
             [UIImage imageNamed:@"left-arrow-2.png"], [UIImage imageNamed:@"left-arrow-3.png"],
             nil];
            saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicHey.imageView startAnimating];
            
            
        }
        
        
    }
    
    
    else {
        
        //        NSLog(@"Set heywood to yellow");
        
        if([[icFlows.mwFlow objectAtIndex:5] floatValue] < 0){
            [self.saVicHey setImage:[UIImage imageNamed:@"right-arrow-1-yellow.png"] forState:UIControlStateNormal];
            saVicHey.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1-yellow.png"],
             [UIImage imageNamed:@"right-arrow-2-yellow.png"], [UIImage imageNamed:@"right-arrow-3-yellow.png"],
             nil];
            saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicHey.imageView startAnimating];
        } else {
            [self.saVicHey setImage:[UIImage imageNamed:@"left-arrow-1-yellow.png"] forState:UIControlStateNormal];
            saVicHey.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1-yellow.png"],
             [UIImage imageNamed:@"left-arrow-2-yellow.png"], [UIImage imageNamed:@"left-arrow-3-yellow.png"],
             nil];
            saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [saVicHey.imageView startAnimating];
        }
        
        
        
    }
    //
    //
    //    if([[icFlows.mwFlow objectAtIndex:5] floatValue] < 0){
    //        [self.saVicHey setImage:[UIImage imageNamed:@"right-arrow-1.png"] forState:UIControlStateNormal];
    //        saVicHey.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"right-arrow-1.png"],
    //         [UIImage imageNamed:@"right-arrow-2.png"], [UIImage imageNamed:@"right-arrow-3.png"],
    //         nil];
    //        saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [saVicHey.imageView startAnimating];
    //    } else {
    //        [self.saVicHey setImage:[UIImage imageNamed:@"left-arrow-1.png"] forState:UIControlStateNormal];
    //        saVicHey.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"left-arrow-1.png"],
    //         [UIImage imageNamed:@"left-arrow-2.png"], [UIImage imageNamed:@"left-arrow-3.png"],
    //         nil];
    //        saVicHey.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [saVicHey.imageView startAnimating];
    //    }
    
    //    vic to nsw
    
    
    if ([[icFlows.mwFlow objectAtIndex:6] floatValue] == 0){
        
        //        No flow, set to yellow equal symbol
        
        [self.vicNsw setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
        [self.vicNsw setTitle:@"=" forState:UIControlStateNormal];
        [self.vicNsw setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        vicNsw.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        
    }
    
    //    if MWflow is positive then compare to export limit, if flow is negative compare with import limit.
    
    
    else if(
            
            (segTime.selectedSegmentIndex==0)
            
            &&
            
            (
             
             ([[icFlows.mwFlow objectAtIndex:6] floatValue] >= [[icFlows.exportLimit objectAtIndex:6] floatValue]-.01)
             
             ||
             
             ([[icFlows.mwFlow objectAtIndex:6] floatValue] <= [[icFlows.importLimit objectAtIndex:6] floatValue]+.01)
             
             )
            
            
            ){
        
        //        set to red
        
        //        NSLog(@"Set vic-nsw to red");
        
        if([[icFlows.mwFlow objectAtIndex:6] floatValue] < 0){
            [self.vicNsw setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
            vicNsw.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
             [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
             nil];
            vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicNsw.imageView startAnimating];
        } else {
            [self.vicNsw setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
            vicNsw.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
             [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
             nil];
            vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicNsw.imageView startAnimating];
        }
        
        
    }
    
    
    else {
        
        //        NSLog(@"Set vic-nsw to yellow");
        
        
        if([[icFlows.mwFlow objectAtIndex:6] floatValue] < 0){
            [self.vicNsw setImage:[UIImage imageNamed:@"down-arrow-1-yellow.png"] forState:UIControlStateNormal];
            vicNsw.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1-yellow.png"],
             [UIImage imageNamed:@"down-arrow-2-yellow.png"], [UIImage imageNamed:@"down-arrow-3-yellow.png"],
             nil];
            vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicNsw.imageView startAnimating];
        } else {
            [self.vicNsw setImage:[UIImage imageNamed:@"up-arrow-1-yellow.png"] forState:UIControlStateNormal];
            vicNsw.imageView.animationImages =
            [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1-yellow.png"],
             [UIImage imageNamed:@"up-arrow-2-yellow.png"], [UIImage imageNamed:@"up-arrow-3-yellow.png"],
             nil];
            vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
            [vicNsw.imageView startAnimating];
        }
        
        
    }
    
    //    if([[icFlows.mwFlow objectAtIndex:6] floatValue] < 0){
    //        [self.vicNsw setImage:[UIImage imageNamed:@"down-arrow-1.png"] forState:UIControlStateNormal];
    //        vicNsw.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"down-arrow-1.png"],
    //         [UIImage imageNamed:@"down-arrow-2.png"], [UIImage imageNamed:@"down-arrow-3.png"],
    //         nil];
    //        vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [vicNsw.imageView startAnimating];
    //    } else {
    //        [self.vicNsw setImage:[UIImage imageNamed:@"up-arrow-1.png"] forState:UIControlStateNormal];
    //        vicNsw.imageView.animationImages =
    //        [NSArray arrayWithObjects:[UIImage imageNamed:@"up-arrow-1.png"],
    //         [UIImage imageNamed:@"up-arrow-2.png"], [UIImage imageNamed:@"up-arrow-3.png"],
    //         nil];
    //        vicNsw.imageView.animationDuration = speedValue; //whatever you want (in seconds)
    //        [vicNsw.imageView startAnimating];
    //    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
        //        NSLog(@"Version is 6.0 or greater, set atIndex to 1");
        
        gradIndex = 1;
        
    } else {
        //        NSLog(@"Version is less than 6.0, set atIndex to 0");
        
        gradIndex = 0;
        
    }
    
    
    //    set the price stepper value to the current index value 5min history value
    periodStepper.value = [[NSUserDefaults standardUserDefaults] integerForKey:@"IndexValue5minHistory"];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        [periodStepper setTintColor:[UIColor blackColor]];
    } else{
        
        [periodStepper setTintColor:[UIColor colorWithRed:0.00f green:0.25f blue:0.0f alpha:0.05]];}
    
    [periodStepper setIncrementImage:[UIImage imageNamed:@"down_step"] forState:UIControlStateNormal];
    [periodStepper setDecrementImage:[UIImage imageNamed:@"up_step"] forState:UIControlStateNormal];
    
    
    
    NSLog(@"Price stepper value is %f", periodStepper.value);
    
    
    //    UIColor *DarkGreyOp = [UIColor colorWithRed:0.13f green:0.18f blue:0.25f alpha:0.8];
    //    UIColor *LightGreyOp = [UIColor colorWithRed:0.07f green:0.125f blue:0.15f alpha:1.0];
    //
    //    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    //    gradient1.frame = [[headingbut1 layer] bounds];
    //    gradient1.cornerRadius = 8;
    //    gradient1.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        (id)DarkGreyOp.CGColor,
    //                        nil];
    //    gradient1.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.5f],
    //                           [NSNumber numberWithFloat:0.8f],
    //                           nil];
    //
    //    [[headingbut1 layer] insertSublayer:gradient1 atIndex:gradIndex];
    //    [headingbut1 setTitleColor:[UIColor whiteColor] forState: UIControlStateNormal];
    
    headingbut1.layer.cornerRadius = 5;
    headingbut1.layer.borderWidth = 1;
    headingbut1.layer.borderColor = [UIColor blackColor].CGColor;
    
    priceLabel.layer.borderColor = [UIColor greenColor].CGColor;
    
    priceLabel.layer.borderWidth = 1.0;
    
    
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    
    
    if (networkStatus == NotReachable) {
        //        NSLog(@"There IS NO internet connection");
        
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                  message:@"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
        // optional - add more buttons:
        [alertNoInternet show];
        
        
    } else {
        
        
        //    NSLog(@"View loaded");
        
        
        
        if(segTime.selectedSegmentIndex==0){
            
            [self loadPart1_5];
            
            
        }
        
        if(segTime.selectedSegmentIndex==1){
            [self loadPart1_5];
        }
        
        
    }
    
}

-(IBAction)N_Q_MNSP1_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:1] floatValue] < 0){
        flowDir = @"QLD -> NSW";
    } else {
        flowDir = @"NSW -> QLD";
    }
    
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:1] floatValue], [[icFlows.mwLosses objectAtIndex:1] floatValue], [[icFlows.exportLimit objectAtIndex:1] floatValue], [[icFlows.importLimit objectAtIndex:1] floatValue],[icFlows.exportConId objectAtIndex:1],[icFlows.importConId objectAtIndex:1]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:1] floatValue], [[icFlows.mwLosses objectAtIndex:1] floatValue]];
        
    }
    
    UIAlertView *alertN_Q_MNSP1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Terranora Interconnector\n%@",flowDir]
                                   
                                                             message:msgText
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertN_Q_MNSP1 show];
    
}

-(IBAction)NSW_QLD_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:2] floatValue] < 0){
        flowDir = @"QLD -> NSW";
    } else {
        flowDir = @"NSW -> QLD";
    }
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:2] floatValue], [[icFlows.mwLosses objectAtIndex:2] floatValue], [[icFlows.exportLimit objectAtIndex:2] floatValue], [[icFlows.importLimit objectAtIndex:2] floatValue],[icFlows.exportConId objectAtIndex:2],[icFlows.importConId objectAtIndex:2]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:2] floatValue], [[icFlows.mwLosses objectAtIndex:2] floatValue]];
        
    }
    
    UIAlertView *alertNSW_QLD = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"QNI Interconnector\n%@",flowDir]
                                                           message:msgText
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertNSW_QLD show];
    
}


-(IBAction)T_V_MNSP1_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:3] floatValue] < 0){
        flowDir = @"VIC -> TAS";
    } else {
        flowDir = @"TAS -> VIC";
    }
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:3] floatValue], [[icFlows.mwLosses objectAtIndex:3] floatValue], [[icFlows.exportLimit objectAtIndex:3] floatValue], [[icFlows.importLimit objectAtIndex:3] floatValue],[icFlows.exportConId objectAtIndex:3],[icFlows.importConId objectAtIndex:3]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:3] floatValue], [[icFlows.mwLosses objectAtIndex:3] floatValue]];
        
    }
    
    UIAlertView *alertT_V_MNSP1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Basslink Interconnector\n%@",flowDir]
                                                             message:msgText
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertT_V_MNSP1 show];
    
}


-(IBAction)V_S_MNSP1_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:4] floatValue] < 0){
        flowDir = @"SA -> VIC";
    } else {
        flowDir = @"VIC -> SA";
    }
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:4] floatValue], [[icFlows.mwLosses objectAtIndex:4] floatValue], [[icFlows.exportLimit objectAtIndex:4] floatValue], [[icFlows.importLimit objectAtIndex:4] floatValue],[icFlows.exportConId objectAtIndex:4],[icFlows.importConId objectAtIndex:4]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:4] floatValue], [[icFlows.mwLosses objectAtIndex:4] floatValue]];
        
    }
    
    UIAlertView *alertV_S_MNSP1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"MurrayLink Interconnector\n%@",flowDir]
                                                             message:msgText
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertV_S_MNSP1 show];
    
}


-(IBAction)V_SA_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:5] floatValue] < 0){
        flowDir = @"SA -> VIC";
    } else {
        flowDir = @"VIC -> SA";
    }
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:5] floatValue], [[icFlows.mwLosses objectAtIndex:5] floatValue], [[icFlows.exportLimit objectAtIndex:5] floatValue], [[icFlows.importLimit objectAtIndex:5] floatValue],[icFlows.exportConId objectAtIndex:5],[icFlows.importConId objectAtIndex:5]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:5] floatValue], [[icFlows.mwLosses objectAtIndex:5] floatValue]];
        
    }
    
    UIAlertView *alertV_SA = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Heywood Interconnector\n%@",flowDir]
                                                        message:msgText
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertV_SA show];
    
}

-(IBAction)VIC1_NSW1_tapped:(id)sender{
    
    if([[icFlows.mwFlow objectAtIndex:6] floatValue] < 0){
        flowDir = @"NSW -> VIC";
    } else {
        flowDir = @"VIC -> NSW";
    }
    
    //    if 5min tab selected then do this
    if(segTime.selectedSegmentIndex==0){
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW\n\nExpConsID: %@\nImpConsID: %@",[[icFlows.mwFlow objectAtIndex:6] floatValue], [[icFlows.mwLosses objectAtIndex:6] floatValue], [[icFlows.exportLimit objectAtIndex:6] floatValue], [[icFlows.importLimit objectAtIndex:6] floatValue],[icFlows.exportConId objectAtIndex:6],[icFlows.importConId objectAtIndex:6]];
    } else {
        msgText = [NSString stringWithFormat:@"MW Flow: %.2f MW\nMW Losses: %.2f MW",[[icFlows.mwFlow objectAtIndex:6] floatValue], [[icFlows.mwLosses objectAtIndex:6] floatValue]];
        
    }
    
    UIAlertView *alertVIC1_NSW1 = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"VIC-NSW Interconnector\n%@",flowDir]
                                                             message:msgText
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
    
    //    UIAlertView *alertVIC1_NSW1 = [[UIAlertView alloc] initWithTitle:@"VIC-NSW Interconnector"
    //                                                             message:[NSString stringWithFormat:@"Metered Flow: %.2f MW\nMW Flow: %.2f MW\nMW Losses: %.2f MW\nExport Limit: %.2f MW\nImport Limit: %.2f MW",[[icFlows.meterFlow objectAtIndex:6] floatValue],[[icFlows.mwFlow objectAtIndex:6] floatValue], [[icFlows.mwLosses objectAtIndex:6] floatValue], [[icFlows.exportLimit objectAtIndex:6] floatValue], [[icFlows.importLimit objectAtIndex:6] floatValue]]
    //                                                            delegate:nil
    //                                                   cancelButtonTitle:@"OK"
    //                                                   otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [alertVIC1_NSW1 show];
    
}

-(IBAction)refreshData:(id)sender{
    
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
    [self viewDidLoad];
    NSLog(@"Data refresh tapped");
    
    // Do something...
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        });
    //    });
    
    
    
    
}

- (void)viewDidUnload
{
    [self setSegTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    dateLastUpdated=nil; saDemand=nil; saGen=nil; saNetIC=nil; qldDemand=nil; qldGen=nil; qldNetIC=nil; nswDemand=nil; nswGen=nil; nswNetIC=nil; vicDemand=nil; vicGen=nil; vicNetIC=nil; tasDemand=nil; tasGen=nil; tasNetIC=nil; dispPrice=nil; dispRegion=nil; icFlows=nil;  headingbut1=nil; periodStepper=nil;
}


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//
//
//    if ([[segue identifier] isEqualToString:@"toGen"]) {
//
//
//        self.navigationItem.title = @"Back";
//
//    }
//
//
//
//}

- (void) viewWillDisappear:(BOOL)animated
{
    
    
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
    
    //    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //    self.navigationController.navigationBarHidden = YES;
    
    //    add bit for the sliding menu's
    
    //    [self.navigationController setNavigationBarHidden:YES];
    
    // Override point for customization after application launch.
    
    
    UIBarButtonItem* periodButton = [[UIBarButtonItem alloc] initWithTitle:@"5m Period" style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(revealUnderRight:)];
    self.parentViewController.navigationItem.rightBarButtonItem = periodButton;
    periodButton=nil;
    //
    //    self.navigationItem.title = @"5min History";
    
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end

