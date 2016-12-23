//
//  SubMenuViewController.m
//  Sparky
//
//  Created by Hung on 18/08/12.
//
//

#import "SubMenuViewController.h"
#import "TFHpple.h"
#import "Reachability.h"

#import "NoticeDetailViewController.h"
#import "MBProgressHUD.h"



@interface SubMenuViewController ()

@end

@implementation SubMenuViewController

@synthesize idNotice, dateNotice, catgyNotice, descNotice, hrefNotice, descNoticeRaw, hrefNoticeRaw, grpSection, urlString, tableview1;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)done:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    //    [UIView transitionWithView:self.view.window
    //                      duration:1.0f
    //                       options:UIViewAnimationOptionTransitionCurlDown
    //                    animations:^{
    //                        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
    //                    }
    //                    completion:NULL];
    //    need to save settings
}

- (void)loadPart1 {
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:self.view  animated:YES];
    hudUpdateUIView.labelText = @"Loading...";
    
    [self performSelector:@selector(loadPart2) withObject:nil afterDelay:0];
}

- (void)loadPart2 {
    //    NSData *marketNotices = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.aemo.com.au/Electricity/NEM-Data/Market-Notices"]];
    
    NSData *marketNotices = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.nemweb.com.au/Reports/CURRENT/Market_Notice/"]];
    
    
    
    // 2
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:marketNotices];
    
    // 3
    //    NSString *htmlXpathQueryString = @"//tbody//td | //tbody//a | //tbody//a/@href";
    NSString *htmlXpathQueryString = @"//body//a | //body//a/@href";
    
    NSArray *htmlNodes = [htmlParser searchWithXPathQuery:htmlXpathQueryString];
    
    // 4
    NSMutableArray *Notices = [[NSMutableArray alloc] init];
    
    for (TFHppleElement *element in htmlNodes) {
        // 5
        if([[element firstChild] content]!=nil){
            
            [Notices addObject:[[element firstChild] content]];
        }
        
        // 7
        //        tutorial.url = [element objectForKey:@"href"];
    }
    
    //    NSLog(@"%@",nemFiles);
    //
    //    NSLog(@"Items in file list array : %i", [nemFiles count]);
    
    
    //    NSString *latestFileName = [nemFiles objectAtIndex:[nemFiles count]-1];
    
    //    NSLog(@"Results in array : %@", Notices);
    
    
    //extract each item
    
    
    descNoticeRaw = [[NSMutableArray alloc] init];
    hrefNoticeRaw = [[NSMutableArray alloc] init];
    
    for(int i=0; i<[Notices count]; i= i+2){
        
        NSArray *descStrings = [[Notices objectAtIndex:i] componentsSeparatedByString:@","];
        NSArray *hrefStrings = [[Notices objectAtIndex:i+1] componentsSeparatedByString:@","];
        
        //        [priceArray addObject:[NSString stringWithFormat:@"%@ %@", [components objectAtIndex:6],[components objectAtIndex:9]]];
        
        
        [descNoticeRaw addObject:[descStrings objectAtIndex:0]];
        
        [hrefNoticeRaw addObject:[hrefStrings objectAtIndex:0]];
        
    }
    

    
    
    idNotice = [[NSMutableArray alloc] init];
    dateNotice = [[NSMutableArray alloc] init];
    catgyNotice = [[NSMutableArray alloc] init];
    descNotice = [[NSMutableArray alloc] init];
    hrefNotice = [[NSMutableArray alloc] init];
    

    
    
    for (NSUInteger y=[hrefNoticeRaw count]-1; y>=[hrefNoticeRaw count]-25; y--){
        
        //        NSLog(@"y equals %lu", (unsigned long)y);
        
        [hrefNotice addObject:[hrefNoticeRaw objectAtIndex:y]];
        

        
        NSURL *url = [NSURL URLWithString:[@"http://www.nemweb.com.au" stringByAppendingString:[hrefNoticeRaw objectAtIndex:y]]];
        //URL Requst Object
        
        NSData *marketNoticesDetail = [NSData dataWithContentsOfURL:url];
        NSString *marketNoticesDetailStr = [[NSString alloc] initWithData:marketNoticesDetail encoding:NSUTF8StringEncoding];
        
        // first, separate by new line
        NSArray* allLinedStrings =
        [marketNoticesDetailStr componentsSeparatedByCharactersInSet:
         [NSCharacterSet newlineCharacterSet]];
        
//        if (y == [hrefNoticeRaw count]-1) {
        
//            for ( NSUInteger x = 1; x <=30; x++) {
//                
//                NSLog(@"print %lu,  allLinedStrings %@", x, [allLinedStrings objectAtIndex:x]);
//
//                
//            }
//                    }
        
        if ([[allLinedStrings objectAtIndex:20] substringFromIndex:34] != nil) {
        
        [idNotice addObject:[[allLinedStrings objectAtIndex:20] substringFromIndex:34]];
        
        [dateNotice addObject:[[allLinedStrings objectAtIndex:26] substringFromIndex:34]];
        [catgyNotice addObject:[[allLinedStrings objectAtIndex:22] substringFromIndex:34]];
        [descNotice addObject:[[allLinedStrings objectAtIndex:28] substringFromIndex:34]];
        
        }
        
//                NSLog(@"print line 20 of file %@", [[allLinedStrings objectAtIndex:20] substringFromIndex:34]);
//                NSLog(@"print line 22 of file %@", [[allLinedStrings objectAtIndex:22] substringFromIndex:34]);
//                NSLog(@"print line 24 of file %@", [[allLinedStrings objectAtIndex:24] substringFromIndex:34]);
//                NSLog(@"print line 26 of file %@", [[allLinedStrings objectAtIndex:26] substringFromIndex:34]);
//                NSLog(@"print line 28 of file %@", [[allLinedStrings objectAtIndex:28] substringFromIndex:34]);
        
    }
    
    [descNoticeRaw removeAllObjects];
    [hrefNoticeRaw removeAllObjects];
    
    [tableview1 reloadData];
    
    
    [MBProgressHUD hideHUDForView:self.view  animated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        
        UIAlertView *alertNoInternet = [[UIAlertView alloc] initWithTitle:@"No Internet Connection"
                                                                  message:@"A valid internet connection was not detected. This application relies on an internet connection being available.  Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
        
        //initWithTitle: message: delegate:self cancelButtonTitle: otherButtonTitles:nil];
        // optional - add more buttons:
        [alertNoInternet show];
        
        
    } else {
        
        grpSection.backgroundColor = [UIColor clearColor];
        grpSection.textColor = [UIColor grayColor];
        grpSection.shadowColor = [UIColor whiteColor];
        grpSection.shadowOffset = CGSizeMake(0.0, 1.0);
        grpSection.font = [UIFont boldSystemFontOfSize:16.0f];
        grpSection.text = @"Market Notices"; //sectionHeader;
        
        //    break loading into 2 parts so that we can show the activity indicator
        
        [self loadPart1];
        
        //    NSLog(@"Dates in array : %@", dateNotice);
        //    NSLog(@"Descriptions in array : %@", descNotice);
        //    NSLog(@"Href in array : %@", hrefNotice);
    }
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dateNotice count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [NSString stringWithFormat:@"ID %@\n%@\n%@", [idNotice objectAtIndex:indexPath.row],[dateNotice objectAtIndex:indexPath.row],[catgyNotice objectAtIndex:indexPath.row]];
    cell.textLabel.numberOfLines =4;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
    
    cell.detailTextLabel.text = [descNotice objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines =4;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//    NSString *cellText = [descNotice objectAtIndex:indexPath.row];
//    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
//    CGSize constraintSize = CGSizeMake(250.0f, MAXFLOAT);
//    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeTailTruncation];
//
//    return labelSize.height + 20;
//
////    return 70;
//
//}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    //    Get market notices from aemo
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *urlStringval = [hrefNotice objectAtIndex:indexPath.row];
    
    
    urlString = urlStringval;
    
    
    [self performSegueWithIdentifier:@"toNotice" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([[segue identifier] isEqualToString:@"toNotice"]) {
        NoticeDetailViewController *NoticeVC = [segue destinationViewController];
        
        NoticeVC.noticeURL = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSLog(@"url string final is : %@", urlString);
        
        
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
