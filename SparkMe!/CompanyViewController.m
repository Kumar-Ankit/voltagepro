//
//  CompanyViewController.m
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompanyViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)webViewDidStartLoad:(UIWebView *)aWebView {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
    //    CGRect frame = aWebView.frame;
    //    frame.size.height = 1;
    //    aWebView.frame = frame;
    //    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    //    frame.size = fittingSize;
    //    aWebView.frame = frame;
    //
    //    NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        
        
        
        
        NSURL *url = [NSURL URLWithString: @"http://phanalytics.com.au/products-2/sparky-pro/"];
        
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [webView loadRequest:requestObj];
        
        
        
        
        
        
        
    }
    
    
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    webView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
