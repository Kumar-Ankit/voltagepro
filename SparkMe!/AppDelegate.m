//
//  AppDelegate.m
//  SparkMe!
//
//  Created by Hung on 13/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MenuViewController.h"
#import "LoginViewController.h"

#import "TFHpple.h"

#import <Parse/Parse.h>
#import "Utility.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    //  DEVELOPMENT KEYS
    
    //    [Parse setApplicationId:@"VhfiekdcQq0hl0IOyJOWEeYD9O6BxJe7o183VeAd"
    //                 clientKey:@"jYakKwrZCmY0LNLmd9Uisx6ofhHGxfrcAgZoRtFl"];
    
    
    //  PRODUCTION KEYS
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"Vxe7ivXHQduCePmSKJTgsaGnvNLX6NZQUDS6oMw2";
        configuration.clientKey = @"qZ0wNsCq3iWXWeqpKrTpaGdoPUzliQ2UY5Mnrdrd";
        configuration.server = @"http://sparkypro.com.au:1337/parse";
    }]];
    
    //    [Parse setApplicationId:@"Vxe7ivXHQduCePmSKJTgsaGnvNLX6NZQUDS6oMw2"
    //                  clientKey:@"qZ0wNsCq3iWXWeqpKrTpaGdoPUzliQ2UY5Mnrdrd"];
    
    // Register for Push Notitications, if running iOS 8
    
    // add in parse analytics for tracking effect of push notifications
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    
    //Init Airship launch options
    //    UAConfig *config = [UAConfig defaultConfig];
    
    // Create Airship singleton that's used to talk to Urban Airship servers.
    // Please populate AirshipConfig.plist with your info from http://go.urbanairship.com
    //    [UAirship takeOff:config];
    
    
    // Register for notifications
    
    //    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
    //                                         UIRemoteNotificationTypeSound |
    //                                         UIRemoteNotificationTypeAlert );
    
    
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    // Updates the device token and registers the token with UA
    
    NSString *devToken = [NSString stringWithFormat:@"%@", deviceToken];
    
    //    UALOG(@"APN device token: %@", deviceToken);
    
    NSLog(@"Application did register for remote notification, Device Token is %@",deviceToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:devToken forKey:@"UAdevToken"];
    
    [Utility sendTokenToServer:devToken];
    //    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [Utility sendTokenToServer:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
}




//to handle for ios6 orientation

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"application did enter background");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"application will enter foreground");
    
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //    NSLog(@"application did become active");
    //    NSDate *wepiDateChk = [[NSUserDefaults standardUserDefaults] objectForKey:@"wepiDateKey"];
    //    NSString *wepiSaved = [[NSUserDefaults standardUserDefaults]
    //                           stringForKey:@"wepiPrices"];
    //
    //    NSDate *curDate = [NSDate date];
    //
    //    NSLog(@"Current Date time %@",curDate);
    //    NSLog(@"wepi Date chk %@",wepiDateChk);
    //
    //    NSComparisonResult result= [curDate compare:wepiDateChk];
    //
    //
    //    //        check if wepiDateChk is less than current date, then load array to update data
    //    if(result == NSOrderedDescending || wepiSaved==nil)  {
    //
    //        NSLog(@"Curent Date is greater than wepiDateChk, so need refresh of data");
    //
    ////        MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:  animated:YES];
    ////        hudUpdateUIView.labelText = @"Loading...";
    //
    //        //        ticker text, insert here...
    //
    //        NSData *dCypha = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://d-cyphatrade.com.au/"]];
    //
    //        // 2
    //        TFHpple *htmlParser = [TFHpple hppleWithHTMLData:dCypha];
    //
    //        // 3
    //        NSString *htmlXpathQueryString = @"//h3/span | //table[@class='home-prices-wepi']//td | //table[@id='home-prices-legend']//td";
    //        NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    //
    //        // 4
    //        NSMutableArray *wepiPrices = [[NSMutableArray alloc] init];
    //
    //        for (TFHppleElement *element in htmlNodes) {
    //            // 5
    //            if([[element firstChild] content]!=nil){
    //
    //                [wepiPrices addObject:[[element firstChild] content]];
    //            }
    //
    //            // 7
    //            //        tutorial.url = [element objectForKey:@"href"];
    //        }
    //
    //        //    NSLog(@"%@",nemFiles);
    //        //
    //        //    NSLog(@"Items in file list array : %i", [nemFiles count]);
    //
    //
    //        //    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    //
    //        NSLog(@"Results in array : %@", wepiPrices);
    //
    //        NSString *wepiTicker = [NSString stringWithFormat:@"d-CYPHA WEPI %@: NSW %@...QLD %@...SA %@...VIC %@...BASE FUTURES (IMPLIED) %@: NSW %@...QLD %@...SA %@...VIC %@...%@: NSW %@...QLD %@...SA %@...VIC %@...%@: NSW %@...QLD %@...SA %@...VIC %@..."
    //                                ,[wepiPrices objectAtIndex:0]
    //                                ,[wepiPrices objectAtIndex:1]
    //                                ,[wepiPrices objectAtIndex:2]
    //                                ,[wepiPrices objectAtIndex:3]
    //                                ,[wepiPrices objectAtIndex:4]
    //
    //                                ,[wepiPrices objectAtIndex:6]
    //                                ,[wepiPrices objectAtIndex:7]
    //                                ,[wepiPrices objectAtIndex:8]
    //                                ,[wepiPrices objectAtIndex:9]
    //                                ,[wepiPrices objectAtIndex:10]
    //
    //                                ,[wepiPrices objectAtIndex:11]
    //                                ,[wepiPrices objectAtIndex:12]
    //                                ,[wepiPrices objectAtIndex:13]
    //                                ,[wepiPrices objectAtIndex:14]
    //                                ,[wepiPrices objectAtIndex:15]
    //
    //                                ,[wepiPrices objectAtIndex:16]
    //                                ,[wepiPrices objectAtIndex:17]
    //                                ,[wepiPrices objectAtIndex:18]
    //                                ,[wepiPrices objectAtIndex:19]
    //                                ,[wepiPrices objectAtIndex:20]
    //
    //                                ];
    //
    //
    //
    //
    //
    //        //    perform date stamp, trim time, then plus 24hrs to get to next day so update it only scrapes once a day
    //        NSDate *dateNow = [NSDate date];
    //        //    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //        //    NSCalendar* calendar = [NSCalendar currentCalendar];
    //        //    NSDateComponents* components = [calendar components:flags fromDate:dateNow];
    //
    //        //    NSDate* dateChk = [[calendar dateFromComponents:components]dateByAddingTimeInterval:[[NSTimeZone localTimeZone]secondsFromGMT]];
    //
    //        //    decided to add 6hrs to last check date.
    //        NSDate* dateChk = [dateNow dateByAddingTimeInterval:60*60*6];
    //        //    adds 24hrs to truncated date without time portion
    //
    //        NSLog(@"Current Date time %@",dateNow);
    //        NSLog(@"Current Date chk saved %@",dateChk);
    //
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:dateChk forKey:@"wepiDateKey"];
    //
    //        //    save wepiTicker string also
    //        [[NSUserDefaults standardUserDefaults] setObject:wepiTicker forKey:@"wepiPrices"];
    //
    //
    //
    //
    //    } else {
    //
    //        NSLog(@"Curent Date is less than wepiDateChk, so NO need to refresh data");
    //
    //    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //    [UAirship land];
}

@end


//Another way - It doesn't need to subclass of UINavigationController
//Add a Category to UINavigationController

@implementation UINavigationController (Rotation_IOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

@end
