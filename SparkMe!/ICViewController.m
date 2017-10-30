//
//  ICViewController.m
//  Sparky
//
//  Created by Hung on 12/08/12.
//
//

#import "ICViewController.h"
#import "TFHpple.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "VPDataManager.h"
#import "Utility.h"
#import "DispPrice.h"
#import "DispRegionSum.h"
#import "IcFlows.h"

@interface ICViewController ()

@end

@implementation ICViewController

@synthesize dateLastUpdated, saDemand, saGen, saNetIC, qldDemand, qldGen, qldNetIC, nswDemand, nswGen, nswNetIC, vicDemand, vicGen, vicNetIC, tasDemand, tasGen, tasNetIC, dispPrice, dispRegion, icFlows,  headingbut1, saPrice, vicPrice, qldPrice, nswPrice, tasPrice, priceLabel, segTime, nswQldQNI, nswQldTer, vicTasBass,
saVicHey, saVicMur, vicNsw, terranoraICLine, qniICLine, basslinkICLine, murraylinkICLine, heywoodICLine, vicnswICLine, constraintsBut, historyBut, constraintLabel, historyLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date5minLastUpdate"];
    
    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    //    NSLog(@"Lastest file has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFile]);
    
    
    //    Display current date time
    
    NSDate *dateNow = [NSDate date];
    //    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    //    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    //    NSLog(@"Current time stamp is %@",[dateFormatCur stringFromDate:dateNow]);
    
    
    //    Perform logic check here to compare date of latestest stored file vs. current date
    //    if current date time is < NEM time stamp - 2mins then don't do web call use last stored file
    
    //    if dateLastFile does not exist that means there is no historical stored data file, then force the webcall
    //    also force the web call if DateLastFile is greater than NEM time mins let say 2mins
    
    //    take away 1 mins from time
    
    NSDate *DateLastFileAdj = [DateLastFile dateByAddingTimeInterval:-60*0.05];
    
    //    NSLog(@"Lastest file ADJ has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFileAdj]);
    
    
    if(DateLastFile==NULL || ([DateLastFileAdj compare:dateNow]==NSOrderedAscending))
    {
        //        NSLog(@"Current time is greater than NEM time minus 2mins (ADJ time) - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_5_www];
        
        
    }
    else{
        
        //        NSLog(@"Current time is less than NEM time minus 2mins (ADJ time) - USE LOCAL FILE");
        
        [self loadPart3_5_local];
        [self loadPart4_arrows];
    }
    
    
}

