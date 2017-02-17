//
//  List5mPDViewController.m
//  Sparky
//
//  Created by Hung on 11/07/13.
//
//

#import "List5mPDViewController.h"
#import "SSZipArchive.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import "CustomCell5PD.h"
#import "CustomCell5PD_IC.h"
#import <QuartzCore/QuartzCore.h>
#import "VPDataManager.h"

@interface List5mPDViewController ()

@end

@implementation List5mPDViewController

@synthesize mytableView, dateLastUpdated, headerLabels, segVal;

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
            NSLog(@"Overview tapped");
            [self loadPart1_Overview];
            break;
            
            
            
        case 1:
            
            NSLog(@"IC tapped");
            [self loadPart1_IC];
            break;
            
            
        default:
            break;
            
    }
    
    
}


-(IBAction)refreshData:(id)sender{
    
    NSLog(@"BEGIN reloadData");
    
    [self viewDidLoad];
    
    [self.mytableView setContentOffset:CGPointZero animated:NO];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(segVal.selectedSegmentIndex==0){
        
        //        the overview settings
        
        [self loadPart1_Overview];
        
    } else{
        //        IC view settings
        
        [self loadPart1_IC];
    }
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    dateLastUpdated=nil;
    
    demandArray=nil;
    priceArray=nil;
    timeArray=nil;
    stateArray=nil;
    
    mytableView=nil;
    genArray=nil;
    ichgArray=nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPart1_Overview {
    
    headerLabels.text=@"               Period        Price     Dem.    Gen.   Ichg.";
    
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2_Overview) withObject:nil afterDelay:0];
}

- (void)loadPart2_Overview {
    
    
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date5mPDLastUpdate"];
    
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
        NSLog(@"Current time is greater than NEM time minus 1mins (ADJ time) - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_Over_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than NEM time minus 1mins (ADJ time) - USE LOCAL FILE");
        
        [self loadPart3_Over_local];
    }
    
    
}

