//
//  GenDispGrpViewController.m
//  Sparky
//
//  Created by Hung on 22/08/12.
//
//

#import "GenDispGrpViewController.h"
#import "TFHpple.h"

#import "SSZipArchive.h"
#import "MBProgressHUD.h"

#import "URBSegmentedControl.h"
#import "VPDataManager.h"
#import "Utility.h"

@interface GenDispGrpViewController ()

@end

@implementation GenDispGrpViewController

@synthesize duidArray, scadaArray, descArray, tableview1, ownerArray, fuelArray, techTypeArray, regCapArray, maxCapArray, stateArray, primTechTypeArray, dateLastUpdated, segSortType, alphabetIndexArray, zeroSwitch, segGenFilter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (IBAction)zeroTap:(id)sender{
    
    [self viewDidLoad];
    [self.tableview1 setContentOffset:CGPointZero animated:NO];
}

- (IBAction)segmentGenFilterTap:(UISegmentedControl *)sender{
    
    //    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            
            NSLog(@"All tapped");
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            
            break;
            
            
        case 1:
            
            NSLog(@"My Port tapped");
            //            set duid filter
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            break;
            
        case 2:
            
            NSLog(@"Wind tapped");
            //            set fuel type wind filter
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            break;
            
        case 3:
            
            NSLog(@"Hydro tapped");
            //            set fuel type hydro filter
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            break;
            
        default:
            break;
            
    }
    
    
}

- (IBAction)segmentSortTypeTap:(UISegmentedControl *)sender{
    
    //    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            
            NSLog(@"DUID tapped");
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            
            break;
            
            
        case 1:
            
            NSLog(@"Owner tapped");
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            break;
            
        case 2:
            
            NSLog(@"State tapped");
            [self viewDidLoad];
            [self.tableview1 setContentOffset:CGPointZero animated:NO];
            break;
            
        default:
            break;
            
    }
    
    
}

- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}

- (void)loadPart2 {
    
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date5minLastUpdateGen"];
    
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
        
        [self loadPart3_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than NEM time minus 1mins (ADJ time) - USE LOCAL FILE");
        
        [self loadPart3_local];
    }
    
    [self.tableview1 setContentOffset:CGPointZero animated:NO];
    
}

- (NSInteger)indexForWebCall
{
    if (segGenFilter.selectedSegmentIndex == 0)
    {
        if (segSortType.selectedSegmentIndex == 0)
        {
            return 0;
        }
        else if (segSortType.selectedSegmentIndex == 1)
        {
            return 1;
        }
        else
        {
            return 2;
        }
    }
    else if (segGenFilter.selectedSegmentIndex == 1)
    {
        if (segSortType.selectedSegmentIndex == 0)
        {
            return 3;
        }
        else if (segSortType.selectedSegmentIndex == 1)
        {
            return 4;
        }
        else
        {
            return 5;
        }
    }
    else if (segGenFilter.selectedSegmentIndex == 2)
    {
        if (segSortType.selectedSegmentIndex == 0)
        {
            return 6;
        }
        else if (segSortType.selectedSegmentIndex == 1)
        {
            return 7;
        }
        else
        {
            return 8;
        }
    }
    else
    {
        if (segSortType.selectedSegmentIndex == 0)
        {
            return 9;
        }
        else if (segSortType.selectedSegmentIndex == 1)
        {
            return 10;
        }
        else
        {
            return 11;
        }
    }
        
}

