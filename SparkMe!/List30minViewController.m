//
//  List30minViewController.m
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "List30minViewController.h"
#import "MBProgressHUD.h"
#import "Chart30minViewController.h"
#import "Reachability.h"
#import "SettingsViewController.h"
#import "CustomCell30.h"

@interface List30minViewController ()

@end

@implementation List30minViewController

@synthesize  dbPathCache, fileMgr, nem5min, stateURL, tableViewLabel, components, dateLastUpdated, mytableView, stateSelected, segVal, priceArray, demandArray, settingsLabel, timeArray, typeArray, priceArrayRaw, timeArrayRaw, demandArrayRaw, minPrice, maxPrice, avgPrice, typeArrayRaw;

//scroll to middle to trade and PD region


-(IBAction)scrollTableView:(id)sender{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArrayRaw count]-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:55 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

-(void)scrollToCurrentPeriod{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArrayRaw count]-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:55 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}
- (void)reloadData {
    
    NSLog(@"BEGIN reloadData");
    
    [self.mytableView reloadData];
    
    NSLog(@"END reloadData");
    [self scrollToCurrentPeriod];
    
}




-(IBAction)segmentControlTap:(UISegmentedControl *)sender{
    
    
    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.csv";
            NSLog(@"NSW pressed");
            stateSelected=@"NSW";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            no scrolling to the top as it is annoying for customers
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            
            //            scroll to current time
            //            [self scrollToCurrentPeriod];
            
            break;
        case 1:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30QLD1.csv";
            NSLog(@"QLD pressed");
            stateSelected=@"QLD";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            //            [self scrollToCurrentPeriod];
            
            break;
        case 2:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30SA1.csv";
            NSLog(@"SA pressed");
            stateSelected=@"SA";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            //            [self scrollToCurrentPeriod];
            break;
        case 3:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30TAS1.csv";
            NSLog(@"TAS pressed");
            stateSelected=@"TAS";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            //            [self scrollToCurrentPeriod];
            break;
        case 4:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30VIC1.csv";
            NSLog(@"VIC pressed");
            stateSelected=@"VIC";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            //            [self scrollToCurrentPeriod];
            break;
            
            
        default:
            break;
            
    }
    
    
}

-(IBAction)refreshData:(id)sender{
    
    [self viewDidLoad];
    //    [self.mytableView reloadData];
    NSLog(@"Data refresh tapped");
    
}


- (void) updateMaxPriceDemand
{
    
    settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
    
    [mytableView reloadData];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View Loaded");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMaxPriceDemand) name:@"DoUpdateLabel" object:nil];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                  message:@"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
        // optional - add more buttons:
        [alertNoInternet show];
        
        
    } else {
        
        NSLog(@"There IS internet connection");
        
        //    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view  animated:YES];
        //    HUD.labelText=@"Connecting";
        
        [self loadPart1];
        
        
    }
}



- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}

- (void)loadPart2 {
    
    //    Display date stamp of lastest file stored from last web call
    
    NSDate *DateLastFile = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"date30minLastUpdateSnapShot"];
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    
    if(DateLastFile==NULL || ([DateLastFileAdj compare:dateNow]==NSOrderedAscending) || jsonArray == nil || [jsonArray count] == 0)
    {
        NSLog(@"Current time is greater than ADJ time - PERFORM WEB QUERY");
        
        //        do web call
        
        [self loadPart2_www];
        
        
    }
    else{
        
        NSLog(@"Current time is less than ADJ time - USE LOCAL FILE");
        
        [self loadPart2_local];
    }
    
}


