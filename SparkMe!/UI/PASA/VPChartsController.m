//
//  VPChartsController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/9/17.
//

#import "VPChartsController.h"
#import "VPPASADataController.h"
#import "Utility.h"

@interface VPChartsController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation VPChartsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PASA";
    self.webView.delegate = self;
    
    // mtPASA will be loaded by default.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mtPASAURL]]];
    
    [Utility showHUDonView:self.view];
}

- (IBAction)dataButtonTapped:(id)sender
{
    VPPASADataController *pasaData = [[VPPASADataController alloc] initWithNibName:@"VPPASADataController" bundle:nil];
    [self.navigationController pushViewController:pasaData animated:YES];
}

- (IBAction)segmentButtonTapped:(UISegmentedControl *)segmentControl
{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mtPASAURL]]];
            break;
            
        case 1:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.stPASAURL]]];
            break;
            
        default:
            break;
    }
}

- (NSString *)mtPASAURL{
    return _mtPASAURL.length ? _mtPASAURL : @"";
}

- (NSString *)stPASAURL{
    return _stPASAURL.length ? _stPASAURL : @"";
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [Utility hideHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [Utility hideHUDForView:self.view];
}


@end
