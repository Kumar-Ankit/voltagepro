//
//  Chart30minViewController.h
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface Chart30minViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>{
    
    UIImageView *chart;
    NSString *stateChartURL;
    NSString *selState;
    UIScrollView *scrollView;
    
    NSData *imageData;
    
    UILabel *aemo;
    
    UIWebView *webView1;
    
    
}

@property(nonatomic,strong) IBOutlet UIImageView *chart;
@property (nonatomic, copy) NSString *stateChartURL;
@property (nonatomic, copy) NSString *selState;
@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) NSData *imageData;

@property(nonatomic,retain) IBOutlet UILabel *aemo;

@property(nonatomic, retain) IBOutlet UIWebView *webView1;

-(IBAction)tweetTapped:(id)sender;

@end
