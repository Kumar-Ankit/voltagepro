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

@interface VPPASADataController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) VPStateSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) VPPASADataModel *pasaModel;
@end

@implementation VPPASADataController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentControl = [[VPStateSegmentControl alloc] init];
    [self.segmentControl addTarget:self action:@selector(segmentControlTapped:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentControl;
    [self.navigationItem.titleView sizeToFit];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(downloadData)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewSmallPadding, 0, 0)];
    [self.tableView registerNib:[VPPASADataCell cellNib] forCellReuseIdentifier:@"cellHeader"];
    [self.tableView registerNib:[VPPASADataCell cellNib] forCellReuseIdentifier:@"cellData"];
    [self downloadData];
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
            keyUrl = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/webservices/?type=hvbconroller&requestmethod=mtpassdata&node=%@1&id=%@",stateName,self.timeModel.time_id];
            break;
            
        case STPASA:
            keyUrl = [NSString stringWithFormat:@"http://hvbroker.azurewebsites.net/webservices/?type=hvbconroller&requestmethod=stpassdata&node=%@1&id=%@",stateName,self.timeModel.time_id];
            break;
            
        default:
            break;
    }
    
    return keyUrl;
}

- (VPPASATimeCompareModel *)timeModel{
    
    if (!_timeModel) {
        _timeModel = [VPPASATimeCompareModel new];
        _timeModel.time_id = @"0";
    }
    
    return _timeModel;
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
    VPPASAItem *pasa = self.pasaModel.pasaItems[indexPath.row];
    cell.labelDate.text = pasa.day;
    cell.labelPASA.text = [[[Utility shared] numberFormatter] stringFromNumber:pasa.mt_pasa];
    cell.labelDelta.text = [[[Utility shared] numberFormatter] stringFromNumber:pasa.pasa_delta];
    
    cell.backgroundColor = (indexPath.row % 2) ? kSeparatorColor : [UIColor whiteColor];
    
    return cell;
    
}

@end
