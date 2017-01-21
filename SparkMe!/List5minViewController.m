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
@property (nonatomic, strong) NSString *activeRegion;
@end

@implementation List5minViewController

@synthesize  dbPathCache, fileMgr, nem5min, stateURL, tableViewLabel, components, dateLastUpdated, mytableView, stateSelected, segVal, priceArray, priceStats, timeArray, demandArray, priceArrayRaw, timeArrayRaw, demandArrayRaw, minPrice, maxPrice, avgPrice;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // this is default pre-selected region
    if (self.activeRegion == nil) {
        self.activeRegion = @"NSW1";
    }

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");

        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                  message:@"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        [alertNoInternet show];
    } else {
        [self loadPart1];
    }
}

-(IBAction)scrollTableView:(id)sender{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[timeArrayRaw count]-1 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)scrollToCurrentPeriod{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5NSW1.csv";
            NSLog(@"NSW pressed");
            stateSelected=@"NSW";
            self.activeRegion = @"NSW1";
            [self viewDidLoad];
            break;
            
        case 1:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5QLD1.csv";
            NSLog(@"QLD pressed");
            stateSelected=@"QLD";
            self.activeRegion = @"QLD1";
            [self viewDidLoad];
            break;
            
        case 2:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5SA1.csv";
            NSLog(@"SA pressed");
            stateSelected=@"SA";
            self.activeRegion = @"SA1";
            [self viewDidLoad];
            break;
        case 3:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5TAS1.csv";
            NSLog(@"TAS pressed");
            stateSelected=@"TAS";
            self.activeRegion = @"TAS1";
            [self viewDidLoad];
            break;
            
        case 4:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_5VIC1.csv";
            NSLog(@"VIC pressed");
            stateSelected=@"VIC";
            self.activeRegion = @"VIC1";
            [self viewDidLoad];
            break;
            
        default:
            self.activeRegion = @"NSW1";
            break;
    }
}

-(IBAction)refreshData:(id)sender{
    [self viewDidLoad];
}

- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}

- (void)loadPart2 {
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
                                                        
                                                        priceArrayRaw = [[NSMutableArray alloc] init];
                                                        timeArrayRaw = [[NSMutableArray alloc] init];
                                                        demandArrayRaw = [[NSMutableArray alloc] init];
                                                        
                                                        if(segVal.selectedSegmentIndex==0){
                                                            stateSelected =@"NSW";
                                                        }
                                                        
                                                        NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
                                                        [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dtF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
                                                        
                                                        NSDateFormatter *dateFormatTrim = [[NSDateFormatter alloc] init];
                                                        [dateFormatTrim setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
                                                        [dateFormatTrim setDateFormat:@"dd/MM/yy HH:mm"];
                                                        
                                                        minPrice = 0;
                                                        maxPrice = 0;
                                                        for(int i=0; i<[jsonArray count]; i++){
                                                            
                                                            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"REGIONID"] isEqualToString:[stateSelected stringByAppendingString:@"1"]]) {
                                                                
                                                                // convert crappy dates to normal dates
                                                                
                                                                NSDate *dTrim = [dtF dateFromString:[[jsonArray  objectAtIndex:i] objectForKey:@"SETTLEMENTDATE"]];
                                                                NSNumber *rrpNum = [[jsonArray  objectAtIndex:i] objectForKey:@"RRP"];
                                                                NSNumber *demandNum = [[jsonArray  objectAtIndex:i] objectForKey:@"TOTALDEMAND"];
                                                                
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // Return the number of rows in the section.
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
    if (indexPath.row % 2){
        [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    else {[cell setBackgroundColor:[UIColor clearColor]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 21;
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSString *chartURL = [NSString stringWithFormat:@"http://crimsonbeans.com/cbprojects/hvb/priceanddemand_5min_chart.php?region=%@",_activeRegion];
    
    if ([[segue identifier] isEqualToString:@"pushChart5"]) {
        Chart30minViewController *Chart5minVC = [segue destinationViewController];
        Chart5minVC.chartURLStr = chartURL;
        
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskPortrait);
}


@end
