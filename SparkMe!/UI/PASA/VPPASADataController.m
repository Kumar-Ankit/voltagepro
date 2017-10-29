//
//  VPPASADataController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/10/17.
//

#import "VPPASADataController.h"
#import "VPStateSegmentControl.h"
#import "VPPASADataCell.h"
#import "VPDataManager.h"
#import "VPPASADataModel.h"
#import "Utility.h"
#import "VPPASATimeCompareModel.h"
#import "PASAModel.h"

@interface VPPASADataController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VPStateSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pasaTrailing;
@property (weak, nonatomic) IBOutlet UILabel *labelParams;
@property (nonatomic, strong) VPPASADataModel *pasaModel;
@end

@implementation VPPASADataController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentControl = [[VPStateSegmentControl alloc] init];
    [self.segmentControl addTarget:self action:@selector(segmentControlTapped:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl.selectedSegmentIndex = self.defaultStateIndex;
    self.navigationItem.titleView = self.segmentControl;
    [self.navigationItem.titleView sizeToFit];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewSmallPadding, 0, 0)];
    [self.tableView registerNib:[VPPASADataCell cellNib] forCellReuseIdentifier:@"cellData"];
    [self downloadData];
    
    [self handelUI];
}

- (void)handelUI{
    
    switch (self.controllerType) {
        case MTPASA:
            self.pasaTrailing.constant = 0;
            self.labelParams.text = @"";
            break;
            
        case STPASA:
            self.labelParams.text = [PASAModel shortNameForParamId:self.pasa.paramId];
            break;
            
        default:
            break;
    }
    
}

- (void)refreshData{
    [super refreshData];
    [self downloadData];
}

- (void)downloadData
{
    [Utility showHUDonView:self.view];
    
    NSInteger index = self.segmentControl.selectedSegmentIndex;
    __weak typeof(self)weakSelf = self;

    [[VPDataManager sharedManager] fetchPASADataWithPath:[self requestPath] withSelectedIndex:index completion:^(VPPASADataModel *response, NSError *error, NSInteger index) {
        [weakSelf processResponse:response error:error index:index];
    }];
}

- (void)processResponse:(VPPASADataModel *)model error:(NSError *)error index:(NSInteger)index
{
    if (self.segmentControl.selectedSegmentIndex != index){
        return;
    }
    
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    self.pasaModel = model;
    self.publishDate.text = [NSString stringWithFormat:@"Publish Date : %@",model.publish_date];
    [self.tableView reloadData];
}

- (NSString *)requestPath
{
    NSString *stateName = [self selectedStateName];
    NSString *keyUrl;
    switch (self.controllerType) {
        case MTPASA:
            keyUrl = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/webservices/?type=hvbconroller&requestmethod=mtpassdata&node=%@1&id=%@",stateName,self.pasa.timeId];
            break;
            
        case STPASA:
            keyUrl = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/webservices/?type=hvbconroller&requestmethod=stpassdata&node=%@1&id=%@&id1=%@",stateName,self.pasa.timeId,self.pasa.paramId];
            break;
            
        default:
            break;
    }
    
    return keyUrl;
}

- (NSString *)selectedStateName
{
    NSString *title = [self.segmentControl titleForSegmentAtIndex:self.segmentControl.selectedSegmentIndex];
    return title;
}

- (IBAction)scrollToBottomTapped:(id)sender
{
    if (self.pasaModel.pasaItems.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.pasaModel.pasaItems.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)segmentControlTapped:(UISegmentedControl *)segmentControl{
    [self downloadData];
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pasaModel.pasaItems.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [VPPASADataCell height];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    VPPASADataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellData" forIndexPath:indexPath];
    cell.pasaLayout.constant = self.pasaTrailing.constant;
    
    VPPASAItem *pasa = self.pasaModel.pasaItems[indexPath.row];
    cell.labelDate.text = pasa.day;
    cell.labelDelta.text = [[[Utility shared] numberFormatter] stringFromNumber:pasa.pasa_delta];
    
    if (pasa.st_pasa) {
        NSString *prm = pasa.rawDict[self.pasa.paramId];
        prm = prm ? prm : @"";
        cell.labelParams.text = [[[Utility shared] numberFormatter] stringFromNumber:@([prm doubleValue])];
        cell.labelPASA.text = [[[Utility shared] numberFormatter] stringFromNumber:pasa.st_pasa];
    }
    else if (pasa.mt_pasa)
    {
        cell.labelParams.text = @"";
        cell.labelPASA.text = [[[Utility shared] numberFormatter] stringFromNumber:pasa.mt_pasa];
    }
    
    cell.backgroundColor = (indexPath.row % 2) ? kSeparatorColor : [UIColor whiteColor];
    
    return cell;
    
}

@end