- (void)process5minData2:(NSData *)fetchedData withError:(NSError *)error andSelecetedSegment:(NSInteger)index latestFileName:(NSString *)latestFileName
{
    if (index != segTime.selectedSegmentIndex) {
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }

    
    //    unzipped filename will be same as zip file but with csv extension
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    
    //    location of renamed file for last Stored
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN.CSV"];
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS.zip"];
    NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //copy zip file
    [fetchedData writeToFile:dbPathCacheZip atomically:YES];
    
    //then unzip to folder
    [SSZipArchive unzipFileAtPath:dbPathCacheZip toDestination:zipPath];
    [fileMgr removeItemAtPath:dbPathCacheZip error:nil];
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
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
    dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date5min]];
    
    //  determine where the PRICE rows start at
    for(int i=0; i<[disp5min count]; i++){
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        if([[components1 objectAtIndex:2] isEqualToString:@"PRICE"]){
            priceIndex = i;
            break;
        }
    }
    
    for(NSInteger i=priceIndex; i< priceIndex + 6; i++)
    {
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:9]];
    }
    
    for(NSInteger i=priceIndex + 6; i< priceIndex + 12; i++)
    {
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:9]];
        [dispRegion.disGen addObject: [components objectAtIndex:13]];
        [dispRegion.disLoad addObject: [components objectAtIndex:14]];
        [dispRegion.netInchg addObject: [components objectAtIndex:15]];
    }
    
    for(NSInteger i=priceIndex + 12; i< priceIndex + 19; i++)
    {
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        [icFlows.icID addObject: [components objectAtIndex:6]];
        [icFlows.meterFlow addObject: [components objectAtIndex:9]];
        [icFlows.mwFlow addObject: [components objectAtIndex:10]];
        [icFlows.mwLosses addObject: [components objectAtIndex:11]];
        [icFlows.exportLimit addObject: [components objectAtIndex:15]];
        [icFlows.importLimit addObject: [components objectAtIndex:16]];
        
        [icFlows.exportConId addObject: [components objectAtIndex:18]];
        [icFlows.importConId addObject: [components objectAtIndex:19]];
    }
    
    // Attempt to delete the last stored file DISPATCHIS5MIN.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"last stored CSV file DISPATCHIS5MIN.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:date5min forKey:@"date5minLastUpdate"];
    
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
    
    NSInteger indexSAPrice = [dispPrice.state indexOfObject:@"SA1"];
    if (indexSAPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    
    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    saPrice.layer.borderWidth = 1.0;
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    if (indexVICPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    if (indexNSWPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    if (indexQLDPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    if (indexTASPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    tasPrice.layer.borderWidth = 1.0;
    
    [self loadPart4_arrows];
}


- (void)process5minData:(NSData *)nemDispatch5min withError:(NSError *)error andSelecetedSegment:(NSInteger)index
{
    if (index != segTime.selectedSegmentIndex) {
        return;
    }
    
    if (error) {
        [Utility hideHUDForView:self.view];
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:nemDispatch5min];
    
    NSString *htmlXpathQueryString = @"//html/body/pre/a";
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    
    NSMutableArray *nemFiles = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in htmlNodes) {
        [nemFiles addObject:[[element firstChild] content]];
    }
    
    //    create an NSArray of NSMutableArray of nemFiles
    NSArray *nemFiles5m = [nemFiles copy];
    //    Store the array in NSUserDefaults value for use later in slider views
    [[NSUserDefaults standardUserDefaults] setObject:nemFiles5m forKey:@"nemFiles5mKey"];
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count] - 1];
    
    //    Now fetch the file
    NSString *urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/DispatchIS_Reports/" stringByAppendingString:latestFileName];
    
    //    copy zip file from www
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:urlString withSelectedIndex:segTime.selectedSegmentIndex completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf process5minData2:response withError:error andSelecetedSegment:index latestFileName:latestFileName];
    }];
}

- (void)loadPart3_5_www {
    
    NSString *path = @"http://www.nemweb.com.au/REPORTS/CURRENT/DispatchIS_Reports/";
    NSInteger index = segTime.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:path withSelectedIndex:index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf process5minData:response withError:error andSelecetedSegment:index];
    }];
}


