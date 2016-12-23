//
//  UnderRightViewController.m
//  Sparky
//
//  Created by Hung on 28/04/13.
//
//

#import "UnderRightViewController.h"

@interface UnderRightViewController ()

@end

@implementation UnderRightViewController

@synthesize peekLeftAmount, menuItems, mytableView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    menuItems=nil; mytableView=nil;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (IBAction)scrollBottom:(id)sender{
    mytableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:[menuItems count]-1 inSection:0];
    [mytableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)scrollTop:(id)sender {
    [mytableView setContentOffset:CGPointZero animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.peekLeftAmount = 150.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
}


- (void)awakeFromNib
{
    
    
    NSArray *temp5mArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"nemFiles5mKey"];
    
    NSDateFormatter *dtF = [[NSDateFormatter alloc] init];
    [dtF setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dtF setDateFormat:@"yyyyMMddHHmm"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"Australia/Queensland"]];
    [dateFormat setDateFormat:@"dd/MMM HH:mm"];
    
    NSRange stringRange = {18,12};
    
    //    Set 1.5 days history
    
    self.menuItems = [[NSMutableArray alloc] init];
    for (int i = 1; i < 433; i++)
    {
        NSString *fileName = [[temp5mArray objectAtIndex:[temp5mArray count]-i] substringWithRange:(stringRange)];
        
        //        NSLog(@"string filename %@",fileName);
        
        NSDate *date5min = [dtF dateFromString:fileName];
        
        //        NSLog(@"string date %@", [dateFormat stringFromDate:date5min]);
        
        [self.menuItems addObject:[dateFormat stringFromDate:date5min]];
    }
    
    
    
    //    self.menuItems = [NSArray arrayWithObjects:@"First", @"Second", @"Third", @"Navigation", nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *identifier = [NSString stringWithFormat:@"%@Top", [self.menuItems objectAtIndex:indexPath.row]];
    
    
    //    Need to save index of selection to choose correct value.
    
    //    NSLog(@"Returned value is %i",indexPath.row + 1);
    
    NSInteger IndexTempValue = indexPath.row + 1;
    
    
    
    [[NSUserDefaults standardUserDefaults] setInteger:IndexTempValue forKey:@"IndexValue5minHistory"];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstTop"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
