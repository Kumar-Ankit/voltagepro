//
//  ListVic5minViewController.m
//  SparkMe!
//
//  Created by Hung on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "List5minViewController.h"
#import "Chart30minViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "CustomCell5.h"

@interface List5minViewController ()

@end

@implementation List5minViewController

@synthesize  dbPathCache, fileMgr, nem5min, stateURL, tableViewLabel, components, dateLastUpdated, mytableView, stateSelected, segVal, priceArray, priceStats, timeArray, demandArray, priceArrayRaw, timeArrayRaw, demandArrayRaw, minPrice, maxPrice, avgPrice;

//scroll to middle to trade and PD region

-(IBAction)scrollTableView:(id)sender{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArray count]-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArrayRaw count]-1 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
}


-(void)scrollToCurrentPeriod{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArray count]-1 inSection:0];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArrayRaw count]-1 inSection:0];
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
            
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5NSW1.csv";
            NSLog(@"NSW pressed");
            stateSelected=@"NSW";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            
            break;
        case 1:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5QLD1.csv";
            NSLog(@"QLD pressed");
            stateSelected=@"QLD";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            break;
        case 2:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5SA1.csv";
            NSLog(@"SA pressed");
            stateSelected=@"SA";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            break;
        case 3:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5TAS1.csv";
            NSLog(@"TAS pressed");
            stateSelected=@"TAS";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
            break;
        case 4:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5VIC1.csv";
            NSLog(@"VIC pressed");
            stateSelected=@"VIC";
            [self viewDidLoad];
            //            [self.mytableView reloadData];
            //            [self.mytableView setContentOffset:CGPointZero animated:YES];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
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
        
        //
        //    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view  animated:YES];
        //    hud.labelText=@"Loading";
        
        [self loadPart1];
        
    }
    
}





- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}

