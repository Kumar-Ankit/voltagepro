//
//  VPTimeSelectionController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/14/17.
//

#import "VPTimeSelectionController.h"

@interface VPTimeSelectionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, assign) NSInteger selectedRow;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation VPTimeSelectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Select time";
    self.view.backgroundColor = kAppBackgroundColor;
    self.navigationController.navigationBar.tintColor = kAppTintColor;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.selectedRow = -1;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTapped)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [self downloadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (void)downloadData
{
    [Utility showHUDonView:self.view];
    __weak typeof(self)weakSelf = self;
    [[VPDataManager sharedManager] fetchPASATimes:[self requestPath] completion:^(NSArray *times, NSError *error) {
        [weakSelf processTimes:times error:error];
    }];
}

- (NSString *)requestPath
{
    switch (self.controllerType) {
        case MTPASA:
            return kMTPASATimePath;
            break;
            
        case STPASA:
            return kSTPASATimePath;
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)processTimes:(NSArray *)times error:(NSError *)error
{
    [Utility hideHUDForView:self.view];
    
    if (error) {
        [Utility showErrorAlertTitle:nil withMessage:error.localizedDescription];
        return;
    }
    
    self.times = times;
    [self.tableView reloadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToPreSelectedTime];
    });
}

- (void)scrollToPreSelectedTime
{
    for (NSInteger index = 0; index < self.times.count; index++) {
        VPPASATimeCompareModel *time = self.times[index];
        if ([time.time_id isEqualToString:self.preSelectedTimeId]) {
            self.selectedRow = index;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            break;
        }
    }
}

- (void)cancelTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneTapped
{
    if (self.selectedRow >= 0 && self.selectedRow < self.times.count) {
        if ([_delegate respondsToSelector:@selector(timeSelectionController:didSelcectTime:)]) {
            [_delegate timeSelectionController:self didSelcectTime:self.times[self.selectedRow]];
        }
    }
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.times.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kDefaultCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.textLabel.textColor = kTfTextColor;
        cell.textLabel.font = kTableViewCellTitleFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    VPPASATimeCompareModel *time = self.times[indexPath.row];
    cell.textLabel.text = time.time;
    cell.backgroundColor = (self.selectedRow == indexPath.row) ? kPlaceholderColor : [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
    [tableView reloadData];
}

@end
