//
//  ConstraintsViewController.m
//  Sparky
//
//  Created by Hung on 1/12/12.
//
//

#import "ConstraintsViewController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "DispConstraint.h"
#import "CustomCell.h"


@interface ConstraintsViewController ()

@end

@implementation ConstraintsViewController

@synthesize dateLastUpdated, dispCons, tableview2, descLabel, segSection, segConsCond, lhsToMarginalLabel, rhsToComboLabel, alphabetIndexArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (IBAction)segmentControlTap:(UISegmentedControl *)sender{
    
    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            
            NSLog(@"D tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:dIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
            break;
            
            
        case 1:
            
            NSLog(@"F tapped");
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:fIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
        case 2:
            
            NSLog(@"N tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:nIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
            
        case 3:
            
            NSLog(@"Q tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:qIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
        case 4:
            
            NSLog(@"S tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:sIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
        case 5:
            
            NSLog(@"T tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:tIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
        case 6:
            
            NSLog(@"V tapped");
            
            tableview2.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            scrollIndexPath = [NSIndexPath indexPathForRow:vIndex + tableRowIndex inSection:0];
            [tableview2 scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            break;
            
        default:
            break;
            
    }
    
    
}

- (IBAction)segmentConsCondTap:(UISegmentedControl *)sender{
    
    NSLog(@"testing!");
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            
            NSLog(@"All tapped");
            lhsToMarginalLabel.text = @"LHS";
            rhsToComboLabel.text = @"RHS";
            
            [segSection setEnabled:YES];
            segSection.selectedSegmentIndex = 0;
            [self viewDidLoad];
            
            
            break;
            
            
        case 1:
            
            NSLog(@"Binding tapped");
            lhsToMarginalLabel.text = @"Marg. Val.";
            rhsToComboLabel.text = @"LHS = RHS";
            [segSection setEnabled:NO];
            [self viewDidLoad];
            break;
            
        case 2:
            
            NSLog(@"Violated tapped");
            lhsToMarginalLabel.text = @"LHS";
            rhsToComboLabel.text = @"RHS";
            [segSection setEnabled:NO];
            [self viewDidLoad];
            break;
            
        default:
            break;
            
    }
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
        NSLog(@"Version is 6.0 or greater, set atIndex to 1");
        
        gradIndex = 1;
        
    } else {
        NSLog(@"Version is less than 6.0, set atIndex to 0");
        
        gradIndex = 0;
        
    }
    
    //    this exception is for the segment tap so the correct row section is displayed in the right spot
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            // iPhone Classic
            
            tableRowIndex = 5;
        }
        if(result.height == 568)
        {
            // iPhone 5
            
            tableRowIndex = 7;
        }
    }
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
   //UIColor *DarkGreyOp = [UIColor colorWithRed:0.10f green:0.30f blue:0.91f alpha:1];
    //UIColor *LightGreyOp = [UIColor colorWithRed:0.05f green:0.13f blue:0.38f alpha:1];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[descLabel layer] bounds];
    gradient.cornerRadius = 0;
    //gradient.colors = [NSArray arrayWithObjects:
      //                 (id)DarkGreyOp.CGColor,
        //               (id)LightGreyOp.CGColor,
          //             nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.05f],
                          [NSNumber numberWithFloat:0.95f],
                          nil];
    
    //Commented by Ankit on 5thdec2016
    //[[descLabel layer] insertSublayer:gradient atIndex:(int)gradIndex];
    //descLabel.layer.cornerRadius = 0.0f;
    //descLabel.layer.borderWidth = 1.0f;
    //descLabel.layer.borderColor = [UIColor blueColor].CGColor;
    
    //    set selected colour of segment control
    
    //    segSection.segmentedControlStyle = UISegmentedControlStyleBar;
    //
    //    UIColor *newTintColor = [UIColor colorWithRed:30/255.0 green:46/255.0 blue:94/255.0 alpha:1.0];
    //    segSection.tintColor = newTintColor;
    //
    //    UIColor *newSelectedTintColor = [UIColor colorWithRed: 0/255.0 green:175/255.0 blue:0/255.0 alpha:1.0];
    //    [[[segSection subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
    //    segSection.segmentedControlStyle = UISegmentedControlStyleBar;
    //segSection.tintColor = [UIColor colorWithRed:.1 green:.3 blue:.9 alpha:1];
    //    [self.view addSubview:segSection];
    
    
    
    
    [segSection setWidth:41 forSegmentAtIndex:0];
    [segSection setWidth:41 forSegmentAtIndex:1];
    [segSection setWidth:41 forSegmentAtIndex:2];
    [segSection setWidth:41 forSegmentAtIndex:3];
    [segSection setWidth:41 forSegmentAtIndex:4];
    [segSection setWidth:41 forSegmentAtIndex:5];
    [segSection setWidth:41 forSegmentAtIndex:6];
    
    
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
        
        
        NSLog(@"View loaded");
        [self loadPart1_5];
        
        
    }
    
    // Do any additional setup after loading the view.
}


