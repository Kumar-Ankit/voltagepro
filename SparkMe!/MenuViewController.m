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
    
    
    //    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"PriceAlertFlag"] isEqualToString:@"1"]){
    //        data5minPD.hidden = NO;
    //        tradingData.hidden = NO;
    //        last24Data.hidden = NO;
    //        marketNotice.hidden = NO;
    //        generatorLabel.hidden = NO;
    //
    //        pushSettings.hidden = NO;
    //
    //        if([UAPush shared].pushEnabled==NO){
    //
    //            [UAPush shared].pushEnabled = YES;
    //
    //            [[UAPush shared] updateRegistration];
    //        }
    //
    //
    //
    //    } else {
    //
    ////        hide the icon, and turn off push at urban airship so the user no longer receives notifications although they may still have registered for channels
    //
    //        data5minPD.hidden = YES;
    //        tradingData.hidden = YES;
    //        last24Data.hidden = YES;
    //        marketNotice.hidden = YES;
    //        generatorLabel.hidden = YES;
    //
    //        pushSettings.hidden = YES;
    //
    //        if([UAPush shared].pushEnabled==YES){
    //
    //            [UAPush shared].pushEnabled = NO;
    //
    //            [[UAPush shared] updateRegistration];
    //        }
    //
    //
    //        CGRect marketBtFrame = marketSnapshot.frame;
    //        marketBtFrame.origin.x = 87;
    //        marketBtFrame.origin.y = 370;
    //        marketSnapshot.frame = marketBtFrame;
    //
    //
    //        CGRect icBtFrame = interConnect.frame;
    //        icBtFrame.origin.x = 87;
    //        icBtFrame.origin.y = 300;
    //        interConnect.frame = icBtFrame;
    //
    //
    //
    //
    //    }
    
    
    
    //set button colours and gradient
    //        UIColor *yellowOp = [UIColor yellowColor];
    //        UIColor *orangeOp = [UIColor orangeColor];
    
    
    //    UIColor *DarkGreyOp = [UIColor whiteColor];
    //    UIColor *LightGreyOp = [UIColor lightGrayColor];
    //
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = [[marketSnapshot layer] bounds];
    //    gradient.cornerRadius = 8;
    //    gradient.colors = [NSArray arrayWithObjects:
    //                       (id)DarkGreyOp.CGColor,
    //                       (id)LightGreyOp.CGColor,
    //                       nil];
    //    gradient.locations = [NSArray arrayWithObjects:
    //                          [NSNumber numberWithFloat:0.0f],
    //                          [NSNumber numberWithFloat:0.7],
    //                          nil];
    //
    //    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    //    gradient1.frame = [[tradingData layer] bounds];
    //    gradient1.cornerRadius = 8;
    //    gradient1.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient1.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    //
    //    CAGradientLayer *gradient2 = [CAGradientLayer layer];
    //    gradient2.frame = [[last24Data layer] bounds];
    //    gradient2.cornerRadius = 8;
    //    gradient2.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient2.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    //
    //    CAGradientLayer *gradient3 = [CAGradientLayer layer];
    //    gradient3.frame = [[interConnect layer] bounds];
    //    gradient3.cornerRadius = 8;
    //    gradient3.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient3.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    //
    //    CAGradientLayer *gradient4 = [CAGradientLayer layer];
    //    gradient4.frame = [[marketNotice layer] bounds];
    //    gradient4.cornerRadius = 8;
    //    gradient4.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient4.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    //
    //
    //
    //    CAGradientLayer *gradient5 = [CAGradientLayer layer];
    //    gradient5.frame = [[generatorLabel layer] bounds];
    //    gradient5.cornerRadius = 8;
    //    gradient5.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient5.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    //
    //    CAGradientLayer *gradient6 = [CAGradientLayer layer];
    //    gradient6.frame = [[data5minPD layer] bounds];
    //    gradient6.cornerRadius = 8;
    //    gradient6.colors = [NSArray arrayWithObjects:
    //                        (id)DarkGreyOp.CGColor,
    //                        (id)LightGreyOp.CGColor,
    //                        nil];
    //    gradient6.locations = [NSArray arrayWithObjects:
    //                           [NSNumber numberWithFloat:0.0f],
    //                           [NSNumber numberWithFloat:0.7],
    //                           nil];
    
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
        
        //        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        [self.navigationController setToolbarHidden:YES animated:NO];
        
    }
    
    
}

//- (IBAction)goToSubview:(id)sender{
//    
////    SubMenuViewController * viewController = [[SubMenuViewController alloc] initWithNibName:nil bundle:nil];
//    [UIView transitionWithView:self.view.window
//                      duration:1.0f
//                       options:UIViewAnimationOptionTransitionCurlUp
//                    animations:^{
//                        [self performSegueWithIdentifier:@"toSubMenu" sender:self];
//                    }
//                    completion:NULL];
//    
//}



- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated

{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}

-(BOOL) shouldAutorotate {
    return NO;
}


@end
