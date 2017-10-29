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
#import "VPStateSegmentControl.h"

@interface PASAModel: NSObject
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, strong) NSString *regionId;
@property (nonatomic, strong) NSString *paramId;
@property (nonatomic, strong, readonly) NSArray *stAllParams;
- (NSURL *)MTPASAWebViewURL;
- (NSURL *)STPASAWebViewURL;
+ (NSString *)shortNameForParamId:(NSString *)parmaId;

@end

@interface VPPASAChartsController ()<UIWebViewDelegate, VPTimeSelectionControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *stPASAParamsButton;

@property (nonatomic, strong) VPStateSegmentControl *stateSegmentControl;
@property (nonatomic, strong) VPPASATimeCompareModel *selectedTimeModel;
@property (nonatomic, strong) PASAModel *mtPASAModel;
@property (nonatomic, strong) PASAModel *stPASAModel;

@end

@implementation VPPASAChartsController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"PASA";
    
    self.mtPASAModel = [[PASAModel alloc] init];
    self.stPASAModel = [[PASAModel alloc] init];
    
    self.webView.delegate = self;
 
    UIBarButtonItem *compareButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Compare" style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(compareTapped:)];
    self.navigationItem.rightBarButtonItem = compareButton;
    
    self.stateSegmentControl = [[VPStateSegmentControl alloc] init];
    [self.stateSegmentControl addTarget:self
                                 action:@selector(stateSegmentControlTapped:)
                       forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.stateSegmentControl;
    [self.navigationItem.titleView sizeToFit];
    
    // mtPASA will be loaded by default.
    [self loadReleventPASA];
}

- (void)stateSegmentControlTapped:(VPStateSegmentControl *)segmentControl{
    self.stPASAModel.regionId = [self selectedRegion];
    self.mtPASAModel.regionId = [self selectedRegion];
    [self loadReleventPASA];
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

- (IBAction)segmentButtonTapped:(UISegmentedControl *)segmentControl{
    [self loadReleventPASA];
}

- (void)loadReleventPASA
{
    switch (self.segmentControl.selectedSegmentIndex) {
        case 0:{
            [self loadMTPASAChart];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.stPASAParamsButton.alpha = 0.0;
            }];
        }
            break;
            
        case 1:{
            
            [self loadSTPASAChart];
            [UIView animateWithDuration:0.5 animations:^{
                self.stPASAParamsButton.alpha = 1.0;
            }];
        }
            break;
        default:
            break;
    }
}

- (void)loadMTPASAChart
{
    [Utility showHUDonView:self.view];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.mtPASAModel MTPASAWebViewURL]]];
    NSLog(@"Loading MTCharts%@",[self.mtPASAModel MTPASAWebViewURL].absoluteString);
}

- (void)loadSTPASAChart
{
    [Utility showHUDonView:self.view];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[self.stPASAModel STPASAWebViewURL]]];
    NSLog(@"Loading STCharts%@",[self.stPASAModel STPASAWebViewURL].absoluteString);
    
    NSString *title = [PASAModel shortNameForParamId:self.stPASAModel.paramId];
    [self.stPASAParamsButton setTitle:title forState:UIControlStateNormal];
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
    
    [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
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
                self.mtPASAModel.timeId = time.time_id;
                [self loadMTPASAChart];
                break;
            
            case 1:
                self.stPASAModel.timeId = time.time_id;
                [self loadSTPASAChart];
                break;
                
            default:
                break;
        }
    }
}

- (IBAction)stPASAParamsButtonTapped:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select ST Parameters"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:nil];
    
    for( NSString *title in self.stPASAModel.stAllParams)  {
        [sheet addButtonWithTitle:title];
    }

    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger index = buttonIndex - 1;
    
    if (index >= self.stPASAModel.stAllParams.count) {
        return;
    }
    
    self.stPASAModel.paramId = self.stPASAModel.stAllParams[index];
    [self loadSTPASAChart];
}

- (NSString *)selectedRegion{
    NSString *title = [self.stateSegmentControl titleForSegmentAtIndex:self.stateSegmentControl.selectedSegmentIndex];
    return title;
}

@end

#pragma mark - PASA Model

@interface PASAModel()
@property (nonatomic, strong, readwrite) NSArray *stAllParams;
@end

@implementation PASAModel

- (id)init{
    self = [super init];
    if (self) {
        self.timeId = @"0";
        self.paramId = @"demand10";
        self.regionId = @"NSW";
        
        self.stAllParams = [PASAModel stParamsArray];
    }
    return self;
}

+ (NSArray *)stParamsArray{
    return @[@"demand10",
             @"demand50",
             @"demand90",
             @"TOTALINTERMITTENTGENER",
             @"DEMAND_AND_NONSCHEDGEN",
             @"SEMISCHEDULEDCAPACITY"];
}

+ (NSString *)shortNameForParamId:(NSString *)parmaId
{
    if ([parmaId isEqualToString:@"demand10"]) {
        return @"DEM10";
    }
    
    if ([parmaId isEqualToString:@"demand50"]) {
        return @"DEM50";
    }
    
    if ([parmaId isEqualToString:@"demand90"]) {
        return @"DEM90";
    }
    
    if ([parmaId isEqualToString:@"TOTALINTERMITTENTGENER"]) {
        return @"T.I.I";
    }
    
    if ([parmaId isEqualToString:@"DEMAND_AND_NONSCHEDGEN"]) {
        return @"D&N";
    }
    
    if ([parmaId isEqualToString:@"SEMISCHEDULEDCAPACITY"]) {
        return @"S.S.C.";
    }
    
    return @"Params";
}

- (NSURL *)MTPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/mtpasa_chart.php?region=%@1&id=%@",self.regionId,self.timeId];
    return [NSURL URLWithString:string];
}

- (NSURL *)STPASAWebViewURL
{
    NSString *string = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/stpasa_chart.php?region=%@1&id=%@&id1=%@",self.regionId,self.timeId,self.paramId];
    return [NSURL URLWithString:string];
}

@end

