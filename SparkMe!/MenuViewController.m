//
//  MenuViewController.m
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "List30minViewController.h"
#import "List5minViewController.h"
#import "Reachability.h"
#import "CompanyViewController.h"
#import "NotificationSettingsController.h"
#import "TFHpple.h"
#import "Utility.h"
#import "VPPASAChartsController.h"
//#import "UAPush.h"
#import "UAPushSettingsViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize phanalytics, sparky, marketSnapshot, tradingData, last24Data, interConnect, marketNotice, generatorLabel, pushSettings, data5minPD, blurView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (IBAction)logoPressed:(id)sender{
    
    [self performSegueWithIdentifier:@"toGame" sender:self];
    
}

- (IBAction)pushNotificationTap:(id)sender {
    NotificationSettingsController *root = [[NotificationSettingsController alloc] initWithStyle:UITableViewStyleGrouped];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:root]
                       animated:YES
                     completion:NULL];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Utility registerForPushNotifications];

    
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
        NSLog(@"Version is 6.0 or greater, set atIndex to 1");
        
        gradIndex = 1;
        
    } else {
        NSLog(@"Version is less than 6.0, set atIndex to 0");
        
        gradIndex = 0;
        
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    
    blurView.translucentAlpha = 0.65;
    blurView.translucentStyle = UIBarStyleDefault;
    blurView.translucentTintColor = [UIColor clearColor];
    blurView.backgroundColor = [UIColor clearColor];
    //sparkyLogo.font=[UIFont fontWithName:@"Sansation" size:40.0];
    
    //        phanalytics.titleLabel.text=@"By Phanalyics";
    sparky.font=[UIFont fontWithName:@"Sansation" size:40.0];
   
    
    phanalytics.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18.0];

    
    
    [[NSUserDefaults standardUserDefaults] setDouble:300  forKey:@"myMaxPrice"];
    [[NSUserDefaults standardUserDefaults] setDouble:15000  forKey:@"myMaxDemand"];
    
    
    //    if price alerts flag is set to 1, then make icon visible, else make it invisible and ensure that push is set to off
    
    //    [[marketSnapshot layer] insertSublayer:gradient atIndex:gradIndex];
    marketSnapshot.layer.cornerRadius = 8.0f;
    marketSnapshot.layer.borderWidth = 1.0f;
    marketSnapshot.layer.borderColor = [UIColor lightGrayColor].CGColor;
   // [marketSnapshot setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    
    //    [[interConnect layer] insertSublayer:gradient3 atIndex:gradIndex];
    interConnect.layer.cornerRadius = 8.0f;
    interConnect.layer.borderWidth = 1.0f;
    interConnect.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[interConnect setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    
    
    //    [[tradingData layer] insertSublayer:gradient1 atIndex:gradIndex];
    tradingData.layer.cornerRadius = 8.0f;
    tradingData.layer.borderWidth = 1.0f;
    tradingData.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //    [[last24Data layer] insertSublayer:gradient2 atIndex:gradIndex];
    last24Data.layer.cornerRadius = 8.0f;
    last24Data.layer.borderWidth = 1.0f;
    last24Data.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //    [[data5minPD layer] insertSublayer:gradient6 atIndex:gradIndex];
    data5minPD.layer.cornerRadius = 8.0f;
    data5minPD.layer.borderWidth = 1.0f;
    data5minPD.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _buttonPASA.layer.cornerRadius = 8.0f;
    _buttonPASA.layer.borderWidth = 1.0f;
    _buttonPASA.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    //    [[marketNotice layer] insertSublayer:gradient4 atIndex:gradIndex];
    marketNotice.layer.cornerRadius = 8.0f;
    marketNotice.layer.borderWidth = 1.0f;
    marketNotice.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[marketNotice setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    
    //    [[generatorLabel layer] insertSublayer:gradient5 atIndex:gradIndex];
    generatorLabel.layer.cornerRadius = 8.0f;
    generatorLabel.layer.borderWidth = 1.0f;
    generatorLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //[generatorLabel setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    
    
    
    
    
    //}
    //
    //-(void)viewDidAppear:(BOOL)animated{
    
    
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
        
        
        //        NSString *wepiTicker = [NSString stringWithFormat:@"Welcome to SPARKY PRO...Future News, Updates and Announcements will be displayed here..."];
        NSString *wepiTicker = [NSString stringWithFormat:@"SPARKY PRO IS NOW VOLTAGE PRO - SPREAD THE WORD!"];
        
        NSArray *tickerStrings = [NSArray arrayWithObjects:wepiTicker, nil];
        
        if(floor(NSFoundationVersionNumber)<=NSFoundationVersionNumber_iOS_6_1){
            //        load resources for ios6
            ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
            
        } else {
            //        load resources for ios7
            
            ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(0, 20, 320, 20)];
            [ticker setBackgroundColor:[UIColor clearColor]];
            
        }
        
        
        
        
        
        
        [ticker setDirection:JHTickerDirectionLTR];
        [ticker setTickerStrings:tickerStrings];
        [ticker setTickerSpeed:60.0f];
        [ticker start];
        
        [self.view addSubview:ticker];
        //
        //
        //        NSDate *wepiDateChk = [[NSUserDefaults standardUserDefaults] objectForKey:@"wepiDateKey"];
        //        NSString *wepiSaved = [[NSUserDefaults standardUserDefaults]
        //                               stringForKey:@"wepiPrices"];
        //
        //        NSDate *curDate = [NSDate date];
        //
        //        NSLog(@"Current Date time %@",curDate);
        //        NSLog(@"wepi Date chk %@",wepiDateChk);
        //
        //        NSComparisonResult result= [curDate compare:wepiDateChk];
        //
        //
        //        //        check if wepiDateChk is less than current date, then load array to update data
        //        if(result == NSOrderedDescending || wepiSaved==nil)  {
        //
        //            NSLog(@"Curent Date is greater than wepiDateChk, so need refresh of data");
        //
        //            [self loadPart1];
        //
        //        }
        //
        //        //        else scrape from d-Cypha trade website
        //
        //        else {
        //
        //
        //            NSLog(@"Curent Date is less than wepiDateChk, so don't update wepi Data");
        //
        //            //            //            get string
        //            //            NSString *wepiSaved = [[NSUserDefaults standardUserDefaults]
        //            //                                   stringForKey:@"wepiPrices"];
        //
        //            NSArray *tickerStrings = [NSArray arrayWithObjects:wepiSaved, nil];
        //
        //            ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        //            [ticker setDirection:JHTickerDirectionLTR];
        //            [ticker setTickerStrings:tickerStrings];
        //            [ticker setTickerSpeed:60.0f];
        //            [ticker start];
        //
        //            [self.view addSubview:ticker];
        //
        //
        //
        //        }
        //
        //
        //
        //        //        phanalytics.layer.shadowColor = [[UIColor orangeColor] CGColor];
        //        //        phanalytics.layer.shadowRadius = 20.0;
        //        //        phanalytics.layer.shadowOpacity = 0.5;
        //        //        phanalytics.layer.masksToBounds = NO;
        //
        //
        
    }
}


