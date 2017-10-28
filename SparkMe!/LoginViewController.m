//
//  LoginViewController.m
//  Sparky
//
//  Created by Hung on 1/09/12.
//
//

#import "LoginViewController.h"

#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"
#import "Reachability.h"
#import "Utility.h"
#import "CompanyViewController.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize txtUsername, txtPassword, urlConnection, login, sparkyLogo, phanalytics, blurView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // A system version of 6.0 or greater is required for setting gradient atIndex to 1 otherwise set to 0.  Otherwise buttons won't appear
    
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending){
        NSLog(@"Version is 6.0 or greater, set atIndex to 1");
        
        gradIndex = 1;
        
    } else {
        NSLog(@"Version is less than 6.0, set atIndex to 0");
        
        gradIndex = 0;
        
    }
    
    DeviceType= [[UIDevice currentDevice] model];
    OsVersion = [[UIDevice currentDevice] systemVersion];
    appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    // Get the users Device Model, Display Name, Unique ID, Token & Version Number
    //    UIDevice *dev = [UIDevice currentDevice];
    //    NSString *deviceName = dev.name;
    //    NSString *deviceModel = dev.model;
    //
    //    NSLog(@"device name is %@, device model is %@",deviceName, deviceModel);
    
    
    NSLog(@"App Version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
    
    blurView.translucentAlpha = 0.65;
    blurView.translucentStyle = UIStatusBarStyleDefault;
    blurView.translucentTintColor = [UIColor clearColor];
    blurView.backgroundColor = [UIColor clearColor];
    
    
    sparkyLogo.font=[UIFont fontWithName:@"Sansation" size:40.0];
    phanalytics.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18.0];
    
    //    UIColor *DarkGreyOp = [UIColor whiteColor];
    //    UIColor *LightGreyOp = [UIColor lightGrayColor];
    
    //    CAGradientLayer *gradient = [CAGradientLayer layer];
    //    gradient.frame = [[login layer] bounds];
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
    //    [[login layer] insertSublayer:gradient atIndex:gradIndex];
    login.layer.cornerRadius = 5.0f;
    login.layer.borderWidth = 1.0f;
    login.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [login setTitleColor:[UIColor darkGrayColor] forState: UIControlStateNormal];
    
    
    
    UAdevToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"UAdevToken"];
    
    NSLog(@"My Device token is %@", UAdevToken);
    
    keychain =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"SparkyLoginData" accessGroup:nil];
    
    keychainDeviceCred =
    [[KeychainItemWrapper alloc] initWithIdentifier:@"SparkyLoginDeviceData" accessGroup:nil];
    
    txtUsername.text = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    txtPassword.text = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    //NSLog(@"Current device user details stamped is : %@", [keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)]);
    
    if([[keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)] isEqual:@""]){
        NSLog(@"Yeah, device user details is nil");
    } else {
        //NSLog(@"Current stored device credentials are: %@",[keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)]);
    }
    
    
    
}

- (void)viewDidUnload
{
    txtUsername=nil; txtPassword=nil; urlConnection=nil; login=nil; sparkyLogo=nil; phanalytics=nil; responsePriceAlertFlag=nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}


- (void)loadPart1
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        HUD = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
//        HUD.yOffset = -100.f;
//        HUD.labelText = @"Authenticating";
//    });
    [Utility showHUDonView:self.view];
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}



