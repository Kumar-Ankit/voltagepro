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
    [[VPDataManager sharedManager] fetchPASATimes:kMTPASATimePath completion:^(NSArray *times, NSError *error) {
        [weakSelf processTimes:times error:error];
    }];
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