//- (void)loadPart1 {
//    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
//    hudUpdateUIView.labelText = @"Loading...";
//
//    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
//}
//
//
//- (void)loadPart2 {
//

//
//
//
//
//    //        below bit of code pulls out WEPI data from d-Cypha
//
//    NSData *dCypha = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d-cyphatrade.com.au/"]];
//
//    // 2
//    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:dCypha];
//
//    // 3
//    NSString *htmlXpathQueryString = @"//h3/span | //table[@class='home-prices-wepi']//td | //table[@id='home-prices-legend']//td";
//    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
//
//    // 4
//    NSMutableArray *wepiPrices = [[NSMutableArray alloc] init];
//
//    for (TFHppleElement *element in htmlNodes) {
//        // 5
//        if([[element firstChild] content]!=nil){
//
//            [wepiPrices addObject:[[element firstChild] content]];
//        }
//
//        // 7
//        //        tutorial.url = [element objectForKey:@"href"];
//    }
//
//    //    NSLog(@"%@",nemFiles);
//    //
//    //    NSLog(@"Items in file list array : %i", [nemFiles count]);
//
//
//    //    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
//
//    NSLog(@"Results in array : %@", wepiPrices);
//
//    NSString *wepiTicker = [NSString stringWithFormat:@"d-CYPHA WEPI %@: NSW %@...QLD %@...SA %@...VIC %@...BASE FUTURES (IMPLIED) %@: NSW %@...QLD %@...SA %@...VIC %@...%@: NSW %@...QLD %@...SA %@...VIC %@...%@: NSW %@...QLD %@...SA %@...VIC %@..."
//                            ,[wepiPrices objectAtIndex:0]
//                            ,[wepiPrices objectAtIndex:1]
//                            ,[wepiPrices objectAtIndex:2]
//                            ,[wepiPrices objectAtIndex:3]
//                            ,[wepiPrices objectAtIndex:4]
//
//                            ,[wepiPrices objectAtIndex:6]
//                            ,[wepiPrices objectAtIndex:7]
//                            ,[wepiPrices objectAtIndex:8]
//                            ,[wepiPrices objectAtIndex:9]
//                            ,[wepiPrices objectAtIndex:10]
//
//                            ,[wepiPrices objectAtIndex:11]
//                            ,[wepiPrices objectAtIndex:12]
//                            ,[wepiPrices objectAtIndex:13]
//                            ,[wepiPrices objectAtIndex:14]
//                            ,[wepiPrices objectAtIndex:15]
//
//                            ,[wepiPrices objectAtIndex:16]
//                            ,[wepiPrices objectAtIndex:17]
//                            ,[wepiPrices objectAtIndex:18]
//                            ,[wepiPrices objectAtIndex:19]
//                            ,[wepiPrices objectAtIndex:20]
//
//                            ];
//
//
//
//    NSArray *tickerStrings = [NSArray arrayWithObjects:wepiTicker, nil];
//
//    ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    [ticker setDirection:JHTickerDirectionLTR];
//    [ticker setTickerStrings:tickerStrings];
//    [ticker setTickerSpeed:60.0f];
//    [ticker start];
//
//    [self.view addSubview:ticker];
//
//    //    perform date stamp, trim time, then plus 24hrs to get to next day so update it only scrapes once a day
//    NSDate *dateNow = [NSDate date];
//    //    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
//    //    NSCalendar* calendar = [NSCalendar currentCalendar];
//    //    NSDateComponents* components = [calendar components:flags fromDate:dateNow];
//
//    //    NSDate* dateChk = [[calendar dateFromComponents:components]dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
//
//    //    decided to add 6hrs to last check date.
//    NSDate* dateChk = [dateNow dateByAddingTimeInterval:60*60*6];
//    //    adds 24hrs to truncated date without time portion
//
//    NSLog(@"Current Date time %@",dateNow);
//    NSLog(@"Current Date chk saved %@",dateChk);
//
//
//    [[NSUserDefaults standardUserDefaults] setObject:dateChk forKey:@"wepiDateKey"];
//
//    //    save wepiTicker string also
//    [[NSUserDefaults standardUserDefaults] setObject:wepiTicker forKey:@"wepiPrices"];
//
//    [MBProgressHUD hideHUDForView:self.view  animated:YES];
//
//}


- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pasaTapped:(id)sender {
    VPPASAChartsController *charts = [[VPPASAChartsController alloc] initFromNib];
    [self.navigationController pushViewController:charts animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"CompanyView"]) {
        CompanyViewController *CompanyVC = [segue destinationViewController];
        
        CompanyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController setToolbarHidden:YES animated:NO];
        
    }
    
    if ([[segue identifier] isEqualToString:@"push30"]) {
        
        [self.navigationController setToolbarHidden:NO animated:NO];
        
    }
    
    
    if ([[segue identifier] isEqualToString:@"push5"]) {
        
        
        [self.navigationController setToolbarHidden:NO animated:NO];
        
    }
    
    if ([[segue identifier] isEqualToString:@"market"]) {
        
        
        [self.navigationController setToolbarHidden:YES animated:NO];
        
    }
    
    if ([[segue identifier] isEqualToString:@"toIC"]) {
        
        
        [self.navigationController setToolbarHidden:YES animated:NO];
        
    }
    
    if ([[segue identifier] isEqualToString:@"toSubMenu"]) {
        
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    if ([[segue identifier] isEqualToString:@"push5PD"]) {
                
        [self.navigationController setToolbarHidden:YES animated:NO];
        
    }
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated

{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

-(BOOL) shouldAutorotate {
    return NO;
}


@end
