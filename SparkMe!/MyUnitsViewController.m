//
//  MyUnitsViewController.m
//  Sparky
//
//  Created by Hung on 7/07/13.
//
//

#import "MyUnitsViewController.h"
#import "MBProgressHUD.h"

@interface MyUnitsViewController ()

@end


@implementation MyUnitsViewController

@synthesize mytableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    
    duidComboArray=nil;
    duidGenArray=nil;
    descGenArray=nil;
    
    ownerGenArray=nil;
    fuelGenArray=nil;
    techTypeGenArray=nil;
    
    regCapGenArray=nil;
    maxCapGenArray=nil;
    
    stateGenArray=nil;
    primeTechGenArray=nil;
    stateString=nil;
    
    sortedPreComboArray=nil;
    sortedDuidArray=nil;
    
    selectDuidArray=nil;
    selectIndexArray=nil;
    
    alphabetIndexArray=nil;
    
    mytableView=nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSString *dbPathRes = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"Generators.csv"];
    
    
    //    generation config
    
    NSString *dataGenStr = [NSString stringWithContentsOfFile:dbPathRes encoding:NSUTF8StringEncoding error:nil];
    NSString *dataGenStrStripped2 = [dataGenStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *genInfoArray = [dataGenStrStripped2 componentsSeparatedByString:@"\n"];
    //    NSLog(@"%@", [genInfoArray objectAtIndex:10]);
    
    
    //    NSLog(@"%@", dataStrStripped2);
    
    
    
    //    vic5min = [dataStr componentsSeparatedByString: @","];
    
    
    
    //    NSMutableArray *icArray = [[NSMutableArray alloc] init];
    
    //    dispPrice = [[DispPrice alloc] init];
    //    dispPrice.state = [[NSMutableArray alloc] init];
    //    dispPrice.price = [[NSMutableArray alloc] init];
    //
    //    dispRegion = [[DispRegionSum alloc] init];
    //    dispRegion.state = [[NSMutableArray alloc] init];
    //    dispRegion.totDem = [[NSMutableArray alloc] init];
    //    dispRegion.disGen = [[NSMutableArray alloc] init];
    //    dispRegion.disLoad = [[NSMutableArray alloc] init];
    //    dispRegion.netInchg = [[NSMutableArray alloc] init];
    //
    //    icFlows = [[IcFlows alloc] init];
    //    icFlows.icID = [[NSMutableArray alloc] init];
    //    icFlows.meterFlow = [[NSMutableArray alloc] init];
    //    icFlows.mwFlow = [[NSMutableArray alloc] init];
    //    icFlows.mwLosses = [[NSMutableArray alloc] init];
    //    icFlows.exportLimit = [[NSMutableArray alloc] init];
    //    icFlows.importLimit = [[NSMutableArray alloc] init];
    
    //
    
    selectIndexArray = [[NSMutableArray alloc] init];
    selectDuidArray = [[NSMutableArray alloc] init];
    
    BOOL didRunBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"didRunBefore"];
    
    if (!didRunBefore) {
        //Your Launch Code
        
        selectDuidArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"MyUnitsArray"]];
        selectIndexArray=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedIndexArray"]];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didRunBefore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    
    
    duidComboArray =[[NSMutableArray alloc] init];
    
    duidGenArray =[[NSMutableArray alloc] init];
    descGenArray =[[NSMutableArray alloc] init];
    
    ownerGenArray = [[NSMutableArray alloc] init];
    fuelGenArray = [[NSMutableArray alloc] init];
    techTypeGenArray = [[NSMutableArray alloc] init];
    
    regCapGenArray = [[NSMutableArray alloc] init];
    maxCapGenArray = [[NSMutableArray alloc] init];
    
    stateGenArray = [[NSMutableArray alloc] init];
    primeTechGenArray = [[NSMutableArray alloc] init];
    
    for(int y=1; y<[genInfoArray count]; y++){
        // split generator array into component columns
        NSArray *genComponents = [[genInfoArray objectAtIndex:y] componentsSeparatedByString:@","];
        
        
        // get array of duid numbers
        [duidGenArray addObject:[genComponents objectAtIndex:10]];
        // get array of gen descriptions
        [descGenArray addObject:[genComponents objectAtIndex:1]];
        // get array of gen owner
        [ownerGenArray addObject:[genComponents objectAtIndex:0]];
        // get array of fuel type owner
        [fuelGenArray addObject:[genComponents objectAtIndex:6]];
        // get array of technology type owner
        [techTypeGenArray addObject:[genComponents objectAtIndex:9]];
        // get array of technology type owner
        [regCapGenArray addObject:[genComponents objectAtIndex:11]];
        // get array of technology type owner
        [maxCapGenArray addObject:[genComponents objectAtIndex:12]];
        // get state
        [stateGenArray addObject:[genComponents objectAtIndex:2]];
        // get array of primary technology type owner
        [primeTechGenArray addObject:[genComponents objectAtIndex:8]];
        
        NSString *rows = [NSString stringWithFormat:@"%@ - %@", [genComponents objectAtIndex:10], [genComponents objectAtIndex:1]];
        
        
        [duidComboArray addObject:rows];
        
    }
    
    sortedPreComboArray = [[NSArray alloc] init];
    
    sortedPreComboArray = [duidComboArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    sortedDuidArray = [[NSArray alloc] init];
    
    sortedDuidArray = [duidGenArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    alphabetIndexArray = [[NSMutableArray alloc] init];
    
    
    
    NSMutableArray *tempFirstLetterArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< [sortedDuidArray count]; i++) {
        NSString *letterString = [[sortedDuidArray objectAtIndex:i] substringToIndex:1];
        if (![tempFirstLetterArray containsObject:letterString]) {
            [tempFirstLetterArray addObject:letterString];
        }
    }
    alphabetIndexArray = tempFirstLetterArray;
    tempFirstLetterArray=nil;
    
    
    
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return alphabetIndexArray;
}