- (void)loadPart3_Over_local {
    
    
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5M_PD.CSV"];
    
    
    
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
    
    
    timeArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    priceArray = [[NSMutableArray alloc] init];
    demandArray = [[NSMutableArray alloc] init];
    genArray = [[NSMutableArray alloc] init];
    ichgArray = [[NSMutableArray alloc] init];
    
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
    
    dateLastUpdated.text = [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:date5min]];
    
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"REGIONSOLUTION"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    //NSLog(@"The value of the price row is %i", priceIndex);
    
    
    for(long i=priceIndex+1; i< priceIndex + 61; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        NSString *timeStr =[NSString stringWithFormat:@"%@", [components objectAtIndex:5]];
        
        
        [timeArray addObject:[timeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [stateArray addObject:[[components objectAtIndex:6] stringByReplacingOccurrencesOfString:@"1" withString:@""]];
        [priceArray addObject:[components objectAtIndex:7]];
        [demandArray addObject:[components objectAtIndex:26]];
        [genArray addObject:[components objectAtIndex:30]];
        [ichgArray addObject:[components objectAtIndex:32]];
        
    }
    //
    //    NSLog(@"time dataset returned is %@",timeArray);
    //    NSLog(@"state dataset returned is %@",stateArray);
    //        NSLog(@"price dataset returned is %@",priceArray);
    //        NSLog(@"demand dataset returned is %@",demandArray);
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
    [mytableView reloadData];
    
    
}

- (void)processOveriewData2:(NSData *)fetchedData withError:(NSError *)error andSelecetedSegment:(NSInteger)index latestFileName:(NSString *)latestFileName
{
    if (index != segVal.selectedSegmentIndex) {
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //    copy zip file from www
    //    unzipped filename will be same as zip file but with csv extension
    
    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    
    //    NSLog(@"filname is : %@", fileNameNoExt);
    
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    
    //    NSLog(@"CSV filname is : %@", unzippedFileName);
    
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5M_PD.CSV"];
    
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS_PD.zip"];
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
    
    
    timeArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    priceArray = [[NSMutableArray alloc] init];
    demandArray = [[NSMutableArray alloc] init];
    genArray = [[NSMutableArray alloc] init];
    ichgArray = [[NSMutableArray alloc] init];
    
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
    
    dateLastUpdated.text = [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:date5min]];
    
    [[NSUserDefaults standardUserDefaults] setObject:date5min forKey:@"date5mPDLastUpdate"];
    
    
    dtF=nil;
    dateFormat=nil;
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"REGIONSOLUTION"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    //NSLog(@"The value of the price row is %i", priceIndex);
    
    
    for(long i=priceIndex+1; i< priceIndex + 61; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        NSString *timeStr =[NSString stringWithFormat:@"%@", [components objectAtIndex:5]];
        
        
        [timeArray addObject:[timeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [stateArray addObject:[[components objectAtIndex:6] stringByReplacingOccurrencesOfString:@"1" withString:@""]];
        [priceArray addObject:[components objectAtIndex:7]];
        [demandArray addObject:[components objectAtIndex:26]];
        [genArray addObject:[components objectAtIndex:30]];
        [ichgArray addObject:[components objectAtIndex:32]];
        
    }
    //
    //    NSLog(@"time dataset returned is %@",timeArray);
    //    NSLog(@"state dataset returned is %@",stateArray);
    //        NSLog(@"price dataset returned is %@",priceArray);
    //        NSLog(@"demand dataset returned is %@",demandArray);
    
    //    delete previous existing file
    
    // Attempt to delete the last stored file DISPATCH_SCADA.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"last stored CSV file DISPATCH_SCADA.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    [mytableView reloadData];
}

- (void)processOveriewData:(NSData *)nemDispatch5min withError:(NSError *)error index:(NSInteger)index
{
    if (index != segVal.selectedSegmentIndex) {
        return;
    }
    
    if (error || !nemDispatch5min) {
        [Utility hideHUDForView:self.view];
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    // 2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:nemDispatch5min];
    
    // 3
    NSString *htmlXpathQueryString = @"//html/body/pre/a";
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    
    // 4
    NSMutableArray *nemFiles = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in htmlNodes) {
        // 5
        
        [nemFiles addObject:[[element firstChild] content]];
        
        
        // 7
        //        tutorial.url = [element objectForKey:@"href"];
    }
    
    //    NSLog(@"%@",nemFiles);
    //
    //    NSLog(@"Items in file list array : %i", [nemFiles count]);
    
    
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    
    //    NSLog(@"Last item in array : %@", latestFileName);
    
    //    Now fetch the file
    
    
    NSString *urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/P5_Reports/" stringByAppendingString:latestFileName];
    
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:urlString withSelectedIndex:index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf processOveriewData2:response withError:error andSelecetedSegment:index latestFileName:latestFileName];
    }];
}

- (void)loadPart3_Over_www {
    
    NSString *path = @"http://www.nemweb.com.au/REPORTS/CURRENT/P5_Reports/";
    NSInteger active_index = segVal.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:path withSelectedIndex:active_index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf processOveriewData:response withError:error index:index];
    }];
}


//=======================

- (void)loadPart1_IC {
    
    headerLabels.text=@"              Period    Imp. Limit  MW Flow  Exp. Limit";
    
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2_IC) withObject:nil afterDelay:0];
}

- (void)loadPart2_IC {
    
    
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date5mPDLastUpdate"];
    
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
        NSLog(@"Current time is greater than NEM time minus 1mins (ADJ time) - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart3_IC_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than NEM time minus 1mins (ADJ time) - USE LOCAL FILE");
        
        [self loadPart3_IC_local];
    }
    
    
}