- (void)loadPart1_5 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2_5) withObject:nil afterDelay:0];
}


- (void)loadPart2_5 {
    
    
    
    //    location of renamed file for last Stored
    
    NSString *dbPathCacheLast = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"DISPATCHIS5MIN.CSV"];
    
    
    
    NSString *dataStr = [NSString stringWithContentsOfFile:dbPathCacheLast encoding:NSUTF8StringEncoding error:nil];
    //
    //        NSLog(@"%@", dataStr);
    
    //    NSString *dataStrStripped = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //    trim white space
    
    
    NSString *dataStrStripped2 = [dataStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    NSArray *disp5min = [dataStrStripped2 componentsSeparatedByString:@"\n"];
    
    
    //    vic5min = [dataStr componentsSeparatedByString: @","];
    
    
    //    NSMutableArray *priceArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *regionSumArray = [[NSMutableArray alloc] init];
    //    NSMutableArray *icArray = [[NSMutableArray alloc] init];
    
    dispCons = [[DispConstraint alloc] init];
    dispCons.consId = [[NSMutableArray alloc] init];
    dispCons.rhs = [[NSMutableArray alloc] init];
    dispCons.marginalValue = [[NSMutableArray alloc] init];
    dispCons.genconidEffDate = [[NSMutableArray alloc] init];
    dispCons.lhs = [[NSMutableArray alloc] init];
    
    
    //    extract NEM time from cell in file
    
    
    NSMutableArray *icDateTime = [[NSMutableArray alloc] init];
    
    NSArray *components = [[disp5min objectAtIndex:2] componentsSeparatedByString:@","];
    
    //     NSLog(@"components object contains %@", components);
    
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
    
    
    
    for(NSInteger i=0; i<[disp5min count]; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"PRICE"]){
            
            priceIndex = i;
            break;
            
        }
        
        
    }
    
    
    
    NSLog(@"The value of the price row is %li", (long)priceIndex);
    
    //    to cater for blocked constraints
    
    blockedConsIndex=0;
    
    for(NSInteger i=priceIndex; i<[disp5min count]-2; i++){
        
        NSArray *components1 = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        if([[components1 objectAtIndex:2] isEqualToString:@"BLOCKED_CONSTRAINTS"]){
            
            blockedConsIndex = i;
            break;
            
        }
        
        
    }
    
    
    NSLog(@"The value of the price row is %li", (long)priceIndex);
    NSLog(@"The value of the blocked constraint row is %li", (long)blockedConsIndex);
    
    if(blockedConsIndex==0){
        
        endConsIndex = [disp5min count]-2;
    }else{
        endConsIndex = blockedConsIndex;
    }
    
    NSLog(@"last row is %li", (long)endConsIndex);
    
    for(NSInteger i=priceIndex + 20; i< endConsIndex; i++){
        
        //        NSLog(@"Row number is : %i",i);
        
        NSArray *components = [[disp5min objectAtIndex:i] componentsSeparatedByString:@","];
        
        //        NSLog(@"output %@", components);
        
        //        If All seg tapped
        
        if(segConsCond.selectedSegmentIndex==0){
            [dispCons.consId addObject:[components objectAtIndex:6]];
            [dispCons.rhs addObject:[components objectAtIndex:9]];
            [dispCons.marginalValue addObject:[components objectAtIndex:10]];
            [dispCons.violDegree addObject:[components objectAtIndex:11]];
            [dispCons.lhs addObject:[components objectAtIndex:16]];
            [dispCons.genconidEffDate addObject:[components objectAtIndex:14]];
            
            
        }
        
        //        If Binding seg tapped
        
        if(segConsCond.selectedSegmentIndex==1){
            
            //            Binding occurs when you have non-zero marginal value AND zero violation degree
            
            if([[components objectAtIndex:10] floatValue] != 0 && [[components objectAtIndex:11] floatValue]==0){
                
                [dispCons.consId addObject:[components objectAtIndex:6]];
                [dispCons.rhs addObject:[components objectAtIndex:9]];
                [dispCons.marginalValue addObject:[components objectAtIndex:10]];
                [dispCons.violDegree addObject:[components objectAtIndex:11]];
                [dispCons.lhs addObject:[components objectAtIndex:16]];
                [dispCons.genconidEffDate addObject:[components objectAtIndex:14]];
                
            }
            
            
            
        }
        
        //        If Violated seg tapped
        
        if(segConsCond.selectedSegmentIndex==2){
            
            //            Violated occurs when you have non-zero zero violation degree
            
            if([[components objectAtIndex:11] floatValue]!=0){
                
                [dispCons.consId addObject:[components objectAtIndex:6]];
                [dispCons.rhs addObject:[components objectAtIndex:9]];
                [dispCons.marginalValue addObject:[components objectAtIndex:10]];
                [dispCons.violDegree addObject:[components objectAtIndex:11]];
                [dispCons.lhs addObject:[components objectAtIndex:16]];
                [dispCons.genconidEffDate addObject:[components objectAtIndex:14]];
                
            }
            
            
            
        }
        
        
        
    }
    
    
    //    NSLog(@"%@    %@", dispCons.consId, dispCons.rhs);
    
    //    assign values to fields
    
    
    //    preset all indexes to zero intially
    
    dIndex=0;
    
    NSLog(@"number of rows is %lu", (unsigned long)[dispCons.consId count]);
    
    
    for(NSInteger i=0; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"D"].location == 0){
            
            dIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of F rows is %li", (long)fIndex);
    
    
    fIndex=0;
    
    NSLog(@"number of rows is %lu", (unsigned long)[dispCons.consId count]);
    
    
    for(NSInteger i=0; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"F"].location == 0){
            
            fIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of F rows is %li", (long)fIndex);
    
    nIndex=0;
    
    for(NSInteger i=fIndex; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"N"].location == 0){
            
            nIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of N rows is %li", (long)nIndex);
    
    qIndex=0;
    
    for(NSInteger i=nIndex; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"Q"].location == 0){
            
            qIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of Q rows is %li", (long)qIndex);
    
    sIndex=0;
    
    for(NSInteger i=qIndex; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"S"].location == 0){
            
            sIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of S rows is %li", (long)sIndex);
    
    tIndex=0;
    
    for(NSInteger i=sIndex; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"T"].location == 0){
            
            tIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of T rows is %li", (long)tIndex);
    
    vIndex=0;
    
    for(NSInteger i=tIndex; i<[dispCons.consId count]; i++){
        
        
        if([[dispCons.consId objectAtIndex:i] rangeOfString:@"V"].location == 0){
            
            vIndex = i;
            break;
            
        }
        
        
    }
    
    NSLog(@"number of V rows is %li", (long)vIndex);
    
    ////    add in index bar
    //
    //    if(segConsCond.selectedSegmentIndex==0){
    //
    //        NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
    //        for (int i = 0; i<[dispCons.consId count]; i++) {
    //            NSString *letterString = [[dispCons.consId objectAtIndex:i] substringToIndex:6];
    //            if (![tempFirstLetterArray containsObject:letterString]) {
    //                [tempFirstLetterArray addObject:letterString];
    //            }
    //        }
    //        alphabetIndexArray = tempFirstLetterArray;
    //        tempFirstLetterArray=nil;
    //    } else {
    //
    //     alphabetIndexArray=nil;
    //
    //    }
    
    [tableview2 reloadData];
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    
}