- (void)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    
    
    for (int i = 0; i< [sortedDuidArray count]; i++) {
        
        //---Here you return the name i.e. Honda,Mazda and match the title for first letter of name and move to that row corresponding to that indexpath as below---//
        
        NSString *letterString = [[sortedDuidArray objectAtIndex:i] substringToIndex:1];
        if ([letterString isEqualToString:title]) {
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
    }
    
    
    
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [sortedPreComboArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //    NSRange stringRange = {0, MIN([[descGenArray objectAtIndex:indexPath.row] length], 29)};
    //    NSRange stringRange1 = {0, MIN([[ownerGenArray objectAtIndex:indexPath.row] length], 29)};
    
    
    
    
    if ([[stateGenArray objectAtIndex:indexPath.row] length]==1){
        stateString = @"";
    }else {
        stateString = [NSString stringWithFormat:@"(%@)",[[stateGenArray objectAtIndex:indexPath.row] substringToIndex:[[stateGenArray objectAtIndex:indexPath.row] length]-1]];
    }
    
    
    cell.textLabel.text = [sortedPreComboArray objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    cell.textLabel.numberOfLines=1;
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    
    // Assume cell is not checked -- if it is the loop below will check it.
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    for (int i = 0; i < selectIndexArray.count; i++) {
        NSUInteger num = [[selectIndexArray objectAtIndex:i] intValue];
        
        if (num == indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            // Once we find a match there is no point continuing the loop
            break;
        }
    }
    
    
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell accessoryType] == UITableViewCellAccessoryNone) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [selectIndexArray addObject:[NSNumber numberWithInt:(int)indexPath.row]];
        [selectDuidArray addObject:[sortedDuidArray objectAtIndex:indexPath.row]];
        
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [selectIndexArray removeObject:[NSNumber numberWithInt:(int)indexPath.row]];
        [selectDuidArray removeObject:[sortedDuidArray objectAtIndex:indexPath.row]];
        
    }
    
    //
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapSave:(id)sender {
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    NSLog(@"Display duid selection array %@",selectDuidArray);
    
    [[NSUserDefaults standardUserDefaults] setObject:selectDuidArray forKey:@"MyUnitsArray"];
    
    [[NSUserDefaults standardUserDefaults] setObject:selectIndexArray forKey:@"SelectedIndexArray"];
    
    //    NSLog(@"Display duid selection array %@",selectIndexArray);
    
    //    [MBProgressHUD setAnimationDelay:50000];
    
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.labelText = @"Saved";
    
    
    
    [MBProgressHUD  hideHUDForView:self.view  animated:YES];
    
    
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"DoUpdateTable" object:nil userInfo:nil];
    
    
}

- (IBAction)tapClearAll:(id)sender{
    
    [selectDuidArray removeAllObjects];
    [selectIndexArray removeAllObjects];
    
    [mytableView reloadData];
    
}


- (IBAction)tapCancel:(id)sender {
    
    
    //    NSLog(@"Display duid selection array %@",selectIndexArray);
    
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    
}

-(BOOL) shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
    //OR return (UIInterfaceOrientationMaskAll);
}


@end