- (void)loadPart3_IC_local {
    
    
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5M_PD.CSV"];
    
    
    
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
    
    
    timeArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    
    mwFlowArray = [[NSMutableArray alloc] init];
    //    mwLossesArray = [[NSMutableArray alloc] init];
    exportLimitArray = [[NSMutableArray alloc] init];
    importLimitArray = [[NSMutableArray alloc] init];
    
    //    EXPORTGENCONID_Array = [[NSMutableArray alloc] init];
    //    IMPORTGENCONID_Array = [[NSMutableArray alloc] init];
    
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
    
    dateLastUpdated.text = [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:date5min]];
    
    [[NSUserDefaults standardUserDefaults] setObject:date5min forKey:@"date5mPDLastUpdate"];
    
    
    dtF=nil;
    dateFormat=nil;
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"INTERCONNECTORSOLN"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    //NSLog(@"The value of the price row is %i", priceIndex);
    
    
    for(long i=priceIndex+1; i< priceIndex + 73; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        NSString *timeStr =[NSString stringWithFormat:@"%@", [components objectAtIndex:6]];
        
        
        [timeArray addObject:[timeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [stateArray addObject:[[components objectAtIndex:5] stringByReplacingOccurrencesOfString:@"1" withString:@""]];
        
        
        [mwFlowArray addObject:[components objectAtIndex:8]];
        //        [mwLossesArray addObject:[components objectAtIndex:9]];
        
        [exportLimitArray addObject:[components objectAtIndex:13]];
        [importLimitArray addObject:[components objectAtIndex:14]];
        //        [EXPORTGENCONID_Array addObject:[components objectAtIndex:16]];
        //        [IMPORTGENCONID_Array addObject:[components objectAtIndex:17]];
        
        
        //        [priceArray addObject:[components objectAtIndex:7]];
        //        [demandArray addObject:[components objectAtIndex:26]];
        //        [genArray addObject:[components objectAtIndex:30]];
        //        [ichgArray addObject:[components objectAtIndex:32]];
        
    }    //
    
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
    [mytableView reloadData];
    
    
}

- (void)processICData2:(NSData *)fetchedData withError:(NSError *)error andSelecetedSegment:(NSInteger)index latestFileName:(NSString *)latestFileName
{
    if (index != segVal.selectedSegmentIndex) {
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //    copy zip file from www
    //    unzipped filename will be same as zip file but with csv extension
    
    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    
    //    NSLog(@"filname is : %@", fileNameNoExt);
    
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    
    //    NSLog(@"CSV filname is : %@", unzippedFileName);
    
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5M_PD.CSV"];
    
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS_PD.zip"];
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
    
    
    timeArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    
    mwFlowArray = [[NSMutableArray alloc] init];
    //    mwLossesArray = [[NSMutableArray alloc] init];
    exportLimitArray = [[NSMutableArray alloc] init];
    importLimitArray = [[NSMutableArray alloc] init];
    
    //    EXPORTGENCONID_Array = [[NSMutableArray alloc] init];
    //    IMPORTGENCONID_Array = [[NSMutableArray alloc] init];
    
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
    
    dateLastUpdated.text = [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:date5min]];
    
    [[NSUserDefaults standardUserDefaults] setObject:date5min forKey:@"date5mPDLastUpdate"];
    
    
    dtF=nil;
    dateFormat=nil;
    
    
    //  determine where the PRICE rows start at
    
    
    for(int i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"INTERCONNECTORSOLN"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    //NSLog(@"The value of the price row is %i", priceIndex);
    
    
    for(long i=priceIndex+1; i< priceIndex + 73; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        NSString *timeStr =[NSString stringWithFormat:@"%@", [components objectAtIndex:6]];
        
        
        [timeArray addObject:[timeStr stringByReplacingOccurrencesOfString:@"\"" withString:@""]];
        [stateArray addObject:[[components objectAtIndex:5] stringByReplacingOccurrencesOfString:@"1" withString:@""]];
        
        
        [mwFlowArray addObject:[components objectAtIndex:8]];
        //        [mwLossesArray addObject:[components objectAtIndex:9]];
        
        [exportLimitArray addObject:[components objectAtIndex:13]];
        [importLimitArray addObject:[components objectAtIndex:14]];
        //        [EXPORTGENCONID_Array addObject:[components objectAtIndex:16]];
        //        [IMPORTGENCONID_Array addObject:[components objectAtIndex:17]];
        
        
        //        [priceArray addObject:[components objectAtIndex:7]];
        //        [demandArray addObject:[components objectAtIndex:26]];
        //        [genArray addObject:[components objectAtIndex:30]];
        //        [ichgArray addObject:[components objectAtIndex:32]];
        
    }
    //
    //    NSLog(@"time dataset returned is %@",timeArray);
    //    NSLog(@"state dataset returned is %@",stateArray);
    //        NSLog(@"price dataset returned is %@",priceArray);
    //        NSLog(@"demand dataset returned is %@",demandArray);
    
    //    delete previous existing file
    
    // Attempt to delete the last stored file DISPATCH_SCADA.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"last stored CSV file DISPATCH_SCADA.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    [mytableView reloadData];
}

- (void)processICData:(NSData *)nemDispatch5min withError:(NSError *)error index:(NSInteger)index
{
    if (index != segVal.selectedSegmentIndex) {
        return;
    }
    
    if (error) {
        [Utility hideHUDForView:self.view];
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    
    // 2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:nemDispatch5min];
    
    // 3
    NSString *htmlXpathQueryString = @"//html/body/pre/a";
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    
    // 4
    NSMutableArray *nemFiles = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in htmlNodes) {
        // 5
        
        [nemFiles addObject:[[element firstChild] content]];
        
        
        // 7
        //        tutorial.url = [element objectForKey:@"href"];
    }
    
    //    NSLog(@"%@",nemFiles);
    //
    //    NSLog(@"Items in file list array : %i", [nemFiles count]);
    
    
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    
    //    NSLog(@"Last item in array : %@", latestFileName);
    
    //    Now fetch the file
    
    
    __weak typeof(self) weakSelf =  self;
    NSString *urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/P5_Reports/" stringByAppendingString:latestFileName];
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:urlString withSelectedIndex:index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf processICData2:response withError:error andSelecetedSegment:index latestFileName:latestFileName];
    }];
}