-(void) loadPart2_www{
    
    
    //===========
    
    
    NSDictionary *headers = @{ @"origin": @"http://aemo.com.au",
                               
                               @"content-type": @"application/json",
                               
                               @"accept": @"*/*",
                               
                               @"referer": @"http://aemo.com.au/aemo/apps/visualisations/elec-priceanddemand.html",
                               
                               @"accept-encoding": @"gzip, deflate",
                               
                               @"accept-language": @"en-US,en;q=0.8",
                               
                               @"cache-control": @"no-cache"};
    
    NSDictionary *parameters = @{ @"timeScale": @[ @"30MIN" ] };
    
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://aemo.com.au/aemo/apps/api/report/5MIN"]
                                    
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    [request setAllHTTPHeaderFields:headers];
    
    [request setHTTPBody:postData];
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                      
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    if (error) {
                                                        
                                                        NSLog(@"%@", error);
                                                        
                                                    } else {
                                                        
                                                        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                        
                                                        NSLog(@"This is the response!!! %@", httpResponse);
                                                        
                                                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                        
                                                        
                                                        
                                                        
                                                        NSArray *jsonArray = [jsonDictionary objectForKey:@"5MIN"];
                                                        
                                                        // save the array to file
                                                        
                                                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                                        NSString *documentsDirectory = [paths objectAtIndex:0];
                                                        dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.csv"];
                                                        
                                                        [jsonArray writeToFile:dbPathCache atomically:YES];
                                                        
                                                        
                                                        //                                                        subset the jsonArray be desired region
                                                        
                                                        
                                                        
                                                        priceArrayRaw = [[NSMutableArray alloc] init];
                                                        timeArrayRaw = [[NSMutableArray alloc] init];
                                                        demandArrayRaw = [[NSMutableArray alloc] init];
                                                        typeArrayRaw = [[NSMutableArray alloc] init];
                                                        
                                                        //NSLog(@"This is the data!!! %@", jsonResult);
                                                        
                                                        
                                                        
                                                        //NSW index values between 0 and 110
                                                        //QLD index values between 111 and 221
                                                        //SA index values between 222 and 332
                                                        //TAS index values between 333 and 443
                                                        //VIC index values between 444 and 554
                                                        
                                                        if(segVal.selectedSegmentIndex==0){
                                                            stateSelected =@"NSW";
                                                        }
                                                        
                                                        
                                                        
                                                        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
                                                        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                                        
                                                        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
                                                        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
                                                        
                                                        
                                                        //                                                        NSLog(@"date value is %@", jsonArray);
                                                        
                                                        minPrice = 0;
                                                        maxPrice = 0;
                                                        
                                                        
                                                        
                                                        for(int i=0; i<[jsonArray count]; i++){
                                                            
                                                            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:[stateSelected stringByAppendingString:@"1"]]) {
                                                                
                                                                // convert crappy dates to normal dates
                                                                
                                                                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                                                                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                                                                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                                                                
                                                                NSString *typeStr = nil;
                                                                
                                                                if ([[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"]){
                                                                    typeStr = @"TRADE";
                                                                } else {
                                                                    typeStr = @"PD";
                                                                }
                                                                
                                                                
                                                                // NSLog(@"date value is %@", dTrim);
                                                                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                                                                
                                                                //NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                                                                
                                                                [timeArrayRaw addObject:[dateFormatTrim stringFromDate:dTrim]];
                                                                [priceArrayRaw addObject:rrpNum];
                                                                [demandArrayRaw addObject:demandNum];
                                                                [typeArrayRaw addObject:typeStr];
                                                                
                                                                
                                                                NSNumber *curPrice = rrpNum;
                                                                
                                                                if([timeArrayRaw count]==1) {
                                                                    
                                                                    minPrice = curPrice;
                                                                    
                                                                }
                                                                
                                                                if (curPrice < minPrice)
                                                                    minPrice = curPrice;
                                                                else if (curPrice > maxPrice)
                                                                    maxPrice = curPrice;
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        //                                                        NSLog(@"This is price!!! %@, %@, %@", timeArrayRaw, priceArrayRaw, demandArrayRaw);
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        NSLog(@"When is this run???");
                                                        [self reloadData];
                                                        
                                                        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                                                        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                                                        [formatter setMaximumFractionDigits:2];
                                                        [formatter setMinimumFractionDigits:2];
                                                        [formatter setRoundingMode: NSNumberFormatterRoundUp];
                                                        
                                                        avgPrice = [priceArrayRaw valueForKeyPath:@"@avg.self"];
                                                        minPrice = [priceArrayRaw valueForKeyPath:@"@min.self"];
                                                        maxPrice = [priceArrayRaw valueForKeyPath:@"@max.self"];
                                                        
                                                        //                                                        priceStats.text=[NSString stringWithFormat:@"Price: Min %@, Max %@, Avg %@",[formatter stringFromNumber:minPrice],[formatter stringFromNumber:maxPrice],[formatter stringFromNumber:avgPrice]];
                                                        
                                                        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
                                                        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                                        
                                                        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
                                                        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
                                                        
                                                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
                                                        
                                                        settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
                                                        
                                                        dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayRaw objectAtIndex:47]]]];
                                                        
                                                        [[NSUserDefaults standardUserDefaults] setObject:[dateFormatTrim dateFromString:[timeArrayRaw objectAtIndex:[timeArrayRaw count]-1]] forKey:@"date30minLastUpdateSnapShot"];
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view  animated:YES];
                                                        
                                                    });
                                                    
                                                    
                                                }];
    
    [dataTask resume];
    
    
}