-(BOOL) shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
    //OR return (UIInterfaceOrientationMaskAll);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return alphabetIndexArray;
//}
//
//- (void)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//
//
//    if(segConsCond.selectedSegmentIndex==0){
//
//        for (int i = 0; i< [dispCons.consId count]; i++) {
//
//            NSString *letterString = [[dispCons.consId objectAtIndex:i] substringToIndex:6];
//            if ([letterString isEqualToString:title]) {
//                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//                break;
//            }
//        }
//
//    }
//}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [dispCons.consId count];
    
    //    NSLog(@"number of rows is %lu", (unsigned long)[dispCons.consId count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:nil options:nil];
        
        for(id currentObject in topLevelObjects){
            if ([currentObject isKindOfClass:[UITableViewCell class]]){
                cell = (CustomCell *) currentObject;
                break;
            }
        }
    }
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    NSString *dateStr = [[dispCons.genconidEffDate objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date5min = [dtF dateFromString:dateStr];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"dd-MMM-yyyy"];
    NSString *st = [dateFormat stringFromDate:date5min];
    
    
    cell.consIdLabel.text=[dispCons.consId objectAtIndex:indexPath.row];
    
    
    //    if binding segment selected then set lhs values to become marginal values as well as label
    
    //    if binding selected then
    
    if(segConsCond.selectedSegmentIndex == 1){
        
        //        set lhs value to be marginal value
        
        cell.lhsLabel.text=[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[dispCons.marginalValue objectAtIndex:indexPath.row] floatValue]]];
        
    } else {
        
        //        leave as is
        
        cell.lhsLabel.text=[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[dispCons.lhs objectAtIndex:indexPath.row] floatValue]]];
        
    }
    
    cell.rhsLabel.text=[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[dispCons.rhs objectAtIndex:indexPath.row] floatValue]]];
    
    
    
    
    cell.effDateLabel.text=st;
    
    return cell;
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