- (void)loadPart3_IC_www {
    
    NSString *path = @"http://www.nemweb.com.au/REPORTS/CURRENT/P5_Reports/";
    NSInteger active_index = segVal.selectedSegmentIndex;
    __weak typeof(self) weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:path withSelectedIndex:active_index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf processICData:response withError:error index:index];
    }];
}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    
    
    if(segVal.selectedSegmentIndex==0){
        
        //        the overview settings
        
        return 5;
        
    } else{
        //        IC view settings
        
        return 6;
    }
    
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    both views have 12 x 5min time periods
    
    return 12;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    
    if(segVal.selectedSegmentIndex==0){
        
        //        the overview settings
        
        if(section == 0){
            return [stateArray objectAtIndex:0];
        }
        if(section == 1){
            return [stateArray objectAtIndex:12];
        }
        if(section == 2){
            return [stateArray objectAtIndex:24];
        }
        if(section == 3){
            return [stateArray objectAtIndex:36];
        }
        if(section == 4){
            return [stateArray objectAtIndex:48];
        }else return @"";
        
    } else{
        //        IC view settings
        
        if(section == 0){
            return [stateArray objectAtIndex:0];
        }
        if(section == 1){
            return [stateArray objectAtIndex:12];
        }
        if(section == 2){
            return [stateArray objectAtIndex:24];
        }
        if(section == 3){
            return [stateArray objectAtIndex:36];
        }
        if(section == 4){
            return [stateArray objectAtIndex:48];
        }
        if(section == 5){
            return [stateArray objectAtIndex:60];
        }else return @"";
    }
    
    
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    // Return the number of rows in the section.
//    return [timeArray count];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(segVal.selectedSegmentIndex==0){
        
        static NSString *CellIdentifier = @"CustomCell5PD";
        CustomCell5PD *cell = (CustomCell5PD *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"CustomCell5PD" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell = (CustomCell5PD *) currentObject;
                    break;
                }
            }
        }
        
        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
        //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatTrim setDateFormat:@"HH:mm"];
        
        NSString *dateStrNEM = [timeArray objectAtIndex:indexPath.row];
        NSDate *dTrim = [dtF dateFromString:dateStrNEM];
        cell.dateLabel.text=[dateFormatTrim stringFromDate:dTrim];
        
        if(indexPath.row==0){
            cell.stateLabel.text=@"TRADE";
            //cell.stateLabel.textColor = [UIColor whiteColor];
            
        } else {
            cell.stateLabel.text=@"  PD";
        }
        
        switch (indexPath.section) {
                // I would like these in Section One
            case 0:
                
                //            cell.stateLabel.text=[stateArray objectAtIndex:indexPath.row];
                cell.demandLabel.text=[NSString stringWithFormat:@"%.0f", [[demandArray objectAtIndex:indexPath.row] floatValue]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row] floatValue]];
                cell.genLabel.text=[NSString stringWithFormat:@"%.0f", [[genArray objectAtIndex:indexPath.row] floatValue]];
                cell.ichgLabel.text=[NSString stringWithFormat:@"%.0f", [[ichgArray objectAtIndex:indexPath.row] floatValue]];
                
                
                break;
            case 1:
                
                cell.demandLabel.text=[NSString stringWithFormat:@"%.0f", [[demandArray objectAtIndex:indexPath.row+12] floatValue]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row+12] floatValue]];
                cell.genLabel.text=[NSString stringWithFormat:@"%.0f", [[genArray objectAtIndex:indexPath.row+12] floatValue]];
                cell.ichgLabel.text=[NSString stringWithFormat:@"%.0f", [[ichgArray objectAtIndex:indexPath.row+12] floatValue]];
                break;
                // And these in Section Two
            case 2:
                
                cell.demandLabel.text=[NSString stringWithFormat:@"%.0f", [[demandArray objectAtIndex:indexPath.row+24] floatValue]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row+24] floatValue]];
                cell.genLabel.text=[NSString stringWithFormat:@"%.0f", [[genArray objectAtIndex:indexPath.row+24] floatValue]];
                cell.ichgLabel.text=[NSString stringWithFormat:@"%.0f", [[ichgArray objectAtIndex:indexPath.row+24] floatValue]];
                
                break;
            case 3:
                
                cell.demandLabel.text=[NSString stringWithFormat:@"%.0f", [[demandArray objectAtIndex:indexPath.row+36] floatValue]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row+36] floatValue]];
                cell.genLabel.text=[NSString stringWithFormat:@"%.0f", [[genArray objectAtIndex:indexPath.row+36] floatValue]];
                cell.ichgLabel.text=[NSString stringWithFormat:@"%.0f", [[ichgArray objectAtIndex:indexPath.row+36] floatValue]];
                break;
            case 4:
                
                cell.demandLabel.text=[NSString stringWithFormat:@"%.0f", [[demandArray objectAtIndex:indexPath.row+48] floatValue]];
                cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row+48] floatValue]];
                cell.genLabel.text=[NSString stringWithFormat:@"%.0f", [[genArray objectAtIndex:indexPath.row+48] floatValue]];
                cell.ichgLabel.text=[NSString stringWithFormat:@"%.0f", [[ichgArray objectAtIndex:indexPath.row+48] floatValue]];
                break;
            default:
                break;
        }
        
        //    cell.dateLabel.text=[dateFormatTrim stringFromDate:dTrim];
        //    cell.stateLabel.text=[stateArray objectAtIndex:indexPath.row];
        //    cell.demandLabel.text=[NSString stringWithFormat:@"%.2f", [[demandArray objectAtIndex:indexPath.row] floatValue]];
        //    cell.priceLabel.text=[NSString stringWithFormat:@"%.2f", [[priceArray objectAtIndex:indexPath.row] floatValue]];
        
        
        
        return cell;
        
        
    } else{
        //        IC view settings
        static NSString *CellIdentifier = @"CustomCell5PD_IC";
        CustomCell5PD_IC *cell = (CustomCell5PD_IC *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"CustomCell5PD_IC" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects){
                if ([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell = (CustomCell5PD_IC *) currentObject;
                    break;
                }
            }
        }
        
        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
        //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
        [dateFormatTrim setDateFormat:@"HH:mm"];
        
        NSString *dateStrNEM = [timeArray objectAtIndex:indexPath.row];
        NSDate *dTrim = [dtF dateFromString:dateStrNEM];
        cell.dateLabel.text=[dateFormatTrim stringFromDate:dTrim];
        
        if(indexPath.row==0){
            cell.stateLabel.text=@"TRADE";
            //cell.stateLabel.textColor = [UIColor whiteColor];
            
        } else {
            cell.stateLabel.text=@"  PD";
        }
        
        
        switch (indexPath.section) {
                // I would like these in Section One
                
                
                
            case 0:
                
                //            cell.stateLabel.text=[stateArray objectAtIndex:indexPath.row];
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row] floatValue]];
                
                break;
            case 1:
                
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row+12] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row+12] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row+12] floatValue]];
                break;
                // And these in Section Two
            case 2:
                
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row+24] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row+24] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row+24] floatValue]];
                
                break;
            case 3:
                
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row+36] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row+36] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row+36] floatValue]];
                break;
            case 4:
                
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row+48] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row+48] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row+48] floatValue]];
                break;
            case 5:
                
                cell.mwFlowLabel.text=[NSString stringWithFormat:@"%.2f", [[mwFlowArray objectAtIndex:indexPath.row+60] floatValue]];
                
                cell.exportLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[exportLimitArray objectAtIndex:indexPath.row+60] floatValue]];
                cell.importLimitLabel.text=[NSString stringWithFormat:@"%.2f", [[importLimitArray objectAtIndex:indexPath.row+60] floatValue]];
                break;
                
            default:
                break;
        }
        
        
        return cell;
        
    }
    
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell5PD *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        //        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {[cell setBackgroundColor:[UIColor clearColor]];
        //        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    //    if (indexPath.row == 0 || indexPath.row == 12 ||indexPath.row == 24 || indexPath.row == 36 || indexPath.row == 48){
    //        [cell setBackgroundColor:[UIColor greenColor]];
    //    }
    
    //    switch (indexPath.section) {
    //            // I would like these in Section One
    //        case 0:
    //            if([[ichgArray objectAtIndex:indexPath.row] floatValue] < 0){
    //                cell.ichgLabel.textColor = [UIColor redColor];
    //
    //            }
    //
    //            break;
    //        case 1:
    //            if([[ichgArray objectAtIndex:indexPath.row+12] floatValue] < 0){
    //                cell.ichgLabel.textColor = [UIColor redColor];
    //
    //            }
    //            break;
    //            // And these in Section Two
    //        case 2:
    //            if([[ichgArray objectAtIndex:indexPath.row+24] floatValue] < 0){
    //                cell.ichgLabel.textColor = [UIColor redColor];
    //
    //            }
    //
    //            break;
    //        case 3:
    //            if([[ichgArray objectAtIndex:indexPath.row+36] floatValue] < 0){
    //                cell.ichgLabel.textColor = [UIColor redColor];
    //
    //            }
    //            break;
    //        case 4:
    //            if([[ichgArray objectAtIndex:indexPath.row+48] floatValue] < 0){
    //                cell.ichgLabel.textColor = [UIColor redColor];
    //
    //            }
    //            break;
    //        default:
    //            break;
    //    }
    
    if (indexPath.row == 0 ){
        [cell setBackgroundColor:[UIColor colorWithRed:0.16 green:0.56 blue:0.76 alpha:1]];
               // cell.dateLabel.textColor = [UIColor whiteColor];
                //cell.stateLabel.textColor = [UIColor whiteColor];
                //cell.demandLabel.textColor = [UIColor whiteColor];
                //cell.priceLabel.textColor = [UIColor whiteColor];
                //cell.genLabel.textColor = [UIColor whiteColor];
                //cell.ichgLabel.textColor = [UIColor whiteColor];
    
    
    }
    
   // cell.textColor= [UIColor whiteColor];
    
    
    //        //        [cell setBackgroundColor:[UIColor blueColor]];
            //cell.dateLabel.textColor = [UIColor whiteColor];
    //        cell.stateLabel.textColor = [UIColor whiteColor];
    //        cell.demandLabel.textColor = [UIColor whiteColor];
    //        cell.priceLabel.textColor = [UIColor whiteColor];
    //        cell.genLabel.textColor = [UIColor whiteColor];
    //        cell.ichgLabel.textColor = [UIColor whiteColor];
    //    }
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Get the object from the array.
    //	Permits *coffeeObj = [appDelegate.coffeeArray objectAtIndex:indexPath.row];
    
    //Set the coffename.
    
    //
    //    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:13.0];
    //    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    //    CGSize labelSize = [@"test" sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeTailTruncation];
    //    
    //    return labelSize.height + 5;
    
    if(segVal.selectedSegmentIndex==0){
        
        //        the overview settings
        
        return 21;
        
    } else{
        //        IC view settings
        
        return 21;
    }
    
    
    
}
-(BOOL) shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
    //OR return (UIInterfaceOrientationMaskAll);
}


@end