- (void)loadPart2 {
    
    //===========
    
    
    NSDictionary *headers = @{ @"origin": @"http://aemo.com.au",
                               
                               @"content-type": @"application/json",
                               
                               @"accept": @"*/*",
                               
                               @"referer": @"http://aemo.com.au/aemo/apps/visualisations/elec-priceanddemand.html",
                               
                               @"accept-encoding": @"gzip, deflate",
                               
                               @"accept-language": @"en-US,en;q=0.8",
                               
                               @"cache-control": @"no-cache"};
    
    NSDictionary *parameters = @{ @"timeScale": @[ @"5MIN" ] };
    
    
    
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
                                                        
                                                        
                                                        //                                                        subset the jsonArray be desired region
                                                        
                                                        
                                                        
                                                        priceArrayRaw = [[NSMutableArray alloc] init];
                                                        timeArrayRaw = [[NSMutableArray alloc] init];
                                                        demandArrayRaw = [[NSMutableArray alloc] init];
                                                        
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
                                                                
                                                                // NSLog(@"date value is %@", dTrim);
                                                                //NSLog(@"new date value is %@", [dateFormatTrim stringFromDate:dTrim]);
                                                                
                                                                // NSLog(@"new date value is %i, %@, %@", i, [dateFormatTrim stringFromDate:dTrim], [[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]);
                                                                
                                                                [timeArrayRaw addObject:[dateFormatTrim stringFromDate:dTrim]];
                                                                [priceArrayRaw addObject:rrpNum];
                                                                [demandArrayRaw addObject:demandNum];
                                                                
                                                                
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
                                                        
                                                        priceStats.text=[NSString stringWithFormat:@"Price: Min %@, Max %@, Avg %@",[formatter stringFromNumber:minPrice],[formatter stringFromNumber:maxPrice],[formatter stringFromNumber:avgPrice]];
                                                        
                                                        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
                                                        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                                        
                                                        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
                                                        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
                                                        
                                                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                        [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
                                                        
                                                        dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayRaw objectAtIndex:[timeArrayRaw count]-1]]]];
                                                        
                                                        [MBProgressHUD hideHUDForView:self.view  animated:YES];
                                                        
                                                    });
                                                    
                                                    
                                                }];
    
    [dataTask resume];
    
    //
    //
    //    if(segVal.selectedSegmentIndex==0){
    //        stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5NSW1.csv";
    //    }
    //
    //
    //
    //
    //
    ////    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:stateURL]
    ////                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    ////
    ////
    ////    NSHTTPURLResponse *response;
    ////    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    ////    if( [response respondsToSelector:@selector( allHeaderFields )] )
    ////    {
    ////        NSDictionary *metaData = [response allHeaderFields];
    ////
    ////
    ////        NSString *lastModifiedString = [metaData objectForKey:@"Last-Modified"];  //get
    ////
    ////
    ////
    ////        //        NSLog(@"Online Last Modified : %@", [lastModifiedString description]);
    ////
    ////        //        determine date and time of file
    ////
    ////        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    ////
    ////        NSTimeZone *est = [NSTimeZone timeZoneWithName:@"Australia/Queensland"];
    ////        [dateFormatter setTimeZone:est];
    ////        [dateFormatter setDateFormat:@"EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss zzz"];
    ////
    ////        NSDate *date_www = [dateFormatter dateFromString:lastModifiedString];
    ////        NSLog(@"Date in AEST format: %@", [dateFormatter stringFromDate:date_www]);
    ////
    ////        dateLastUpdated.text = [NSString stringWithFormat:@"Updated: %@", [dateFormatter stringFromDate:date_www]];
    ////
    ////        //        for (id key in metaData) {
    ////        //            NSLog(@"key: %@, value: %@ \n", key, [metaData objectForKey:key]);
    ////        //        }
    ////    }
    //
    //
    //    // --- check to see if permits db exists in documents directory
    //    fileMgr = [NSFileManager defaultManager];
    //    // location changed from documents directory to caches directory to confirm with apple requirements
    //    dbPathCache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"GRAPH_5.csv"];
    //
    //    //    hud.labelText=@"Downloading";
    //
    //    NSData *fetchedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stateURL]];
    //
    //
    //
    //    //copy zip file
    //
    //    [fetchedData writeToFile:dbPathCache atomically:YES];
    //
    //    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCache encoding:NSUTF8StringEncoding error:nil];
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    //    trim white space
    //    NSString *dataStrStripped2 = [dataStrStripped stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //
    //    //    NSLog(@"%@", dataStrStripped2);
    //
    //
    //    nem5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    //
    //
    //    //    vic5min = [dataStr componentsSeparatedByString: @","];
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
    //        timeArray = [[NSMutableArray alloc] init];
    //        demandArray = [[NSMutableArray alloc] init];
    //
    //
    //    double minPrice = 0, maxPrice = 0, minDemand = 0, maxDemand = 0;
    //
    //    for(int i=0; i<[nem5min count]; i++){
    //        if(i==0||[[nem5min objectAtIndex:i] isEqualToString:@""]){
    //            continue;
    //        }
    //
    //
    //
    //        components = [[nem5min objectAtIndex:i] componentsSeparatedByString:@","];
    //
    //        NSString *dateStrNEM = [components objectAtIndex:1];
    //        NSDate *dTrim = [dtF dateFromString:dateStrNEM];
    //
    //
    ////        NSString *rows = [NSString stringWithFormat:@"  %@         %10.2f          %9.5f", [dateFormatTrim stringFromDate:dTrim], [[components objectAtIndex:2] floatValue], [[components objectAtIndex:3] floatValue]];
    ////
    ////        [tableViewLabel addObject:rows];
    ////
    ////        [priceArray addObject:[components objectAtIndex:3]];
    //
    //
    //        NSString *timeStr = [dateFormatTrim stringFromDate:dTrim];
    //        NSString *demand = [NSString stringWithFormat:@"%.2f", [[components objectAtIndex:2] floatValue]];
    //        NSString *price = [NSString stringWithFormat:@"%.5f", [[components objectAtIndex:3] floatValue]];
    //
    //
    //        [demandArray addObject:demand];
    //        [priceArray addObject:price];
    //        [timeArray addObject:timeStr];
    //
    //
    //
    //        double curPrice = [[components objectAtIndex:3] floatValue];
    //        double curDemand = [[components objectAtIndex:2] floatValue];
    //
    //        if(i==1) {
    //
    //            minPrice = curPrice;
    //            minDemand = curDemand;
    //
    //        }
    //
    //        if (curPrice < minPrice)
    //            minPrice = curPrice;
    //        else if (curPrice > maxPrice)
    //            maxPrice = curPrice;
    //
    //        if (curDemand < minDemand)
    //            minDemand = curDemand;
    //        else if (curDemand > maxDemand)
    //            maxDemand = curDemand;
    //
    //
    //
    //
    //
    //        //        NSLog(@"state: %@  Date time: %@  Demand: %@  Price: %@", [components objectAtIndex:0], [components objectAtIndex:1], [components objectAtIndex:2], [components objectAtIndex:3]);
    //        //
    //        //        NSLog(@"%@", tableViewLabel);
    //    }
    //
    //    //    hud.labelText=@"Updating";
    //
    //    //        get NEM time string
    //
    //    NSString *dateNEMPeriod = [[[nem5min objectAtIndex:288] componentsSeparatedByString:@","] objectAtIndex:1];
    //    NSDate *dNEMTrim = [dtF dateFromString:dateNEMPeriod];
    //
    //    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //    //        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    //    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    //    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    //    //        [dateFormat setTimeZone:timeZone];
    ////
    ////    NSString *st = [dateFormat stringFromDate:d];
    ////    NSLog(@"%@",st);
    //
    //    NSLog(@"NEM Time is %@", dNEMTrim);
    //
    //    dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:dNEMTrim]];
    //
    //
    //
    //    //        NSNumber* minPrice = [priceArray valueForKeyPath:@"@min.self"];
    //    //        NSNumber* maxPrice = [priceArray valueForKeyPath:@"@max.self"];
    //    NSNumber* avgPrice = [priceArray valueForKeyPath:@"@avg.self"];
    //
    //
    //    priceStats.text=[NSString stringWithFormat:@"Price: Min %.5f, Max %.5f, Avg %.5f",minPrice,maxPrice,[avgPrice floatValue]];
    
    //    [self reloadData];
    
    //    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
}






- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    priceArray=nil;
    timeArray=nil;
    demandArray=nil;
    timeArrayRaw=nil;
    demandArrayRaw=nil;
    priceArrayRaw=nil;
    
    
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
    //    return [timeArray count];
    NSLog(@"Count of time array is %lu", (unsigned long)[timeArrayRaw count]);
    
    return [timeArrayRaw count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CustomCell5";
    CustomCell5 *cell = (CustomCell5 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"CustomCell5" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (CustomCell5 *) currentObject;
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
    //    cell.backgroundColor = [UIColor greenColor];
    //    tableView.backgroundColor = [UIColor greenColor];
    
    //    cell.dateLabel.text=[timeArray objectAtIndex:indexPath.row];
    //    cell.demandLabel.text=[demandArray objectAtIndex:indexPath.row];
    //    cell.priceLabel.text=[priceArray objectAtIndex:indexPath.row];
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    cell.dateLabel.text=[timeArrayRaw objectAtIndex:indexPath.row];
    cell.demandLabel.text=[formatter stringFromNumber:[demandArrayRaw objectAtIndex:indexPath.row]];
    cell.priceLabel.text=[formatter stringFromNumber:[priceArrayRaw objectAtIndex:indexPath.row]];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell5 *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
        //        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else {[cell setBackgroundColor:[UIColor clearColor]];
        //        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    
    
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
    
    
    if ([[segue identifier] isEqualToString:@"pushChart5"]) {
        Chart30minViewController *Chart5minVC = [segue destinationViewController];
        
        if(segVal.selectedSegmentIndex==0){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5NSW1.gif";
            Chart5minVC.selState=@"NSW";
        }
        
        if([stateSelected isEqual: @"NSW"]){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5NSW1.gif";
            Chart5minVC.selState=stateSelected;
        }
        else if ([stateSelected isEqual: @"QLD"]){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5QLD1.gif";
            Chart5minVC.selState=stateSelected;
        }
        else if ([stateSelected isEqual: @"SA"]){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5SA1.gif";
            Chart5minVC.selState=stateSelected;
        }
        else if ([stateSelected isEqual: @"TAS"]){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5TAS1.gif";
            Chart5minVC.selState=stateSelected;
        }
        else if ([stateSelected isEqual: @"VIC"]){
            Chart5minVC.stateChartURL=@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5VIC1.gif";
            Chart5minVC.selState=stateSelected;
        }
        
        Chart5minVC.hidesBottomBarWhenPushed = YES;
        
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

//- (void) viewWillAppear:(BOOL)animated
//{
//
//    [self.navigationController setToolbarHidden:NO animated:YES];
//    
//    [super viewWillAppear:animated];
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//
//{
//    
//
//    [self.navigationController setToolbarHidden:YES animated:YES];
//    [super viewWillDisappear:animated];
//}

@end