- (void)process5minData2:(NSData *)fetchedData withError:(NSError *)error andSelecetedSegment:(NSInteger)index latestFileName:(NSString *)latestFileName
{
    if (index != [self indexForWebCall]) {
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];

    //    unzipped filename will be same as zip file but with csv extension
    NSString *fileNameNoExt = [latestFileName substringToIndex:[latestFileName length] - 4];
    NSString *unzippedFileName = [fileNameNoExt stringByAppendingString:@".CSV"];
    NSString *dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:unzippedFileName];
    //    Generator reference lookup file
    NSString *dbPathRes = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"Generators.csv"];
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCH_SCADA.CSV"];
    NSString *dbPathCacheZip = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHSCADA.zip"];
    NSString *zipPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    //copy zip file
    [fetchedData writeToFile:dbPathCacheZip atomically:YES];
    
    //then unzip to folder
    [SSZipArchive unzipFileAtPath:dbPathCacheZip toDestination:zipPath];
    
    //delete zip file in cache directory
    [fileMgr removeItemAtPath:dbPathCacheZip error:nil];
    
    //    generation info
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //    generation config
    NSString *dataGenStr = [NSString stringWithContentsOfFile:dbPathRes encoding:NSUTF8StringEncoding error:nil];
    NSString *dataGenStrStripped2 = [dataGenStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *genInfoArray = [dataGenStrStripped2 componentsSeparatedByString:@"\n"];
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    duidArray = [[NSMutableArray alloc] init];
    scadaArray = [[NSMutableArray alloc] init];
    descArray = [[NSMutableArray alloc] init];
    ownerArray = [[NSMutableArray alloc] init];
    fuelArray = [[NSMutableArray alloc] init];
    techTypeArray = [[NSMutableArray alloc] init];
    regCapArray = [[NSMutableArray alloc] init];
    maxCapArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    primTechTypeArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *windDuidArray =[[NSMutableArray alloc] init];
    NSMutableArray *hydroDuidArray =[[NSMutableArray alloc] init];
    
    NSMutableArray *duidGenArray =[[NSMutableArray alloc] init];
    NSMutableArray *descGenArray =[[NSMutableArray alloc] init];
    
    NSMutableArray *ownerGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *fuelGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *techTypeGenArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *regCapGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *maxCapGenArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *stateGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *primeTechGenArray = [[NSMutableArray alloc] init];
    
    for(int y=1; y<[genInfoArray count]; y++){
        // split generator array into component columns
        NSArray *genComponents = [[genInfoArray objectAtIndex:y] componentsSeparatedByString:@","];
        
        
        // get array of duid numbers
        [duidGenArray addObject:[genComponents objectAtIndex:10]];
        // get array of gen descriptions
        [descGenArray addObject:[genComponents objectAtIndex:1]];
        // get array of gen owner
        [ownerGenArray addObject:[genComponents objectAtIndex:0]];
        // get array of fuel type owner
        [fuelGenArray addObject:[genComponents objectAtIndex:6]];
        // get array of technology type owner
        [techTypeGenArray addObject:[genComponents objectAtIndex:9]];
        // get array of technology type owner
        [regCapGenArray addObject:[genComponents objectAtIndex:11]];
        // get array of technology type owner
        [maxCapGenArray addObject:[genComponents objectAtIndex:12]];
        // get state
        [stateGenArray addObject:[genComponents objectAtIndex:2]];
        // get array of primary technology type owner
        [primeTechGenArray addObject:[genComponents objectAtIndex:8]];
        
        if ([[genComponents objectAtIndex:6] isEqualToString:@"Wind"]){
            //            create array that contains list of wind DUID's
            [windDuidArray addObject:[genComponents objectAtIndex:10]];
        }
        
        if ([[genComponents objectAtIndex:6] isEqualToString:@"Hydro"]){
            //            create array that contains list of wind DUID's
            [hydroDuidArray addObject:[genComponents objectAtIndex:10]];
        }
    }
    
    //    this section grabs the NEM time interval from the file
    NSArray *dateArray = [[disp5min objectAtIndex:2] componentsSeparatedByString:@","];
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    [icDateTime addObject:[dateArray objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    //        awesome, convert date formats! wow, cool bit of code
    
    NSString *dateStr =  icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *d = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    //    NSString *st = [dateFormat stringFromDate:d];
    //    NSLog(@"%@",st);
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:d]];
    
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"date5minLastUpdateGen"];
    
    
    dtF=nil;
    dateFormat=nil;
    
    
    //    create array that binds genduid and genvalue for sorting
    
    NSMutableArray *duidScadaCombo = [[NSMutableArray alloc] init];
    
    
    //    dateLastUpdated.text = [NSString stringWithFormat:@"Updated: %@, %@",[dateArray objectAtIndex:5],[dateArray objectAtIndex:6]];
    
    for(int i=2; i<[disp5min count]-2; i++){
        
        NSArray *combArray = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        
        [duidScadaCombo addObject:[NSString stringWithFormat:@"%@,%@", [combArray objectAtIndex:5],[combArray objectAtIndex:6]]];
    }
    
    //    now sort duidscadacomob array
    
    //    NSArray *sortedArray = [duidScadaCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    ////    for (NSString *str in sortedArray) {
    ////        NSLog(@"string %@ ",str);
    ////    }
    //    NSLog(@"sortedarrayelements %d",[sortedArray count]);
    
    
    NSMutableArray *duidArrayTemp =[[NSMutableArray alloc] init];
    NSMutableArray *scadaArrayTemp =[[NSMutableArray alloc] init];
    NSMutableArray *descArrayTemp =[[NSMutableArray alloc] init];
    
    NSMutableArray *ownerArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *fuelArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *techTypeArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *regCapArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *maxCapArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *stateArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *primeTechTypeArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *sortPreCombo = [[NSMutableArray alloc] init];
    
    NSArray *sortedPreComboArray = [[NSArray alloc] init];
    
    //    sample of user portfolio
    
    NSArray *myUnitList = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUnitsArray"];
    
    //    NSArray *energyAustList = [NSArray arrayWithObjects:@"AGLHAL", @"MP1", @"MP2", @"TALWA1",@"WATERLWF",@"WW7",@"WW8",@"YWPS1",@"YWPS2",@"YWPS3",@"YWPS4", nil];
    
    for(int i=0; i<[duidScadaCombo count]; i++){
        
        NSArray *components = [[duidScadaCombo objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithForma   t:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        //        exclude idle generators
        
        //        if select to filter by wind units only
        
        if(segGenFilter.selectedSegmentIndex==1){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [windDuidArray containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        //        if select to filter by hydro units only
        
        else if(segGenFilter.selectedSegmentIndex==2){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [hydroDuidArray containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        //        If select my portfolio then only show your own units
        else if(segGenFilter.selectedSegmentIndex==3){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [myUnitList containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        
        //        else show all units
        else{
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               
               //        EXCLUDE THESE DUID'S
               
               //
               (
                ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
                
                )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
    }
    
    //    NSLog(@"Owner Sort is %@",sortedPreComboArray);
    
    
    //    Now break up and allocate to final arrays
    
    for(int i=0; i<[sortedPreComboArray count]; i++){
        
        NSArray *components = [[sortedPreComboArray objectAtIndex:i] componentsSeparatedByString:@","];
        
        if(segSortType.selectedSegmentIndex==0){
            
            [duidArray addObject:[components objectAtIndex:0]];
            [ownerArray addObject:[components objectAtIndex:1]];
            [stateArray addObject:[components objectAtIndex:2]];
            
        }
        
        if(segSortType.selectedSegmentIndex==1){
            
            [duidArray addObject:[components objectAtIndex:1]];
            [ownerArray addObject:[components objectAtIndex:0]];
            [stateArray addObject:[components objectAtIndex:2]];
            
            
        }
        
        if(segSortType.selectedSegmentIndex==2){
            [duidArray addObject:[components objectAtIndex:1]];
            [ownerArray addObject:[components objectAtIndex:2]];
            [stateArray addObject:[components objectAtIndex:0]];
            
        }
        
        //        allocate the rest
        
        [scadaArray addObject:[components objectAtIndex:3]];
        [descArray addObject:[components objectAtIndex:4]];
        [fuelArray addObject:[components objectAtIndex:5]];
        [techTypeArray addObject:[components objectAtIndex:6]];
        [regCapArray addObject:[components objectAtIndex:7]];
        [maxCapArray addObject:[components objectAtIndex:8]];
        [primTechTypeArray addObject:[components objectAtIndex:9]];
    }
    
    
    //    aggregate generation by primary tech type
    
    combustionGen = 0;
    renewableGen = 0;
    totalGen = 0;
    hydroGen = 0;
    windGen = 0;
    
    
    for (int i=0; i<[primTechTypeArray count]; i++){
        
        //        NSLog(@"%@",[primTechTypeArray objectAtIndex:i]);
        
        if([[primTechTypeArray objectAtIndex:i] isEqualToString:@"Combustion"]){
            
            combustionGen = combustionGen + [[scadaArray objectAtIndex:i] floatValue];
            
            
        }
        
        if([[primTechTypeArray objectAtIndex:i] isEqualToString:@"Renewable"]){
            
            renewableGen = renewableGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        if([[fuelArray objectAtIndex:i] isEqualToString:@"Hydro"]){
            
            hydroGen = hydroGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        if([[fuelArray objectAtIndex:i] isEqualToString:@"Wind"]){
            
            windGen = windGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        totalGen = totalGen + [[scadaArray objectAtIndex:i] floatValue];
        
        
    }
    
    
    
    //    NSLog(@"duid %@   genvalue %@   descr  %@", duidArray, scadaArray, descArray);
    //
    //    NSLog(@"combustion gen %.2f, renewable gen %.2f, total gen %.2f", combustionGen, renewableGen, totalGen);
    
    
    
    //    delete previous existing file
    
    // Attempt to delete the last stored file DISPATCH_SCADA.CSV
    if ([fileMgr removeItemAtPath:dbPathCacheLast error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    
    NSLog(@"last stored CSV file DISPATCH_SCADA.CSV deleted");
    
    //    now move current file to last stored file
    if ([fileMgr moveItemAtPath:dbPathCache toPath:dbPathCacheLast error:&error] != YES) {
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    }
    
    
    //    create indexbar array
    
    alphabetIndexArray = [[NSMutableArray alloc] init];
    
    if(segSortType.selectedSegmentIndex==0){
        
        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< [duidArray count]; i++) {
            NSString *letterString = [[duidArray objectAtIndex:i] substringToIndex:1];
            if (![tempFirstLetterArray containsObject:letterString]) {
                [tempFirstLetterArray addObject:letterString];
            }
        }
        alphabetIndexArray = tempFirstLetterArray;
        tempFirstLetterArray=nil;
        
    }
    
    if(segSortType.selectedSegmentIndex==1){
        
        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< [ownerArray count]; i++) {
            NSString *letterString = [[ownerArray objectAtIndex:i] substringToIndex:1];
            if (![tempFirstLetterArray containsObject:letterString]) {
                [tempFirstLetterArray addObject:letterString];
            }
        }
        alphabetIndexArray = tempFirstLetterArray;
        tempFirstLetterArray=nil;
        
        
    }
    
    if(segSortType.selectedSegmentIndex==2){
        //        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        //
        //        for (int i = 0; i< [stateArray count]; i++) {
        //            NSString *letterString = [[stateArray objectAtIndex:i] substringToIndex:1];
        //            if (![tempFirstLetterArray containsObject:letterString]) {
        //                [tempFirstLetterArray addObject:letterString];
        //            }
        //        }
        //        alphabetIndexArray = tempFirstLetterArray;
        //        tempFirstLetterArray=nil;
        
        NSArray *tempArray = [NSArray arrayWithObjects:@"NSW",@"QLD",@"SA",@"TAS",@"VIC", nil];
        
        [alphabetIndexArray addObjectsFromArray:tempArray];
        
        tempArray = nil;
        
    }
    
    //    NSLog(@"%@", stateArray);
    //    NSLog(@"%@", ownerArray);
    
    [tableview1 reloadData];
}


- (void)prcocessData:(NSData *)nemDispatch5min withError:(NSError *)error index:(NSInteger)index
{
    if (index != [self indexForWebCall]) {
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
    
    for (TFHppleElement *element in htmlNodes){
        [nemFiles addObject:[[element firstChild] content]];
    }
    
    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    
    //    Now fetch the file
    urlString = [@"http://www.nemweb.com.au/REPORTS/CURRENT/Dispatch_SCADA/" stringByAppendingString:latestFileName];
    
    //    copy zip file from www
    __weak typeof(self)weakSelf = self;
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:urlString withSelectedIndex:index completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf process5minData2:response withError:error andSelecetedSegment:index latestFileName:latestFileName];
    }];
}


- (void)loadPart3_www {
    __weak typeof(self)weakSelf = self;
    NSString *path = @"http://www.nemweb.com.au/REPORTS/CURRENT/Dispatch_SCADA/";
    NSInteger indexForCall = [self indexForWebCall];
    [[VPDataManager sharedManager] loadDataWithContentsOfURL:path withSelectedIndex:indexForCall completion:^(NSData *response, NSError *error, NSInteger index) {
        [weakSelf prcocessData:response withError:error index:index];
    }];
}



- (void)loadPart3_local {
    
    
    
    
    //    Generator reference lookup file
    NSString *dbPathRes = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"Generators.csv"];
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCH_SCADA.CSV"];
    
    
    //    generation info
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCacheLast encoding:NSUTF8StringEncoding error:nil];
    //
    //    NSLog(@"%@", dataStr);
    
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    trim white space
    
    
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //    generation config
    
    NSString *dataGenStr = [NSString stringWithContentsOfFile:dbPathRes encoding:NSUTF8StringEncoding error:nil];
    NSString *dataGenStrStripped2 = [dataGenStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *genInfoArray = [dataGenStrStripped2 componentsSeparatedByString:@"\n"];
    //    NSLog(@"%@", [genInfoArray objectAtIndex:10]);
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    
    //    vic5min = [dataStr componentsSeparatedByString: @","];
    
    
    duidArray = [[NSMutableArray alloc] init];
    scadaArray = [[NSMutableArray alloc] init];
    descArray = [[NSMutableArray alloc] init];
    ownerArray = [[NSMutableArray alloc] init];
    fuelArray = [[NSMutableArray alloc] init];
    techTypeArray = [[NSMutableArray alloc] init];
    regCapArray = [[NSMutableArray alloc] init];
    maxCapArray = [[NSMutableArray alloc] init];
    stateArray = [[NSMutableArray alloc] init];
    primTechTypeArray = [[NSMutableArray alloc] init];
    
    //    NSMutableArray *icArray = [[NSMutableArray alloc] init];
    
    //    dispPrice = [[DispPrice alloc] init];
    //    dispPrice.state = [[NSMutableArray alloc] init];
    //    dispPrice.price = [[NSMutableArray alloc] init];
    //
    //    dispRegion = [[DispRegionSum alloc] init];
    //    dispRegion.state = [[NSMutableArray alloc] init];
    //    dispRegion.totDem = [[NSMutableArray alloc] init];
    //    dispRegion.disGen = [[NSMutableArray alloc] init];
    //    dispRegion.disLoad = [[NSMutableArray alloc] init];
    //    dispRegion.netInchg = [[NSMutableArray alloc] init];
    //
    //    icFlows = [[IcFlows alloc] init];
    //    icFlows.icID = [[NSMutableArray alloc] init];
    //    icFlows.meterFlow = [[NSMutableArray alloc] init];
    //    icFlows.mwFlow = [[NSMutableArray alloc] init];
    //    icFlows.mwLosses = [[NSMutableArray alloc] init];
    //    icFlows.exportLimit = [[NSMutableArray alloc] init];
    //    icFlows.importLimit = [[NSMutableArray alloc] init];
    
    //
    
    NSMutableArray *windDuidArray =[[NSMutableArray alloc] init];
    NSMutableArray *hydroDuidArray =[[NSMutableArray alloc] init];
    
    NSMutableArray *duidGenArray =[[NSMutableArray alloc] init];
    NSMutableArray *descGenArray =[[NSMutableArray alloc] init];
    
    NSMutableArray *ownerGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *fuelGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *techTypeGenArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *regCapGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *maxCapGenArray = [[NSMutableArray alloc] init];
    
    NSMutableArray *stateGenArray = [[NSMutableArray alloc] init];
    NSMutableArray *primeTechGenArray = [[NSMutableArray alloc] init];
    
    for(int y=1; y<[genInfoArray count]; y++){
        // split generator array into component columns
        NSArray *genComponents = [[genInfoArray objectAtIndex:y] componentsSeparatedByString:@","];
        
        
        // get array of duid numbers
        [duidGenArray addObject:[genComponents objectAtIndex:10]];
        // get array of gen descriptions
        [descGenArray addObject:[genComponents objectAtIndex:1]];
        // get array of gen owner
        [ownerGenArray addObject:[genComponents objectAtIndex:0]];
        // get array of fuel type owner
        [fuelGenArray addObject:[genComponents objectAtIndex:6]];
        // get array of technology type owner
        [techTypeGenArray addObject:[genComponents objectAtIndex:9]];
        // get array of technology type owner
        [regCapGenArray addObject:[genComponents objectAtIndex:11]];
        // get array of technology type owner
        [maxCapGenArray addObject:[genComponents objectAtIndex:12]];
        // get state
        [stateGenArray addObject:[genComponents objectAtIndex:2]];
        // get array of primary technology type owner
        [primeTechGenArray addObject:[genComponents objectAtIndex:8]];
        
        if ([[genComponents objectAtIndex:6] isEqualToString:@"Wind"]){
            //            create array that contains list of wind DUID's
            [windDuidArray addObject:[genComponents objectAtIndex:10]];
        }
        
        if ([[genComponents objectAtIndex:6] isEqualToString:@"Hydro"]){
            //            create array that contains list of wind DUID's
            [hydroDuidArray addObject:[genComponents objectAtIndex:10]];
        }
    }
    
    
    
    //    NSLog(@"duidgenarray value : %@  and desc: %@", duidGenArray, descGenArray);
    
    
    //    this section grabs the NEM time interval from the file
    
    
    NSArray *dateArray = [[disp5min objectAtIndex:2] componentsSeparatedByString:@","];
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    [icDateTime addObject:[dateArray objectAtIndex:4]];
    
    NSString *icDateTimeStripped = [[icDateTime objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    
    //        awesome, convert date formats! wow, cool bit of code
    
    NSString *dateStr =  icDateTimeStripped;
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *d = [dtF dateFromString:dateStr];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    //    NSString *st = [dateFormat stringFromDate:d];
    //    NSLog(@"%@",st);
    
    dateLastUpdated.text= [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:d]];
    
    [[NSUserDefaults standardUserDefaults] setObject:d forKey:@"date5minLastUpdateGen"];
    
    
    dtF=nil;
    dateFormat=nil;
    
    
    //    create array that binds genduid and genvalue for sorting
    
    NSMutableArray *duidScadaCombo = [[NSMutableArray alloc] init];
    
    
    //    dateLastUpdated.text = [NSString stringWithFormat:@"Updated: %@, %@",[dateArray objectAtIndex:5],[dateArray objectAtIndex:6]];
    
    for(int i=2; i<[disp5min count]-2; i++){
        
        NSArray *combArray = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        
        [duidScadaCombo addObject:[NSString stringWithFormat:@"%@,%@", [combArray objectAtIndex:5],[combArray objectAtIndex:6]]];
    }
    
    //    now sort duidscadacomob array
    
    //    NSArray *sortedArray = [duidScadaCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    ////    for (NSString *str in sortedArray) {
    ////        NSLog(@"string %@ ",str);
    ////    }
    //    NSLog(@"sortedarrayelements %d",[sortedArray count]);
    
    
    NSMutableArray *duidArrayTemp =[[NSMutableArray alloc] init];
    NSMutableArray *scadaArrayTemp =[[NSMutableArray alloc] init];
    NSMutableArray *descArrayTemp =[[NSMutableArray alloc] init];
    
    NSMutableArray *ownerArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *fuelArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *techTypeArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *regCapArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *maxCapArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *stateArrayTemp = [[NSMutableArray alloc] init];
    NSMutableArray *primeTechTypeArrayTemp = [[NSMutableArray alloc] init];
    
    NSMutableArray *sortPreCombo = [[NSMutableArray alloc] init];
    
    NSArray *sortedPreComboArray = [[NSArray alloc] init];
    
    NSArray *myUnitList = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyUnitsArray"];
    
    //    NSArray *energyAustList = [NSArray arrayWithObjects:@"AGLHAL", @"MP1", @"MP2", @"TALWA1",@"WATERLWF",@"WW7",@"WW8",@"YWPS1",@"YWPS2",@"YWPS3",@"YWPS4", nil];
    
    for(int i=0; i<[duidScadaCombo count]; i++){
        
        NSArray *components = [[duidScadaCombo objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        //        exclude idle generators
        
        
        //        if select to filter by wind units only
        
        if(segGenFilter.selectedSegmentIndex==1){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [windDuidArray containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        //        if select to filter by hydro units only
        
        else if(segGenFilter.selectedSegmentIndex==2){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [hydroDuidArray containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        //        If select my portfolio then only show your own units
        else if(segGenFilter.selectedSegmentIndex==3){
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               //        EXCLUDE THESE DUID'S
               
               
               [myUnitList containsObject: [components objectAtIndex:0]]
               
               //               (
               //                [[components objectAtIndex:0] isEqualToString:@"AGLHAL"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"MP2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"TALWA1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WATERLWF"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW7"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"WW8"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS1"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS2"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS3"] ||
               //                [[components objectAtIndex:0] isEqualToString:@"YWPS4"] )
               
               //        EXCLUDE THESE DUID'S
               
               //
               //           (
               //           ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
               //           ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
               //
               //            )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
        
        
        //        else show all units
        else{
            
            if(([[components objectAtIndex:1] floatValue] > minDuidVal) &&
               
               
               
               //        EXCLUDE THESE DUID'S
               
               //
               (
                ([[components objectAtIndex:0] rangeOfString:@"DG_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"RT_" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"RUBICON" options:(NSCaseInsensitiveSearch)].location == NSNotFound) &&
                ([[components objectAtIndex:0] rangeOfString:@"SNOWYP" options:(NSCaseInsensitiveSearch)].location == NSNotFound)
                
                )
               
               )
            {
                
                [duidArrayTemp addObject:[components objectAtIndex:0]];
                [scadaArrayTemp addObject:[components objectAtIndex:1]];
                
                
                // find the row number in duidGenArray that corresponds to current duid value
                NSInteger indexVal = [duidGenArray indexOfObject:[components objectAtIndex:0]];
                //            NSLog(@"index value of duid is: %@     %i", [components objectAtIndex:0], indexVal);
                
                
                if (indexVal <= [duidGenArray count]) {
                    [descArrayTemp addObject:[descGenArray objectAtIndex:indexVal]];  //get name of generator
                    [ownerArrayTemp addObject:[ownerGenArray objectAtIndex:indexVal]];
                    [fuelArrayTemp addObject:[fuelGenArray objectAtIndex:indexVal]];
                    [techTypeArrayTemp addObject:[techTypeGenArray objectAtIndex:indexVal]];
                    [regCapArrayTemp addObject:[regCapGenArray objectAtIndex:indexVal]];
                    [maxCapArrayTemp addObject:[maxCapGenArray objectAtIndex:indexVal]];
                    [stateArrayTemp addObject:[stateGenArray objectAtIndex:indexVal]];
                    [primeTechTypeArrayTemp addObject:[primeTechGenArray objectAtIndex:indexVal]];
                }
                else {
                    [descArrayTemp addObject:@"Unknown"];
                    [ownerArrayTemp addObject:@"Unknown"];
                    [fuelArrayTemp addObject:@"Unknown"];
                    [techTypeArrayTemp addObject:@"Unknown"];
                    [regCapArrayTemp addObject:@""];
                    [maxCapArrayTemp addObject:@""];
                    //                [stateArrayTemp addObject:@""];
                    [stateArrayTemp addObject:@"Z"];
                    [primeTechTypeArrayTemp addObject:@""];
                }
                
                //            recombine line items so we can sort by owner or state
                
                
                
                //            curent array index
                NSInteger CurIndex = [duidArrayTemp count]-1;
                
                if(segSortType.selectedSegmentIndex==0){
                    
                    //            if duid sort then leave as is:
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                //            if owner sort
                if(segSortType.selectedSegmentIndex==1){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                    
                }
                
                
                //          if state sort
                
                if(segSortType.selectedSegmentIndex==2){
                    
                    [sortPreCombo addObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@"
                                             ,[stateArrayTemp objectAtIndex:CurIndex]
                                             ,[duidArrayTemp objectAtIndex:CurIndex]
                                             ,[ownerArrayTemp objectAtIndex:CurIndex]
                                             ,[scadaArrayTemp objectAtIndex:CurIndex]
                                             ,[descArrayTemp objectAtIndex:CurIndex]
                                             ,[fuelArrayTemp objectAtIndex:CurIndex]
                                             ,[techTypeArrayTemp objectAtIndex:CurIndex]
                                             ,[regCapArrayTemp objectAtIndex:CurIndex]
                                             ,[maxCapArrayTemp objectAtIndex:CurIndex]
                                             ,[primeTechTypeArrayTemp objectAtIndex:CurIndex]
                                             ]];
                }
                
                sortedPreComboArray = [sortPreCombo sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            }
        }
    }
    
    //    NSLog(@"Owner Sort is %@",sortedPreComboArray);
    
    
    //    Now break up and allocate to final arrays
    
    for(int i=0; i<[sortedPreComboArray count]; i++){
        
        NSArray *components = [[sortedPreComboArray objectAtIndex:i] componentsSeparatedByString:@","];
        
        if(segSortType.selectedSegmentIndex==0){
            
            [duidArray addObject:[components objectAtIndex:0]];
            [ownerArray addObject:[components objectAtIndex:1]];
            [stateArray addObject:[components objectAtIndex:2]];
            
        }
        
        if(segSortType.selectedSegmentIndex==1){
            
            [duidArray addObject:[components objectAtIndex:1]];
            [ownerArray addObject:[components objectAtIndex:0]];
            [stateArray addObject:[components objectAtIndex:2]];
            
            
        }
        
        if(segSortType.selectedSegmentIndex==2){
            [duidArray addObject:[components objectAtIndex:1]];
            [ownerArray addObject:[components objectAtIndex:2]];
            [stateArray addObject:[components objectAtIndex:0]];
            
        }
        
        //        allocate the rest
        
        [scadaArray addObject:[components objectAtIndex:3]];
        [descArray addObject:[components objectAtIndex:4]];
        [fuelArray addObject:[components objectAtIndex:5]];
        [techTypeArray addObject:[components objectAtIndex:6]];
        [regCapArray addObject:[components objectAtIndex:7]];
        [maxCapArray addObject:[components objectAtIndex:8]];
        [primTechTypeArray addObject:[components objectAtIndex:9]];
    }
    
    
    //    aggregate generation by primary tech type
    
    combustionGen = 0;
    renewableGen = 0;
    totalGen = 0;
    hydroGen = 0;
    windGen = 0;
    
    
    for (int i=0; i<[primTechTypeArray count]; i++){
        
        //        NSLog(@"%@",[primTechTypeArray objectAtIndex:i]);
        
        if([[primTechTypeArray objectAtIndex:i] isEqualToString:@"Combustion"]){
            
            combustionGen = combustionGen + [[scadaArray objectAtIndex:i] floatValue];
            
            
        }
        
        if([[primTechTypeArray objectAtIndex:i] isEqualToString:@"Renewable"]){
            
            renewableGen = renewableGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        if([[fuelArray objectAtIndex:i] isEqualToString:@"Hydro"]){
            
            hydroGen = hydroGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        if([[fuelArray objectAtIndex:i] isEqualToString:@"Wind"]){
            
            windGen = windGen + [[scadaArray objectAtIndex:i] floatValue];
            
        }
        
        totalGen = totalGen + [[scadaArray objectAtIndex:i] floatValue];
        
        
    }
    
    
    
    //    NSLog(@"duid %@   genvalue %@   descr  %@", duidArray, scadaArray, descArray);
    //
    //    NSLog(@"combustion gen %.2f, renewable gen %.2f, total gen %.2f", combustionGen, renewableGen, totalGen);
    
    
    
    //    create indexbar array
    
    alphabetIndexArray = [[NSMutableArray alloc] init];
    
    if(segSortType.selectedSegmentIndex==0){
        
        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< [duidArray count]; i++) {
            NSString *letterString = [[duidArray objectAtIndex:i] substringToIndex:1];
            if (![tempFirstLetterArray containsObject:letterString]) {
                [tempFirstLetterArray addObject:letterString];
            }
        }
        alphabetIndexArray = tempFirstLetterArray;
        tempFirstLetterArray=nil;
        
    }
    
    if(segSortType.selectedSegmentIndex==1){
        
        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i< [ownerArray count]; i++) {
            NSString *letterString = [[ownerArray objectAtIndex:i] substringToIndex:1];
            if (![tempFirstLetterArray containsObject:letterString]) {
                [tempFirstLetterArray addObject:letterString];
            }
        }
        alphabetIndexArray = tempFirstLetterArray;
        tempFirstLetterArray=nil;
        
        
    }
    
    if(segSortType.selectedSegmentIndex==2){
        //        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
        //
        //        for (int i = 0; i< [stateArray count]; i++) {
        //            NSString *letterString = [[stateArray objectAtIndex:i] substringToIndex:1];
        //            if (![tempFirstLetterArray containsObject:letterString]) {
        //                [tempFirstLetterArray addObject:letterString];
        //            }
        //        }
        //        alphabetIndexArray = tempFirstLetterArray;
        //        tempFirstLetterArray=nil;
        
        NSArray *tempArray = [NSArray arrayWithObjects:@"NSW",@"QLD",@"SA",@"TAS",@"VIC", nil];
        
        [alphabetIndexArray addObjectsFromArray:tempArray];
        
        tempArray = nil;
        
    }
    
    //    NSLog(@"%@", stateArray);
    //    NSLog(@"%@", ownerArray);
    
    [tableview1 reloadData];
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//        return 1.0f;
//    return 32.0f;
//
//
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //    tableview1.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    //
    //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
    //        tableview1.contentInset = UIEdgeInsetsMake(-100, 0, 0, 0);
    //    }
    tableview1.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableview1.bounds.size.width, 0.01f)];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //    NSLog(@"View loaded");
    
    // Initialization code
    
    // Set divider images
    //    [segGenFilter setDividerImage:[UIImage imageNamed:@"segmented-control-divider-none-selected"]
    //      forLeftSegmentState:UIControlStateNormal
    //        rightSegmentState:UIControlStateNormal
    //               barMetrics:UIBarMetricsDefault];
    //    [segGenFilter setDividerImage:[UIImage imageNamed:@"segmented-control-divider-left-selected"]
    //      forLeftSegmentState:UIControlStateSelected
    //        rightSegmentState:UIControlStateNormal
    //               barMetrics:UIBarMetricsDefault];
    //    [segGenFilter setDividerImage:[UIImage imageNamed:@"segmented-control-divider-right-selected"]
    //      forLeftSegmentState:UIControlStateNormal
    //        rightSegmentState:UIControlStateSelected
    //               barMetrics:UIBarMetricsDefault];
    //
    //    // Set background images
    //    UIImage *normalBackgroundImage = [UIImage imageNamed:@"segmented-control-normal.png"];
    //    [segGenFilter setBackgroundImage:normalBackgroundImage
    //                    forState:UIControlStateNormal
    //                  barMetrics:UIBarMetricsDefault];
    //    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"segmented-control-selected.png"];
    //    [segGenFilter setBackgroundImage:selectedBackgroundImage
    //                    forState:UIControlStateSelected
    //                  barMetrics:UIBarMetricsDefault];
    
    segGenFilter.segmentBackgroundColor = [UIColor colorWithRed:0.00f green:0.50f blue:0.92f alpha:1.0];
    //        [segGenFilter setSegmentBackgroundColor:[UIColor colorWithRed:0.431f green:0.6860f blue:0.902f alpha:1.0] atIndex:3];
    
    [segGenFilter setSegmentBackgroundColor:[UIColor colorWithRed:0.396f green:0.4941f blue:0.6275f alpha:1.0] atIndex:3];
    
    //    segGenFilter.imageColor = nil;
    //    segGenFilter.selectedImageColor=  nil;
    
    [segGenFilter setImage:[UIImage imageNamed:@"windfarm_icon.png"] forSegmentAtIndex:1];
    [segGenFilter setImage:[UIImage imageNamed:@"hydro_icon.png"] forSegmentAtIndex:2];
    [segGenFilter setImage:[UIImage imageNamed:@"generator_icon.png"] forSegmentAtIndex:0];
    
    
    //    segGenFilter.segmentBackgroundColor = [UIColor blueColor];
    //    [segGenFilter setSegmentBackgroundColor:[UIColor redColor] atIndex:3];
    
    if(zeroSwitch.on==TRUE){
        minDuidVal = -5;
    } else {
        minDuidVal = 0;
    }
    
    
    [self loadPart1];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"DoUpdateTable" object:nil];
    
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    duidArray=nil;
    scadaArray=nil;
    
    descArray=nil;
    tableview1=nil;
    ownerArray=nil;
    fuelArray=nil;
    techTypeArray=nil;
    regCapArray=nil;
    maxCapArray=nil;
    stateArray=nil; primTechTypeArray=nil; dateLastUpdated=nil;
    segSortType=nil;
    alphabetIndexArray=nil;
    zeroSwitch=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return alphabetIndexArray;
}

- (void)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    
    if(segSortType.selectedSegmentIndex==0){
        
        for (int i = 0; i< [duidArray count]; i++) {
            
            //---Here you return the name i.e. Honda,Mazda and match the title for first letter of name and move to that row corresponding to that indexpath as below---//
            
            NSString *letterString = [[duidArray objectAtIndex:i] substringToIndex:1];
            if ([letterString isEqualToString:title]) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        
    }
    
    if(segSortType.selectedSegmentIndex==1){
        
        for (int i = 0; i< [ownerArray count]; i++) {
            
            //---Here you return the name i.e. Honda,Mazda and match the title for first letter of name and move to that row corresponding to that indexpath as below---//
            
            NSString *letterString = [[ownerArray objectAtIndex:i] substringToIndex:1];
            if ([letterString isEqualToString:title]) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        
        
    }
    
    if(segSortType.selectedSegmentIndex==2){
        
        for (int i = 0; i< [stateArray count]; i++) {
            
            //---Here you return the name i.e. Honda,Mazda and match the title for first letter of name and move to that row corresponding to that indexpath as below---//
            
            NSString *letterString = [[stateArray objectAtIndex:i] substringToIndex:1];
            //            if ([letterString isEqualToString:title]) {
            if ([letterString isEqualToString:[title substringToIndex:1]]) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                break;
            }
        }
        
    }
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [duidArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    NSRange stringRange = {0, MIN([[descArray objectAtIndex:indexPath.row] length], 29)};
    NSRange stringRange1 = {0, MIN([[ownerArray objectAtIndex:indexPath.row] length], 29)};
    
    
    if ([[stateArray objectAtIndex:indexPath.row] length]==1){
        stateString = @"";
    }else {
        stateString = [NSString stringWithFormat:@"(%@)",[[stateArray objectAtIndex:indexPath.row] substringToIndex:[[stateArray objectAtIndex:indexPath.row] length]-1]];
    }
    
    if(segSortType.selectedSegmentIndex==1){
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@\n%@\n%@",[duidArray objectAtIndex:indexPath.row],stateString,[[descArray objectAtIndex:indexPath.row] substringWithRange:stringRange],[[ownerArray objectAtIndex:indexPath.row] substringWithRange:stringRange1]];
        cell.textLabel.numberOfLines=3;
        cell.textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@\n%@",[duidArray objectAtIndex:indexPath.row],stateString,[[descArray objectAtIndex:indexPath.row] substringWithRange:stringRange]];
        cell.textLabel.numberOfLines=2;
        cell.textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    }
    
    
    
    
    
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2fMW\n( %.0f%% )",[[scadaArray objectAtIndex:indexPath.row] floatValue],100*[[scadaArray objectAtIndex:indexPath.row] floatValue]/[[maxCapArray objectAtIndex:indexPath.row] floatValue]];
    cell.detailTextLabel.numberOfLines=2;
    cell.textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    
    
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(segSortType.selectedSegmentIndex==1){
        
        return 60;
        
    }
    else {
        return 45;
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    UIAlertView *genDetails = [[UIAlertView alloc] initWithTitle:@"Generator Details"
                                                         message:[NSString stringWithFormat:@"%@\nFuel Type: %@\nTechnology: %@\nRegistered Capacity: %@ MW\nMax Capacity: %@ MW",[ownerArray objectAtIndex:indexPath.row],[fuelArray objectAtIndex:indexPath.row],[techTypeArray objectAtIndex:indexPath.row],[regCapArray objectAtIndex:indexPath.row],[maxCapArray objectAtIndex:indexPath.row]]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [genDetails show];
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[primTechTypeArray objectAtIndex:indexPath.row] isEqualToString:@"Renewable"])
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.74f green:0.96f blue:0.66f alpha:1.0f]];
        
        
        //        CAGradientLayer *grad = [CAGradientLayer layer];
        //        grad.frame = cell.bounds;
        //        grad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        //
        //        [cell setBackgroundView:[[UIView alloc] init]];
        //        [cell.backgroundView.layer insertSublayer:grad atIndex:0];
        
        
    }
    else [cell setBackgroundColor:[UIColor colorWithRed:0.968f green:0.904f blue:0.76f alpha:1.0f]];
    
    
}

- (IBAction)carbonIntesityTapped:(id)sender {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0"];
    
    
    UIAlertView *carbonDetails = [[UIAlertView alloc] initWithTitle:@"Generation Mix"
                                                            message:[NSString stringWithFormat:@"Combustion: %@ MW\n\nWind: %@ MW\nHydro: %@ MW\nTotal Renewables: %@ MW                                                                  \n\nUnclassified: %@ MW\nTotal Generation: %@ MW\n\nWind %.2f%%\nHydro %.2f%%\nTotal Renewables %.2f%%",
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:combustionGen]],
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:windGen]],
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:hydroGen]],
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:renewableGen]],
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:(totalGen-combustionGen-renewableGen)]],
                                                                     [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalGen]],
                                                                     (windGen/totalGen)*100,
                                                                     (hydroGen/totalGen)*100,
                                                                     (renewableGen/totalGen)*100]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
    
    //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
    // optional - add more buttons:
    [carbonDetails show];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toMyUnits"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"didRunBefore"];
        NSLog(@"Seg fired off and didrunbefore set to NO");
        
    }
}


-(BOOL) shouldAutorotate {
    return NO;
}


@end