//
//
//
//
//    if(segVal.selectedSegmentIndex==0){
//        stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.csv";
//    }
//
//
//
//
//
//    // --- check to see if permits db exists in documents directory
//    fileMgr = [NSFileManager defaultManager];
//    // location changed from documents directory to caches directory to confirm with apple requirements
//    dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"GRAPH_30.csv"];
//
//
//    NSData *fetchedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stateURL]];
//
//
//
//
//    [fetchedData writeToFile:dbPathCache atomically:YES];
//
//    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
//    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    //    trim white space
//    NSString *dataStrStripped2 = [dataStrStripped stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    //        NSLog(@"%@", dataStrStripped2);
//
//
//    nem5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
//
//
//    //    vic5min = [dataStr componentsSeparatedByString: @","];
//
//    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
//    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//
//    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
//    //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//    [dateFormatTrim setDateFormat:@"dd/MM HH:mm"];
//
////    tableViewLabel = [[NSMutableArray alloc] init];
//    priceArray = [[NSMutableArray alloc] init];
//    demandArray = [[NSMutableArray alloc] init];
//
//    timeArray = [[NSMutableArray alloc] init];
//    typeArray = [[NSMutableArray alloc] init];
//
//    for(int i=0; i<[nem5min count]; i++){
//        if(i==0||[[nem5min objectAtIndex:i] isEqualToString:@""]){
//            continue;
//        }
//
//        components = [[nem5min objectAtIndex:i] componentsSeparatedByString:@","];
//
//
////        NSString *rows = [NSString stringWithFormat:@" %@     %9.2f      %.5f     %@", [dateFormatTrim stringFromDate:dTrim], [[components objectAtIndex:2] floatValue], [[components objectAtIndex:3] floatValue], [components objectAtIndex:4]];
////        [tableViewLabel addObject:rows];
//
//        NSString *timeStr = [NSString stringWithFormat:@"%@", [components objectAtIndex:1]];
//        NSString *demand = [NSString stringWithFormat:@"%.2f", [[components objectAtIndex:2] floatValue]];
//        NSString *price = [NSString stringWithFormat:@"%.5f", [[components objectAtIndex:3] floatValue]];
//        NSString *typeStr = [NSString stringWithFormat:@"%@", [components objectAtIndex:4]];
//
//        [demandArray addObject:demand];
//        [priceArray addObject:price];
//        [timeArray addObject:timeStr];
//        [typeArray addObject:typeStr];
//
//
//
//    }
//
//        [self reloadData];
//
////        get NEM time string
//
//        NSString *dateStr = [timeArray objectAtIndex:47];
//
//        NSDate *d = [dtF dateFromString:dateStr];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
//        //        [dateFormat setTimeZone:timeZone];
//
//        NSString *st = [dateFormat stringFromDate:d];
//        NSLog(@"%@",st);
//
//        dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:d]];
//
//         settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
//
//    [MBProgressHUD hideHUDForView:self.view  animated:YES];
//}

