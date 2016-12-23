//
//  Chart30minViewController.m
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Chart30minViewController.h"
#import "MBProgressHUD.h"



@interface Chart30minViewController ()

@end

@implementation Chart30minViewController
@synthesize chart, stateChartURL, scrollView, selState, imageData, aemo, webView1;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
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
//    NSLog(@"Graph loaded");
//    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stateChartURL]];
//    UIImage *image = [UIImage imageWithData:imageData];
//    chart.image = image;
//
//     [MBProgressHUD hideHUDForView:self.view  animated:YES];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [self loadPart1];
    
    NSURL *url = [NSURL URLWithString: @"http://aemo.com.au/aemo/apps/visualisations/elec-priceanddemand.html"];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webView1 loadRequest:requestObj];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    chart=nil;
    stateChartURL=nil;
    scrollView=nil;
    imageData=nil;
    selState=nil;
}

// orientation for ios5


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
////        return YES;
//    //    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
////    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
//    //    self.scrollView.zoomScale = 1;
//    //    self.chart.frame = CGRectMake(0, 0, self.chart.image.size.width, self.chart.image.size.height);
//    //    self.scrollView.contentSize = self.chart.image.size;
//
//    if ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight))
//    {
//      [aemo setFrame:CGRectMake(0, 240, 480, 21)];
//        scrollView.frame = CGRectMake(0, -200, 568, 274);
//    }
//    else
//    {
//      [aemo setFrame:CGRectMake(0, self.view.bounds.size.height-30, 320, 21)];
//
//    }
//    return YES;
//}

//orientation for ios6

- (BOOL)shouldAutorotate
{
    return NO;
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationPortrait);
    //OR return (UIInterfaceOrientationMaskAll);
}
//
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//
//    NSLog(@"will rotate interface orientation ios6 works");
//    if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight))
//
//    {
//        [aemo setFrame:CGRectMake(0, 240, 480, 21)];
//    }
//    else
//    {
//        [aemo setFrame:CGRectMake(0, 385, 320, 21)];
//    }
//
//
//
//}




- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return chart;
}

-(IBAction)tweetTapped:(id)sender
{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Sending Method"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Email", @"Tweet", nil];
    
    // Show the sheet
    [sheet showInView:self.view];
    
    
}

//uiactionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %ld", (long)buttonIndex);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.webView1.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(self.webView1.bounds.size);
    }
    
    [self.webView1.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    imageData = UIImagePNGRepresentation(image);
    
    if(buttonIndex==0){
        //        user selected email
        
        if ([MFMailComposeViewController canSendMail]) {
            
            
            MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
            mailViewController.mailComposeDelegate = self;
            [mailViewController setSubject:@"Traded and Predispatch electricity price & demand!"];
            [mailViewController addAttachmentData:imageData mimeType:@"image/jpg" fileName:@"PriceDemandChart.jpg"];
            
            [mailViewController setMessageBody:@"\n\n\n===========================\nUsing Sparky Pro for iPhone.\nSource: (AEMO) Australian Energy Market Operator" isHTML:NO];
            
            [self presentViewController:mailViewController animated:YES completion:nil];
            
        }
        
        else {
            
            NSLog(@"Device is unable to send email in its current state.");
            
        }
        
    }
    
    
    if(buttonIndex==1){
        //        user pressed tweet
        //    check if device can send tweet
        
        
        SLComposeViewController *tweetSheet=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [tweetSheet dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        NSLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                        NSLog(@"Posted....");
                    }
                        break;
                }};
            
            [tweetSheet addImage:image];
            [tweetSheet setInitialText:[@"Check out the current traded & pre-dispatch elec. price & demand!" stringByAppendingString:@"\nSparky Pro for iPhone."]];
            [tweetSheet setCompletionHandler:completionHandler];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        
        
        else
        {
            //        Device cannot send Tweet.  Show error notification
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Unable to Tweet"
                                      message:@"Please ensure you have at least one Twitter account setup and have internet connectivity."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}


// MARK: -
// MARK: MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}



@end


