//
//  NoticeDetailViewController.h
//  Sparky
//
//  Created by Hung on 18/08/12.
//
//

#import <UIKit/UIKit.h>

@interface NoticeDetailViewController : UIViewController{
    UIWebView *webView;
    
    NSString *noticeURL;
}

@property(nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *noticeURL;


- (IBAction)done:(id)sender;

@end
