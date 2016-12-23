//
//  NoticeDetailViewController.m
//  Sparky
//
//  Created by Hung on 18/08/12.
//
//

#import "NoticeDetailViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

@synthesize webView, noticeURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)done:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    //    [UIView transitionWithView:self.view.window
    //                      duration:1.0f
    //                       options:UIViewAnimationOptionTransitionCurlDown
    //                    animations:^{
    //                        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
    //                    }
    //                    completion:NULL];
    //    need to save settings
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
        
        //        NSURL *url = [NSURL URLWithString:[@"http://www.aemo.com.au" stringByAppendingString:@"/en/Market-Notices/0039189"]];
        //                NSURL *url = [NSURL URLWithString:[@"http://www.aemo.com.au" stringByAppendingString:noticeURL]];
        NSURL *url = [NSURL URLWithString:[@"http://www.nemweb.com.au" stringByAppendingString:noticeURL]];
        //URL Requst Object
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        
        //        NSData *marketNoticesDetail = [NSData dataWithContentsOfURL:url];
        //        NSString *marketNoticesDetailStr = [[NSString alloc] initWithData:marketNoticesDetail encoding:NSUTF8StringEncoding];
        //
        //        // first, separate by new line
        //        NSArray* allLinedStrings =
        //        [marketNoticesDetailStr componentsSeparatedByCharactersInSet:
        //         [NSCharacterSet newlineCharacterSet]];
        //
        //
        //        NSLog(@"print line 20 of file %@", [allLinedStrings objectAtIndex:20]);
        //        NSLog(@"print line 22 of file %@", [allLinedStrings objectAtIndex:22]);
        //        NSLog(@"print line 24 of file %@", [allLinedStrings objectAtIndex:24]);
        //        NSLog(@"print line 26 of file %@", [allLinedStrings objectAtIndex:26]);
        //        NSLog(@"print line 28 of file %@", [allLinedStrings objectAtIndex:28]);
        //Load the request in the UIWebView.
        [webView loadRequest:requestObj];
        
        
    }
    
}

- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    hudUpdateUIView.yOffset = 50.f;
}




-(void)webViewDidStartLoad:(UIWebView *)aWebView {
    
    [self loadPart1];
    
    //    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    //        hudUpdateUIView.labelText = @"Loading...";
    //        hudUpdateUIView.yOffset = 50.f;
}


- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    //    [webView stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 2.0;"];
    
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