- (void)loadPart2 {
    
    
    @try {
        
        if([[txtUsername text] isEqualToString:@""] || [[txtPassword text] isEqualToString:@""] ) {
            [MBProgressHUD hideHUDForView:self.view  animated:YES];
            [self alertStatus:@"Please enter both Username and Password":@"Incomplete Login"];
        } else {
            
            
            UAdevToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"UAdevToken"];
            
            NSLog(@"My Device token is again %@", UAdevToken);
            
            NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@&appversion=%@&devtoken=%@&devicetype=%@&osversion=%@",[txtUsername text],[txtPassword text], appVersion, UAdevToken, DeviceType, OsVersion];
            //            NSLog(@"PostData: %@",post);
            
            //            this returns 1 or0
            //            NSURL *url=[NSURL URLWithString:@"http://phanalytics.com.au/SparkyLogin.php"];
            
            
            //            this returns 0 if successfull but not yet activated, 1 if successfull but activated, and 2 if unsuccessfull
            
    NSURL *url=[NSURL URLWithString:@"http://hvbroker.azurewebsites.net/pushnotification/VoltageProLoginV2.php"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //            (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            if ([response statusCode] >=200 && [response statusCode] <300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"%@", responseData);
                
                
                //                the first character of the response represents whether account is activated or not, second character represents whether price notification should be activated or not
                NSString *responseActivate = [responseData substringToIndex:1];
                
                responsePriceAlertFlag = [responseData substringFromIndex:[responseData length] - 1];
                responsePriceAlertFlag = @"1";                
                NSLog(@"activated response is %@", responseActivate);
                
                NSLog(@"PriceAlertFlag response is %@", responsePriceAlertFlag);
                
                if([responseActivate isEqualToString:@"0"] || [responseActivate isEqualToString:@"1"])
                {
                    NSLog(@"Login SUCCESS with result %@", responseActivate);
                    
                    
                    if ([responseActivate isEqualToString:@"0"]){
                        
                        //                        if response is zero, means device not yet activated, so need to:
                        //                        1. update mysql activated field from 0 to 1, and stamp activation date.
                        //                        2. save activation details on device with username and password and activation setting of 1.
                        //                        3. Proceed OK.
                        
                        //                  Scenario 1. First time install Sparky on device.  Device has nil, www has 0.
                        
                        //                        Step 1.  Stamp Username and Password as different keychain variables (diff to the stored one for repeated login).
                        NSString *UserKeyStamp = [NSString stringWithFormat:@"%@%@1",txtUsername.text,txtPassword.text];
                        
                        [keychainDeviceCred setObject:UserKeyStamp forKey:(__bridge id)(kSecAttrAccount)];
                        
                        
                        //NSLog(@"Concatenated UserName Password and True Flag= %@", [keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)]);
                        
                        //                        PHP script automatically detects that the username and acct has activated=0 and updates db to change activated flag from 0 to 1 and stamps an activation date.
                        
                        //                        Success!!! - Load next screen
                        [self loadPart3_Success];
                        
                        
                    } else {
                        
                        //                        this else occurs when response is 1, means device already activated, so need to check:
                        //                        1. If device activation setting is nil or zero and mysql is 1, then device is trying to use a login that has already activated (potential multiple user). Then display error.
                        //                        2. if device is set to 1 and user name and password matches then OK to proceed.
                        
                        //                        Scenario 1. Sparky installed, Device 1, www has 1.  For username & password.
                        
                        //                        Scenario 2. Sparky just installed, Device nil, www has 1.  Re-use of login credentials or authentic, but new device, eg. lost and new.
                        
                        //                        check if device credentials are nil (ie. has not been activated on device before but server says username and password already activated)
                        
                        if([[keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)] isEqual:@""]){
                           
                            
                            NSLog(@"Yeah, device user details is nil");
                            
                            //                                Scenario, user acct and password already activated.  Fail!
                            
                            //[self loadPart3_Success];
                            
                            //Temporary added above line and temporary commented belwo two lines
                            
                            
                          [MBProgressHUD hideHUDForView:self.view  animated:YES];
                            
                            [self alertStatus:@"Username & Password already used.  Contact sb@hvbrokers.com.au for further info.":@"Connection Failed"];
                            
                            
                        } else {
                            //NSLog(@"Current stored device credentials are: %@",[keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)]);
                            //                            lets check stored credentials with details used to login, if they match.
                            
                            NSString *loginUserNamePsswdActivated = [NSString stringWithFormat:@"%@%@1",txtUsername.text,txtPassword.text];
                            
                            //                            if match then proceed.
                            if([[keychainDeviceCred objectForKey:(__bridge id)(kSecAttrAccount)] isEqual:loginUserNamePsswdActivated]){
                                
                                NSLog(@"username and password match device stored credentials from activation");
                                
                                [self loadPart3_Success];
                                
                            } else {
                                
                                NSLog(@"username and password don't match device stored credentials from first activation");
                                
                                //                            if don't match then error message ( scenario - using different username and password that has already been activated )
                                
                                NSString *UserKeyStamp = [NSString stringWithFormat:@"%@%@1",txtUsername.text,txtPassword.text];
                                
                                [keychainDeviceCred setObject:UserKeyStamp forKey:(__bridge id)(kSecAttrAccount)];
                                
                                [self loadPart3_Success];
                                
                                [MBProgressHUD hideHUDForView:self.view  animated:YES];
//                                [self alertStatus:@"Inconsistent Username & Password used.  Contact sb@hvbrokers.com.au for further info.":@"Connection Failed"];
                                
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                } else {
                    
                    [self loadPart3_Fail];
                }
                
            } else {
                if (error) NSLog(@"Error: %@", error);
                
                
                [self loadPart3_Fail];
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        
        [self loadPart3_Fail];
        
    }
    
    
    
}


- (void)loadPart3_Success {
    
    
    //    this is run when user credentials are correct and valid and pushes the menu view.
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"Completed";
    
    //    Save price alerts flag
    
    [[NSUserDefaults standardUserDefaults] setObject:responsePriceAlertFlag forKey:@"PriceAlertFlag"];
    
    
    [keychain setObject:txtUsername.text forKey:(__bridge id)(kSecAttrAccount)];
    
    [keychain setObject:txtPassword.text forKey:(__bridge id)(kSecValueData)];
    
    //NSLog(@"username: %@", [keychain objectForKey:(__bridge id)(kSecAttrAccount)]);
    
    //NSLog(@"password: %@", [keychain objectForKey:(__bridge id)(kSecValueData)]);
    
    [self performSegueWithIdentifier:@"toMenu" sender:self];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)loadPart3_Fail {
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    [self alertStatus:@"Please check username and password and try again.  Contact sb@hvbrokers.com.au for further info.":@"Connection Failed"];
}

- (IBAction)loginClicked:(id)sender {
    
    
    //        if([[txtUsername text] isEqualToString:@""] || [[txtPassword text] isEqualToString:@""] ) {
    //            [self alertStatus:@"Please enter both Username and Password" :@"Login Failed!"];
    //        } else {
    //
    //            NSURL *url = [NSURL URLWithString:@"http://phanalytics.com.au/SparkySecure/SparkyLogin.php"];
    //            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //
    //            // Start the connection request
    //            // Assumes NSURLConnection *urlConnection is defined as an
    //            // instance variable
    //            urlConnection  = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    //
    //        }
    
    
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadPart1];
        });
    }
}

//- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//    int code = [httpResponse statusCode];
//    NSLog(@"response code via didreceiveresponse delegate is : %i",code);
//
//
//}

///*---------------------------------------------------------------------------
// * Received a server challenge
// *--------------------------------------------------------------------------*/
//- (void)connection:(NSURLConnection *)connection
//didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    // Access has failed two times...
//    if ([challenge previousFailureCount] >= 1)
//    {
//        urlConnection=nil;
//
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
//                                                        message:@"Too many unsuccessul login attempts."
//                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//
//        [alert show];
//        alert=nil;
//    }
//    else
//    {
//        // Answer the challenge
//        NSURLCredential *cred = [[NSURLCredential alloc] initWithUser:@"sparky" password:@"sparky7904"
//                                                           persistence:NSURLCredentialPersistenceForSession];
//        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
//
//        NSLog(@"Challenge answered with username and password");
//    }
//}
//
///*---------------------------------------------------------------------------
// * Finished loading URL
// *--------------------------------------------------------------------------*/
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    NSLog(@"Connection success.");
//
//    urlConnection=nil;
//
//    [self loadPart3_Success];
//}
//
///*---------------------------------------------------------------------------
// * URL connection fail
// *--------------------------------------------------------------------------*/
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    NSLog(@"Connection failure.");
//
//    urlConnection=nil;
//}


- (IBAction)backgroundClicked:(id)sender {
    [txtUsername resignFirstResponder];
    [txtPassword resignFirstResponder];
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    
    [alertView show];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self handelAutoLogin];
}

- (void)handelAutoLogin
{
    if (txtPassword.text.length && txtUsername.text.length) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loginClicked:nil];
        });
    }
}


- (void) viewWillDisappear:(BOOL)animated

{
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    //    [self.navigationController setToolbarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"CompanyView"]) {
        CompanyViewController *CompanyVC = [segue destinationViewController];
        
        CompanyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController setToolbarHidden:YES animated:NO];
        
        
        
    }
}

-(BOOL) shouldAutorotate {
    return NO;
}


@end