- (void)loadPart3_5_local {
    
    
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN.CSV"];
    
    
    
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
    
    for(NSInteger i=priceIndex; i< priceIndex + 6; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:9]];
        
    }
    
    for(NSInteger i=priceIndex + 6; i< priceIndex + 12; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:9]];
        [dispRegion.disGen addObject: [components objectAtIndex:13]];
        [dispRegion.disLoad addObject: [components objectAtIndex:14]];
        [dispRegion.netInchg addObject: [components objectAtIndex:15]];
        
        
    }
    
    for(NSInteger i=priceIndex + 12; i< priceIndex + 19; i++){
        
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
    if (indexSAPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    saPrice.layer.borderWidth = 1.0;
    
    NSLog(@"pass 3a");
    
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    if (indexVICPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    if (indexNSWPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    if (indexQLDPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    if (indexTASPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    tasPrice.layer.borderWidth = 1.0;
    
    
    
    NSLog(@"pass 3");
    
    NSLog(@"SA region index is %li",(long)indexSAPrice);
    
    NSLog(@"SA Price is %@",indexSAPriceVal);
    
    
    
    [Utility hideHUDForView:self.view];
    
}



- (void)loadPart1_30 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2_30) withObject:nil afterDelay:0];
}

- (void)loadPart2_30 {
    
    
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date30minLastUpdate"];
    
    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    NSLog(@"Lastest file has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFile]);
    
    
    //    Display current date time
    
    NSDate *dateNow = [NSDate date];
    //    NSDateFormatter *dateFormatCur = [[NSDateFormatter alloc] init];
    //    [dateFormatCur setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //    [dateFormatCur setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    NSLog(@"Current time stamp is %@",[dateFormatCur stringFromDate:dateNow]);
    
    
    //    FOR 30 MIN VIEW, NEM TIME IS LAGGING BY CURRENT TIME, IE. NEM PERIOD IS BEHIND...
    
    //    Perform logic check here to compare date of latestest stored file vs. current date
    //    if current date time is < NEM time stamp + 28mins then don't do web call use last stored file
    
    //    if dateLastFile does not exist that means there is no historical stored data file, then force the webcall
    //    also force the web call if DateLastFile is greater than NEM time mins let say 28mins
    
    
    NSDate *DateLastFileAdj = [DateLastFile dateByAddingTimeInterval:60*28];
    
    NSLog(@"Lastest file ADJ has NEM time stamp of %@",[dateFormatCur stringFromDate:DateLastFileAdj]);
    
    
    if(DateLastFile==NULL || ([DateLastFileAdj compare:dateNow]==NSOrderedAscending))
    {
        NSLog(@"Current time is greater than ADJ time - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_30_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than ADJ time - USE LOCAL FILE");
        
        [self loadPart3_30_local];
        [self loadPart4_arrows];
    }
    
}

- (void)process30minData2:(NSData *)fetchedData withError:(NSError *)error andSelecetedSegment:(NSInteger)index latestFileName:(NSString *)latestFileName
{
    if (index != segTime.selectedSegmentIndex) {
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }

    
    //copy zip file from www
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    //unzipped filename will be same as zip file but with csv extension
    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    
    NSLog(@"filname is : %@", fileNameNoExt);
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    
    NSLog(@"CSV filname is : %@", unzippedFileName);
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    
    //    location of renamed file for last Stored
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"TRADINGIS30MIN.CSV"];
    
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"TRADINGIS.zip"];
    //
    NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //copy zip file
    [fetchedData writeToFile:dbPathCacheZip atomically:YES];
    NSLog(@"copy zip file successful from www to cache directory");
    
    //then unzip to folder
    [SSZipArchive unzipFileAtPath:dbPathCacheZip toDestination:zipPath];
    
    NSLog(@"unzipping file successful");
    //delete zip file in cache directory
    
    [fileMgr removeItemAtPath:dbPathCacheZip error:nil];
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *disp30min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
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
    
    //extract NEM time from cell in file
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    NSArray *components = [[disp30min objectAtIndex:2] componentsSeparatedByString:@","];
    [icDateTime addObject:[components objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"date time stamp from file is %@",icDateTimeStripped);
    
    NSString *dateStr = icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date30min = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    NSString *st = [dateFormat stringFromDate:date30min];
    NSLog(@"converted date time stamp from file is %@",st);
    
    dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date30min]];
    
    for(int i = 8; i < 14; i++){
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:8]];
    }
    
    for(int i = 14; i < 20; i++){
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:8]];
        [dispRegion.disGen addObject: [components objectAtIndex:12]];
        [dispRegion.disLoad addObject: [components objectAtIndex:13]];
        [dispRegion.netInchg addObject: [components objectAtIndex:14]];
    }
    
    for(int i = 1; i < 8; i++){
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        [icFlows.icID addObject: [components objectAtIndex:6]];
        [icFlows.meterFlow addObject: [components objectAtIndex:8]];
        [icFlows.mwFlow addObject: [components objectAtIndex:9]];
        [icFlows.mwLosses addObject: [components objectAtIndex:10]];
    }
    
    //    before deleting, move/rename file to DISPATCHIS5MIN.CSV
    //    delete previous existing file
    // Attempt to delete the last stored file TRADINGIS5MIN.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"last stored CSV file TRADINGIS30MIN.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    NSLog(@"unzipped %@ file renamed to TRADINGIS5MIN.CSV", unzippedFileName);
    
    //    now save date stamp of last stored file
    [[NSUserDefaults standardUserDefaults] setObject:date30min forKey:@"date30minLastUpdate"];
    
    //    no need for below section as it wastes resources calling file from online store just to get the date stamp of file plus it's not so accurate as it does not provide NEM time interval
    //    get file date
    
    
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
    
    //    add labels for state/region price
    NSInteger indexSAPrice = [dispPrice.state indexOfObject:@"SA1"];
    if (indexSAPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    saPrice.layer.borderWidth = 1.0;
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    if (indexVICPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    if (indexNSWPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    if (indexQLDPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    if (indexTASPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    tasPrice.layer.borderWidth = 1.0;
    
    NSLog(@"SA region index is %li",(long)indexSAPrice);
    NSLog(@"SA Price is %@",indexSAPriceVal);
    
    [self loadPart4_arrows];
}


- (void)process30minData:(NSData *)nemDispatch5min withError:(NSError *)error andSelecetedSegment:(NSInteger)index
{
    if (index != segTime.selectedSegmentIndex) {
        return;
    }
    
    if (error) {
        [Utility hideHUDForView:self.view];
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
    }
    
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:nemDispatch5min];
    
    NSString *htmlXpathQueryString = @"//html/body/pre/a";
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    
    NSMutableArray *nemFiles = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in htmlNodes){
        [nemFiles addObject:[[element firstChild] content]];
    }
    
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    NSLog(@"Last item in array : %@", latestFileName);
    
    //Now fetch the file
    NSString *urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/TradingIS_Reports/" stringByAppendingString:latestFileName];
    
    
    __weak typeof(self)weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:urlString withSelectedIndex:segTime.selectedSegmentIndex completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf process30minData2:response withError:error andSelecetedSegment:index latestFileName:latestFileName];
    }];
}


