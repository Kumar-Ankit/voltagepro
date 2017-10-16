//
//  VPChartsController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/9/17.
//

#import "VPPASAChartsController.h"
#import "VPPASADataController.h"
#import "Utility.h"
#import "VPTimeSelectionController.h"

@interface VPPASAChartsController ()<UIWebViewDelegate, VPTimeSelectionControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) VPPASATimeCompareModel *selectedTimeModel;
@end

@implementation VPPASAChartsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PASA";
    self.webView.delegate = self;
 
    UIBarButtonItem *compareButton = [[UIBarButtonItem alloc] initWithTitle:@"Compare" style:UIBarButtonItemStylePlain target:self action:@selector(compareTapped:)];
    self.navigationItem.rightBarButtonItem = compareButton;
    
    // mtPASA will be loaded by default.
    [self loadMTPASAChart];
}

- (void)compareTapped:(id)sender
{
    VPTimeSelectionController *time = [[VPTimeSelectionController alloc] init];
    time.delegate = self;
    time.controllerType = [self controllerType];

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:time];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)dataButtonTapped:(id)sender
{
    VPPASADataController *pasaData = [[VPPASADataController alloc] initFromNib];
    pasaData.timeModel = self.selectedTimeModel;
    pasaData.controllerType = [self controllerType];
    [self.navigationController pushViewController:pasaData animated:YES];
}

- (PASAType)controllerType{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:
            return MTPASA;
            break;
        
        case 1:
            return STPASA;
            break;
            
        default:
            return MTPASA;
            break;
    }
}

- (IBAction)segmentButtonTapped:(UISegmentedControl *)segmentControl
{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
            [self loadMTPASAChart];
            break;
            
        case 1:
            [self loadSTPASAChart];
            break;
        default:
            break;
    }
}

- (void)loadMTPASAChart
{
    [Utility showHUDonView:self.view];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mtPASAURL]]];
    NSLog(@"Loading MTCharts%@",self.mtPASAURL);
}

- (void)loadSTPASAChart
{
    [Utility showHUDonView:self.view];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.stPASAURL]]];
    NSLog(@"Loading STCharts%@",self.stPASAURL);
}

- (NSString *)mtPASAURL{
    return _mtPASAURL.length ? _mtPASAURL : @"";
}

- (NSString *)stPASAURL{
    return _stPASAURL.length ? _stPASAURL : @"";
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [Utility hideHUDForView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [Utility hideHUDForView:self.view];
}

#pragma mark - VPTimeSelectionControllerDelagate
- (void)timeSelectionController:(VPTimeSelectionController *)controller didSelcectTime:(VPPASATimeCompareModel *)time
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (time)
    {
        self.selectedTimeModel = time;
        switch (self.segmentControl.selectedSegmentIndex) {
            case 0:
                self.mtPASAURL = kMTPASAChartURL(time.time_id);
                [self loadMTPASAChart];
                break;
            
            case 1:
                self.stPASAURL = kSTPASAChartURL(time.time_id);
                [self loadSTPASAChart];
                break;
                
            default:
                break;
        }
    }
}

@end