-(void) loadPart2_local{
    
    //    if(segVal.selectedSegmentIndex==0){
    //        stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.csv";
    //        stateSelected=@"NSW";
    //    }
    
    
    
    // --- check to see if permits db exists in documents directory
    fileMgr = [NSFileManager defaultManager];
    
    
    //    NSString *state30minFile = [stateSelected stringByAppendingString:@"GRAPH_30.CSV"];
    
    // location changed from documents directory to caches directory to confirm with apple requirements
    //    dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:state30minFile];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    
    priceArrayRaw = [[NSMutableArray alloc] init];
    timeArrayRaw = [[NSMutableArray alloc] init];
    demandArrayRaw = [[NSMutableArray alloc] init];
    typeArrayRaw = [[NSMutableArray alloc] init];
    
    //NSLog(@"This is the data!!! %@", jsonResult);
    
    
    
    //NSW index values between 0 and 110
    //QLD index values between 111 and 221
    //SA index values between 222 and 332
    //TAS index values between 333 and 443
    //VIC index values between 444 and 554
    
    if(segVal.selectedSegmentIndex==0){
        stateSelected =@"NSW";
    }
    
    
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
    
    
    //                                                        NSLog(@"date value is %@", jsonArray);
    
    minPrice = 0;
    maxPrice = 0;
    
    
    
    for(int i=0; i<[jsonArray count]; i++){
        
        if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:[stateSelected stringByAppendingString:@"1"]]) {
            
            // convert crappy dates to normal dates
            
            NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
            NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
            NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
            
            NSString *typeStr = nil;
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"]){
                typeStr = @"TRADE";
            } else {
                typeStr = @"PD";
            }
            
            
            // NSLog(@"date value is %@", dTrim);
            //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
            
            //NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
            
            [timeArrayRaw addObject:[dateFormatTrim stringFromDate:dTrim]];
            [priceArrayRaw addObject:rrpNum];
            [demandArrayRaw addObject:demandNum];
            [typeArrayRaw addObject:typeStr];
            
            
            NSNumber *curPrice = rrpNum;
            
            if([timeArrayRaw count]==1) {
                
                minPrice = curPrice;
                
            }
            
            if (curPrice < minPrice)
                minPrice = curPrice;
            else if (curPrice > maxPrice)
                maxPrice = curPrice;
            
            
        }
        
        
    }
    
    //                                                        NSLog(@"This is price!!! %@, %@, %@", timeArrayRaw, priceArrayRaw, demandArrayRaw);
    
    NSLog(@"When is this run???");
    [self reloadData];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setMinimumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    avgPrice = [priceArrayRaw valueForKeyPath:@"@avg.self"];
    minPrice = [priceArrayRaw valueForKeyPath:@"@min.self"];
    maxPrice = [priceArrayRaw valueForKeyPath:@"@max.self"];
    
    //                                                        priceStats.text=[NSString stringWithFormat:@"Price: Min %@, Max %@, Avg %@",[formatter stringFromNumber:minPrice],[formatter stringFromNumber:maxPrice],[formatter stringFromNumber:avgPrice]];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayRaw objectAtIndex:47]]]];
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
    
}

