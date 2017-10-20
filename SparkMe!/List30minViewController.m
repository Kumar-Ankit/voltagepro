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
#import "VPDataManager.h"
#import "Utility.h"

@interface List30minViewController ()
@property (nonatomic, strong) NSString *activeRegion;
@end

@implementation List30minViewController

@synthesize  dbPathCache, fileMgr, nem5min, stateURL, tableViewLabel, components, dateLastUpdated, mytableView, stateSelected, segVal, priceArray, demandArray, settingsLabel, timeArray, typeArray, priceArrayRaw, timeArrayRaw, demandArrayRaw, minPrice, maxPrice, avgPrice, typeArrayRaw;


-(IBAction)scrollTableView:(id)sender{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:55 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(void)scrollToCurrentPeriod{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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

    switch (sender.selectedSegmentIndex)
    {
        case 0:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30NSW1.csv";
            NSLog(@"NSW pressed");
            stateSelected=@"NSW";
            self.activeRegion = @"NSW1";
            [self viewDidLoad];
            break;
            
        case 1:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30QLD1.csv";
            NSLog(@"QLD pressed");
            stateSelected=@"QLD";
            self.activeRegion = @"QLD1";
            [self viewDidLoad];
            break;
            
        case 2:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30SA1.csv";
            NSLog(@"SA pressed");
            stateSelected=@"SA";
            self.activeRegion = @"SA1";
            [self viewDidLoad];
            break;
            
        case 3:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30TAS1.csv";
            NSLog(@"TAS pressed");
            stateSelected=@"TAS";
            self.activeRegion = @"TAS1";
            [self viewDidLoad];
            break;
            
        case 4:
            stateURL =@"http://www.nemweb.com.au/mms.GRAPHS/GRAPHS/GRAPH_30VIC1.csv";
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
    
    // this is default pre-selected region
    if (self.activeRegion == nil) {
        self.activeRegion = @"NSW1";
    }
    
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
        [alertNoInternet show];
    } else {
        NSLog(@"There IS internet connection");
        [self loadPart1];
    }
}

- (void)refreshData{
    [super refreshData];
    [self refreshData:nil];
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
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    if(DateLastFile==NULL || ([DateLastFileAdj compare:dateNow]==NSOrderedAscending) || jsonArray == nil || [jsonArray count] == 0)
    {
        NSLog(@"Current time is greater than ADJ time - PERFORM WEB QUERY");
        [self loadPart2_www];
    }
    else{
        NSLog(@"Current time is less than ADJ time - USE LOCAL FILE");
        [self loadPart2_local];
    }
}

- (void)processData:(NSDictionary *)response withError:(NSError *)error
{
    [Utility hideHUDForView:self.view];
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        NSLog(@"This is the response!!! %@", httpResponse);
        
        NSArray *jsonArray = [response objectForKey:@"5MIN"];
        
        // save the array to file
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.csv"];
        
        [jsonArray writeToFile:dbPathCache atomically:YES];
        
        priceArrayRaw = [[NSMutableArray alloc] init];
        timeArrayRaw = [[NSMutableArray alloc] init];
        demandArrayRaw = [[NSMutableArray alloc] init];
        typeArrayRaw = [[NSMutableArray alloc] init];
        
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
                
                NSString *typeStr = nil;
                
                if ([[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"]){
                    typeStr = @"TRADE";
                } else {
                    typeStr = @"PD";
                }
                
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
    }
    
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
}

-(void) loadPart2_www{
    __weak typeof(self) weakSelf = self;
    NSDictionary *parameters = @{@"timeScale":@[@"30MIN"]};
    [[VPDataManager sharedManager] fetchAEMOData:parameters completion:^(NSDictionary *response, NSError *error) {
        [weakSelf processData:response withError:error];
    }];
}

-(void) loadPart2_local{
    
    fileMgr = [NSFileManager defaultManager];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dbPathCache = [documentsDirectory stringByAppendingPathComponent:@"GRAPH_30.CSV"];
    
    NSArray *jsonArray = [NSArray arrayWithContentsOfFile:dbPathCache];
    
    priceArrayRaw = [[NSMutableArray alloc] init];
    timeArrayRaw = [[NSMutableArray alloc] init];
    demandArrayRaw = [[NSMutableArray alloc] init];
    typeArrayRaw = [[NSMutableArray alloc] init];
    
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
            
            NSString *typeStr = nil;
            
            if ([[[jsonArray  objectAtIndex:i] objectForKey:@"PERIODTYPE"] isEqualToString:@"ACTUAL"]){
                typeStr = @"TRADE";
            } else {
                typeStr = @"PD";
            }
            
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
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm zzz"];
    
    settingsLabel.text=[NSString stringWithFormat:@"Red Highlight: Demand>=%.0f OR Price>=%.0f", [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"],[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
    
    dateLastUpdated.text= [NSString stringWithFormat:@"NEM Period: %@", [dateFormat stringFromDate:[dateFormatTrim dateFromString:[timeArrayRaw objectAtIndex:47]]]];
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
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
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:2];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    cell.dateLabel.text=[timeArrayRaw objectAtIndex:indexPath.row];
    cell.demandLabel.text=[formatter stringFromNumber:[demandArrayRaw objectAtIndex:indexPath.row]];
    cell.priceLabel.text=[formatter stringFromNumber:[priceArrayRaw objectAtIndex:indexPath.row]];
    cell.typeLabel.text=[typeArrayRaw objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell30 *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row % 2){
        [cell setBackgroundColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1]];
    }
    else [cell setBackgroundColor:[UIColor clearColor]];
    
    if(([[demandArrayRaw objectAtIndex:indexPath.row] floatValue] >= [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"])  ||
       ([[priceArrayRaw objectAtIndex:indexPath.row] floatValue] >= [[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]) ||
       ([[priceArrayRaw objectAtIndex:indexPath.row] floatValue] < 0))
    {
        cell.dateLabel.textColor = [UIColor redColor];
        cell.demandLabel.textColor = [UIColor redColor];
        cell.priceLabel.textColor = [UIColor redColor];
        cell.typeLabel.textColor = [UIColor redColor];
    }
    else {
        cell.dateLabel.textColor = [UIColor blackColor];
        cell.demandLabel.textColor = [UIColor blackColor];
        cell.priceLabel.textColor = [UIColor blackColor];
        cell.typeLabel.textColor = [UIColor blackColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 21;
}

#pragma mark - Table view delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSString *chartURL = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/priceanddemand_30min_chart.php?region=%@",_activeRegion];

    if ([[segue identifier] isEqualToString:@"pushChart3"]) {
        Chart30minViewController *Chart30minVC = [segue destinationViewController];
        Chart30minVC.chartURLStr = chartURL;
        
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return (UIInterfaceOrientationMaskPortrait);
}
@end