-(void) loadPart3_30_www {
    NSString *path = @"http://www.nemweb.com.au/REPORTS/CURRENT/TradingIS_Reports/";
    NSInteger index = segTime.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:path withSelectedIndex:index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf process30minData:response withError:error andSelecetedSegment:index];
    }];
}



-(void) loadPart3_30_local {
    
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"TRADINGIS30MIN.CSV"];
    
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCacheLast encoding:NSUTF8StringEncoding error:nil];
    //
    //    NSLog(@"%@", dataStr);
    
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    trim white space
    
    
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    NSArray *disp30min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    
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
    
    //    extract NEM time from cell in file
    
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    NSArray *components = [[disp30min objectAtIndex:2] componentsSeparatedByString:@","];
    
    //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
    
    [icDateTime addObject:[components objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSLog(@"date time stamp from file is %@",icDateTimeStripped);
    
    NSString *dateStr = icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date30min = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    NSString *st = [dateFormat stringFromDate:date30min];
    NSLog(@"converted date time stamp from file is %@",st);
    
    dateLastUpdated.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:date30min]];
    
    
    for(int i=8; i<14; i++){
        
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispPrice.state addObject:[components objectAtIndex:6]];
        [dispPrice.price addObject:[components objectAtIndex:8]];
        
    }
    
    for(int i=14; i<20; i++){
        
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [dispRegion.state addObject: [components objectAtIndex:6]];
        [dispRegion.totDem addObject: [components objectAtIndex:8]];
        [dispRegion.disGen addObject: [components objectAtIndex:12]];
        [dispRegion.disLoad addObject: [components objectAtIndex:13]];
        [dispRegion.netInchg addObject: [components objectAtIndex:14]];
        
        
    }
    
    for(int i=1; i<8; i++){
        
        NSArray *components = [[disp30min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [regionSumArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        [icFlows.icID addObject: [components objectAtIndex:6]];
        [icFlows.meterFlow addObject: [components objectAtIndex:8]];
        [icFlows.mwFlow addObject: [components objectAtIndex:9]];
        [icFlows.mwLosses addObject: [components objectAtIndex:10]];
        
        //        The below fields do not exist in the 30 min trading files
        
        //        [icFlows.exportLimit addObject: [components objectAtIndex:15]];
        //        [icFlows.importLimit addObject: [components objectAtIndex:16]];
        
        
        
        
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
    
    
    //    add labels for state/region price
    
    NSInteger indexSAPrice = [dispPrice.state indexOfObject:@"SA1"];
    if (indexSAPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexSAPriceVal = [dispPrice.price objectAtIndex:indexSAPrice];
    saPrice.text= [NSString stringWithFormat:@"%.2f",[indexSAPriceVal floatValue]];
    
    saPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    saPrice.layer.borderWidth = 1.0;
    
    
    NSInteger indexVICPrice = [dispPrice.state indexOfObject:@"VIC1"];
    if (indexVICPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexVICPriceVal = [dispPrice.price objectAtIndex:indexVICPrice];
    vicPrice.text= [NSString stringWithFormat:@"%.2f",[indexVICPriceVal floatValue]];
    
    vicPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    vicPrice.layer.borderWidth = 1.0;
    
    NSInteger indexNSWPrice = [dispPrice.state indexOfObject:@"NSW1"];
    if (indexNSWPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexNSWPriceVal = [dispPrice.price objectAtIndex:indexNSWPrice];
    nswPrice.text= [NSString stringWithFormat:@"%.2f",[indexNSWPriceVal floatValue]];
    
    nswPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    nswPrice.layer.borderWidth = 1.0;
    
    NSInteger indexQLDPrice = [dispPrice.state indexOfObject:@"QLD1"];
    if (indexQLDPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }
    NSString *indexQLDPriceVal = [dispPrice.price objectAtIndex:indexQLDPrice];
    qldPrice.text= [NSString stringWithFormat:@"%.2f",[indexQLDPriceVal floatValue]];
    
    qldPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    qldPrice.layer.borderWidth = 1.0;
    
    NSInteger indexTASPrice = [dispPrice.state indexOfObject:@"TAS1"];
    if (indexTASPrice == NSNotFound) {
        [Utility showErrorAlertTitle:nil withMessage:kInsufficientData];
        [Utility hideHUDForView:self.view];
        return;
    }

    NSString *indexTASPriceVal = [dispPrice.price objectAtIndex:indexTASPrice];
    tasPrice.text= [NSString stringWithFormat:@"%.2f",[indexTASPriceVal floatValue]];
    
    tasPrice.layer.borderColor = [UIColor greenColor].CGColor;
    
    tasPrice.layer.borderWidth = 1.0;
    
    
    
    NSLog(@"SA region index is %li",(long)indexSAPrice);
    
    NSLog(@"SA Price is %@",indexSAPriceVal);
    
    
    
    [Utility hideHUDForView:self.view];
    
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
    
    //    set index value for historical 5min view back to 1 for current value
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"IndexValue5minHistory"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didRunBefore"];
    
    //    if price alerts flag is set to 1, then make icon visible, else make it invisible and ensure that push is set to off
    
    
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"PriceAlertFlag"] isEqualToString:@"1"]){
        
        constraintsBut.hidden = NO;
        historyBut.hidden = NO;
        constraintLabel.hidden = NO;
        historyLabel.hidden = NO;
        
        
    } else {
        
        //        hide the icon, and turn off push at urban airship so the user no longer receives notifications although they may still have registered for channels
        
        
        constraintsBut.hidden = YES;
        historyBut.hidden = YES;
        constraintLabel.hidden = YES;
        historyLabel.hidden = YES;
        
    }
    
    
    //    UIColor *DarkGreyOp = [UIColor colorWithRed:0.13f green:0.18f blue:0.45f alpha:0.8];
    //    UIColor *LightGreyOp = [UIColor colorWithRed:0.07f green:0.125f blue:0.35f alpha:1.0];
    
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
    //headingbut1.layer.borderColor = [UIColor colorWithRed:0.0f green:0.4784f blue:1.0f alpha:1].CGColor;
    
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
            [self loadPart1_30];
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

- (void)refreshData{
    [super refreshData];
    [self refreshData:nil];
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
    
    dateLastUpdated=nil; saDemand=nil; saGen=nil; saNetIC=nil; qldDemand=nil; qldGen=nil; qldNetIC=nil; nswDemand=nil; nswGen=nil; nswNetIC=nil; vicDemand=nil; vicGen=nil; vicNetIC=nil; tasDemand=nil; tasGen=nil; tasNetIC=nil; dispPrice=nil; dispRegion=nil; icFlows=nil;  headingbut1=nil;
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
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end