//
//
//
//    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//    //    trim white space
//    NSString *dataStrStripped2 = [dataStrStripped stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    //        NSLog(@"%@", dataStrStripped2);
//
//
//    nem5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
//
//
//    //    vic5min = [dataStr componentsSeparatedByString: @","];
//
//    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
//    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
//
//    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
//    //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//    [dateFormatTrim setDateFormat:@"dd/MM HH:mm"];
//
////    tableViewLabel = [[NSMutableArray alloc] init];
//    priceArray = [[NSMutableArray alloc] init];
//    demandArray = [[NSMutableArray alloc] init];
//
//    timeArray = [[NSMutableArray alloc] init];
//    typeArray = [[NSMutableArray alloc] init];
//
//    for(int i=0; i<[nem5min count]; i++){
//        if(i==0||[[nem5min objectAtIndex:i] isEqualToString:@""]){
//            continue;
//        }
//
//        components = [[nem5min objectAtIndex:i] componentsSeparatedByString:@","];
//
//
////        NSString *rows = [NSString stringWithFormat:@" %@     %9.2f      %.5f     %@", [dateFormatTrim stringFromDate:dTrim], [[components objectAtIndex:2] floatValue], [[components objectAtIndex:3] floatValue], [components objectAtIndex:4]];
////        [tableViewLabel addObject:rows];
//
//        NSString *timeStr = [NSString stringWithFormat:@"%@", [components objectAtIndex:1]];
//        NSString *demand = [NSString stringWithFormat:@"%.2f", [[components objectAtIndex:2] floatValue]];
//        NSString *price = [NSString stringWithFormat:@"%.5f", [[components objectAtIndex:3] floatValue]];
//        NSString *typeStr = [NSString stringWithFormat:@"%@", [components objectAtIndex:4]];
//
//        [demandArray addObject:demand];
//        [priceArray addObject:price];
//        [timeArray addObject:timeStr];
//        [typeArray addObject:typeStr];
//
//
//
//    }
//
//    [self reloadData];
//
//    //        get NEM time string
//
//    NSString *dateStr = [timeArray objectAtIndex:47];
//
//    NSDate *d = [dtF dateFromString:dateStr];
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
//    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
//    //        [dateFormat setTimeZone:timeZone];
//
//    NSString *st = [dateFormat stringFromDate:d];
//    NSLog(@"%@",st);
//
//    dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:d]];
//
//    settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
//
//    [MBProgressHUD hideHUDForView:self.view  animated:YES];
//}


//-(void) viewWillAppear:(BOOL)animated{
////    [self.mytableView reloadData];
//    NSLog(@"ViewWillAppear");
//    settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
//
//}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DoUpdateLabel" object:nil];
    
    dbPathCache=nil;
    fileMgr=nil;
    nem5min=nil;
    stateURL=nil;
    tableViewLabel=nil;
    components=nil;
    dateLastUpdated=nil;
    mytableView=nil;
    stateSelected=nil;
    segVal=nil;
    demandArray=nil;
    priceArray=nil;
    timeArray=nil;
    typeArray=nil;
    timeArrayRaw=nil;
    demandArrayRaw=nil;
    priceArrayRaw=nil;
    typeArrayRaw=nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [timeArrayRaw count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"CustomCell30";
    CustomCell30 *cell = (CustomCell30 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"CustomCell30" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (CustomCell30 *) currentObject;
                break;
            }
        }
    }
    
    
    //    static NSString *CellIdentifier = @"Cell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    //    }
    
    //cell.textLabel.text=@"Detail";
    
    //    limit length of address to 40 characters
    
    //    NSArray *rowArray = [vic5min objectAtIndex:indexPath.row];
    
    //    NSString *rowText = [NSString stringWithFormat:@"%@\t%@\t%@\t%@",[rowArray objectAtIndex:0], [rowArray objectAtIndex:1], [rowArray objectAtIndex:2], [rowArray objectAtIndex:3]];
    
    //	cell.textLabel.text = [tableViewLabel objectAtIndex:indexPath.row];
    
    //	cell.textLabel.text = [[[PermitObj.perm_addr substringToIndex:[PermitObj.perm_addr length] - 8] stringByAppendingString:@"\n"] stringByAppendingString:PermitObj.decision];
    //    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:13.0];
    //    cell.textLabel.numberOfLines=1;
    
    //    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    //    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    //
    //    NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
    //    //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    //    [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //    [dateFormatTrim setDateFormat:@"dd/MM HH:mm"];
    //
    //    NSString *dateStrNEM = [timeArray objectAtIndex:indexPath.row];
    //    NSDate *dTrim = [dtF dateFromString:dateStrNEM];
    //
    //
    //    cell.dateLabel.text=[dateFormatTrim stringFromDate:dTrim];
    //    cell.demandLabel.text=[demandArray objectAtIndex:indexPath.row];
    //    cell.priceLabel.text=[priceArray objectAtIndex:indexPath.row];
    //    cell.typeLabel.text=[typeArray objectAtIndex:indexPath.row];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    cell.dateLabel.text=[timeArrayRaw objectAtIndex:indexPath.row];
    cell.demandLabel.text=[formatter stringFromNumber:[demandArrayRaw objectAtIndex:indexPath.row]];
    cell.priceLabel.text=[formatter stringFromNumber:[priceArrayRaw objectAtIndex:indexPath.row]];
    cell.typeLabel.text=[typeArrayRaw objectAtIndex:indexPath.row];
    
    
    // Configure the cell...
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell30 *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    else [cell setBackgroundColor:[UIColor clearColor]];
    
    
    if(([[demandArrayRaw objectAtIndex:indexPath.row] floatValue] >= [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"])  ||
       ([[priceArrayRaw objectAtIndex:indexPath.row] floatValue] >= [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]) ||
       ([[priceArrayRaw objectAtIndex:indexPath.row] floatValue] < 0))
    {
        //        [cell setBackgroundColor:[UIColor redColor]];
        cell.dateLabel.textColor = [UIColor redColor];
        cell.demandLabel.textColor = [UIColor redColor];
        cell.priceLabel.textColor = [UIColor redColor];
        cell.typeLabel.textColor = [UIColor redColor];
        
    }
    else {
        //        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.dateLabel.textColor = [UIColor blackColor];
        cell.demandLabel.textColor = [UIColor blackColor];
        cell.priceLabel.textColor = [UIColor blackColor];
        cell.typeLabel.textColor = [UIColor blackColor];
    }
    
    //    attempt to set current price and pre and post price to diff colors
    
    //    if (indexPath.row ==46  || indexPath.row ==48)
    //    {
    //        [cell setBackgroundColor:[UIColor orangeColor]];
    //    }
    //
    //
    //    if (indexPath.row ==47)
    //    {
    //        [cell setBackgroundColor:[UIColor yellowColor]];
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
    
    //    NSLog(@"Label height is %f", labelSize.height+5);
    
    //    return labelSize.height + 5;
    
    return 21;
    
    
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

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
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"pushChart3"]) {
        Chart30minViewController *Chart30minVC = [segue destinationViewController];
        Chart30minVC.chartURLStr = @"http://crimsonbeans.com/cbprojects/hvb/priceanddemand_30min_chart.php?region=QLD1";
        
        if(segVal.selectedSegmentIndex==0){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.gif";
            Chart30minVC.selState=@"NSW";
        }
        
        if([stateSelected isEqual: @"NSW"]){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.gif";
            Chart30minVC.selState = stateSelected;
        }
        else if ([stateSelected isEqual: @"QLD"]){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30QLD1.gif";
            Chart30minVC.selState = stateSelected;
        }
        else if ([stateSelected isEqual: @"SA"]){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30SA1.gif";
            Chart30minVC.selState = stateSelected;
        }
        else if ([stateSelected isEqual: @"TAS"]){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30TAS1.gif";
            Chart30minVC.selState = stateSelected;
        }
        else if ([stateSelected isEqual: @"VIC"]){
            Chart30minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30VIC1.gif";
            Chart30minVC.selState = stateSelected;
        }
        
        Chart30minVC.hidesBottomBarWhenPushed = YES;
        
        
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
