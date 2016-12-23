/*
 Copyright 2009-2012 Urban Airship Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

//#import "UAirship.h"
//#import "UAPush.h"
//#import "UAPushUI.h"
//#import "UALocationService.h"

#import "UAPushSettingsViewController.h"
#import <Parse/Parse.h>

// Overall counts for sectioned table view
enum {
    SectionPushEnabled = 0,
    SectionTagsEnabled = 1,
    SectionNegTagsEnabled = 2,
    SectionQuietTime   = 3,
    SectionCount       = 4
};

// The section for the push enabled switch is 0
// The row count for the push table view is 1
enum {
    PushEnabledSectionSwitchCell = 0,
    PushEnabledSectionRowCount   = 1
};

// The section for the Airship is 1
// The row count is one
//static NSUInteger AirshipLocationEnabledSectionSwitchCell = 1;
//static NSUInteger AirshipLocationEnabledSectionRowCount = 1;

// Enums for the Tags table view
enum {
    TagsAllPriceSectionSwitchCell   = 0,
    TagsNSW300Cell                  = 1,
    TagsQLD300Cell                  = 2,
    TagsSA300Cell                   = 3,
    TagsTAS300Cell                  = 4,
    TagsVIC300Cell                  = 5,
    TagsSectionRowCount             = 6
};

// Enums for the Quiet time table view
enum {
    QuietTimeSectionSwitchCell  = 0,
    QuietTimeSectionStartCell   = 1,
    QuietTimeSectionEndCell     = 2,
    QuietTimeSectionRowCount    = 3
};

@implementation UAPushSettingsViewController

@synthesize tableView;
@synthesize datePicker;

@synthesize pushEnabledCell;
@synthesize pushEnabledLabel;
@synthesize pushEnabledSwitch;

@synthesize quietTimeEnabledCell;
@synthesize quietTimeLabel;
@synthesize quietTimeSwitch;
@synthesize fromCell;
@synthesize toCell;

@synthesize nsw300Cell;
@synthesize qld300Cell;
@synthesize sa300Cell;
@synthesize tas300Cell;
@synthesize vic300Cell;


@synthesize airshipLocationEnabledSwitch = airshipLocationEnabledSwitch_;
@synthesize airshipLocationEnabledLabel = airshipLocationEnabledLabel_;
@synthesize airshipLocationEnabledCell = airshipLocationEnabledCell_;

#pragma mark -
#pragma mark Lifecycle methods

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
////    if (section == 0)
////        return 1.0f;
//    return 32.0f;
//
//
//}

-(BOOL) shouldAutorotate {
    return NO;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
    [self initViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

- (void)viewDidUnload {
    
    self.pushEnabledSwitch = nil;
    self.pushEnabledLabel = nil;
    self.pushEnabledCell = nil;
    
    self.nsw300Cell = nil;
    self.qld300Cell = nil;
    self.sa300Cell = nil;
    self.tas300Cell = nil;
    self.vic300Cell = nil;
    
    
    self.quietTimeSwitch = nil;
    self.quietTimeLabel = nil;
    self.quietTimeEnabledCell = nil;
    self.toCell = nil;
    self.fromCell = nil;
    
    self.tableView = nil;
    self.datePicker = nil;
    self.airshipLocationEnabledSwitch = nil;
    self.airshipLocationEnabledLabel = nil;
    self.airshipLocationEnabledCell = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //Hide the picker if it was left up last time
    [self updateDatePicker:NO];
    
    [super viewWillAppear:animated];
    
    
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    //if shown, update picker and scroll offset
    if (pickerDisplayed) {
        [self updateDatePicker:YES];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (pushEnabledSwitch.on) {
        return SectionCount - 1;
    } else {
        return SectionCount - 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    switch (section) {
        case SectionPushEnabled:
            return @"Turn on/off price alerts ;-)";
            break;
        case SectionTagsEnabled:
            return @"Select the state(s) you wish to receive a high price notification for.";
            break;
        case SectionNegTagsEnabled:
            return @"Notify me of negative prices for any state.";
            break;
        case SectionQuietTime:
            return @"Local time when no price notifications will be delivered.";
            break;
        default:
            return nil;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionPushEnabled:
            return PushEnabledSectionRowCount;
        case SectionTagsEnabled:
        {
            if (pushEnabledSwitch.on && tagsEnabledSwitch.on) {
                return 1;
            } else if (pushEnabledSwitch.on) {
                return TagsSectionRowCount;
            }
        }
        case SectionNegTagsEnabled:
        {
            if (pushEnabledSwitch.on) {
                return 1;
            } else return 1;
        }
            
        case SectionQuietTime:
        {
            if (pushEnabledSwitch.on && quietTimeSwitch.on) {
                return QuietTimeSectionRowCount;
            } else if (pushEnabledSwitch.on) {
                return 1;
            }
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SectionQuietTime) {
        if (indexPath.row == QuietTimeSectionSwitchCell) {
            quietTimeEnabledCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return quietTimeEnabledCell;
        } else if (indexPath.row == QuietTimeSectionStartCell) {
            return fromCell;
        } else {
            return toCell;
        }
    } else if (indexPath.section == SectionPushEnabled) {
        return pushEnabledCell;
    } else if (indexPath.section == SectionNegTagsEnabled) {
        return negtagsEnabledCell;
        
    } else if (indexPath.section == SectionTagsEnabled) {
        if (indexPath.row == TagsAllPriceSectionSwitchCell) {
            tagsEnabledCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return tagsEnabledCell;
        } else if (indexPath.row == TagsNSW300Cell) {
            return nsw300Cell;
        } else if (indexPath.row == TagsQLD300Cell) {
            return qld300Cell;
        } else if (indexPath.row == TagsSA300Cell) {
            return sa300Cell;
        } else if (indexPath.row == TagsTAS300Cell) {
            return tas300Cell;
        } else if (indexPath.row == TagsVIC300Cell) {
            return vic300Cell;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark UITableVieDelegate Methods
- (void)tableView:(UITableView *)view didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionQuietTime){
        if (indexPath.row == 1 || indexPath.row == 2) {
            [self updateDatePicker:YES];
        } else {
            [self updateDatePicker:NO];
        }
    } else if (indexPath.section == SectionTagsEnabled){
        if (indexPath.row != 0){
            UITableViewCell *cellCheck = [view cellForRowAtIndexPath:indexPath];
            cellCheck.selectionStyle = UITableViewCellSelectionStyleNone;
            //            NSLog(@"index row path is %long", indexPath.row);
            if (cellCheck.accessoryType==UITableViewCellAccessoryCheckmark){
                cellCheck.accessoryType=UITableViewCellAccessoryNone;
                
            } else {
                cellCheck.accessoryType=UITableViewCellAccessoryCheckmark;
                
            }
            
            
        }
        
        
    }
    
}

// UA_Push_Settings_Location_Enabled_Label
#pragma mark -
#pragma mark logic

- (void)tableView:(UITableView *)view willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    UITableViewCell *cellCheck = [view cellForRowAtIndexPath:indexPath];
    //
    //    if (indexPath.section == SectionTagsEnabled){
    //        if (indexPath.row == 1) {
    //
    ////            NSW tag
    //
    //            cellCheck.accessoryType=UITableViewCellAccessoryCheckmark;
    //
    //
    //        } else {
    //            cellCheck.accessoryType=UITableViewCellAccessoryNone;
    //        }
    //
    //    } else return;
    
    
}

- (void)initViews {
    //    self.title = UA_PU_TR(@"UA_Push_Settings_Title");
    self.title=@"Notification Settings";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(quit)];
    
    
    
    // Register for Push Notitications, if running iOS 8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        if (type == UIRemoteNotificationTypeNone ) {
            pushEnabledSwitch.on = NO;
            NSLog(@"Push Not Enabled");
            
        } else {
            pushEnabledSwitch.on = YES;
            NSLog(@"Push Enabled");
            
        }
        
    }
    else {
        
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type & UIRemoteNotificationTypeAlert)
        {
            pushEnabledSwitch.on = NO;
            NSLog(@"Push Not Enabled");
        }else{
            
            pushEnabledSwitch.on = YES;
            NSLog(@"Push Enabled");
            
            
        }
        
        
    }
    
    //    if ([UALocationService airshipLocationServiceEnabled]) {
    //        airshipLocationEnabledSwitch_.on = YES;
    //    }
    //    else {
    //        airshipLocationEnabledSwitch_.on = NO;
    //    }
    
    
    
    pushEnabledLabel.text = @"Push Enabled";
    quietTimeLabel.text = @"Quiet Time";
    
    
    
    fromCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    toCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    fromCell.textLabel.text = @"Quiet Time From";
    toCell.textLabel.text = @"Quiet Time To";
    
    negtagsEnabledLabel.text = @"Any State < -$40/MWh";
    tagsEnabledLabel.text = @"Any State > $300/MWh";
    
    nsw300Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    qld300Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    sa300Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    tas300Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    vic300Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    nsw300Cell.textLabel.text =@"NSW Price > $300";
    qld300Cell.textLabel.text = @"QLD Price > $300";
    sa300Cell.textLabel.text = @"SA  Price > $300";
    tas300Cell.textLabel.text = @"TAS Price > $300";
    vic300Cell.textLabel.text = @"VIC Price > $300";
    
    //    need to set neg switch value according to UA server
    
    if ([[PFInstallation currentInstallation].channels containsObject:@"NEG40"]){
        negtagsEnabledSwitch.on = YES;
        
        NSLog(@"NEG40 exists in tag list");
    } else {
        negtagsEnabledSwitch.on = NO;
    }
    
    //    need to set checkmark according to what tags currently defined by UA server
    
    tagsEnabledSwitch.on = NO;
    
    if ([[PFInstallation currentInstallation].channels containsObject:@"NSW300"]){
        nsw300Cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
        NSLog(@"NSW300 exists in tag list");
    } else {
        nsw300Cell.accessoryType=UITableViewCellAccessoryNone;
    }
    if ([[PFInstallation currentInstallation].channels containsObject:@"QLD300"]){
        qld300Cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if ([[PFInstallation currentInstallation].channels containsObject:@"SA300"]){
        sa300Cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if ([[PFInstallation currentInstallation].channels containsObject:@"TAS300"]){
        tas300Cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    if ([[PFInstallation currentInstallation].channels containsObject:@"VIC300"]){
        vic300Cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    
    
    
    //    NSDate *date1 = nil;
    //    NSDate *date2 = nil;
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    //
    //
    //    NSDictionary *quietTime = [[UAPush shared] quietTime];
    //    [formatter setDateFormat:@"HH:mm"];
    //    quietTimeSwitch.on = [UAPush shared].quietTimeEnabled;
    //    if (quietTime != nil) {
    //        UALOG(@"Quiet time dict found: %@ to %@", [quietTime objectForKey:@"start"], [quietTime objectForKey:@"end"]);
    //        date1 = [formatter dateFromString:[quietTime objectForKey:@"start"]];
    //        date2 = [formatter dateFromString:[quietTime objectForKey:@"end"]];
    //    }
    //
    //    if (date1 == nil || date2 == nil) {
    //        date1 = [formatter dateFromString:@"22:00"];//default start
    //        date2 = [formatter dateFromString:@"07:00"];//default end //TODO: make defaults parameters
    //    }
    //
    //    [formatter setLocale:[NSLocale currentLocale]];
    //    [formatter setDateStyle:NSDateFormatterNoStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    fromCell.detailTextLabel.text = [formatter stringFromDate:date1];
    //    toCell.detailTextLabel.text = [formatter stringFromDate:date2];
    //
    //    NSDate *now = [[NSDate alloc] init];
    //    [datePicker setDate:now animated:NO];
    //    now=nil;
    //
    //    pickerDisplayed = NO;
    //    pickerShownFrame = CGRectZero;
    //    pickerHiddenFrame = CGRectZero;
    
    [self.view setNeedsLayout];
}

- (void)updatePickerLayout {
    
    
    CGRect viewBounds = self.view.bounds;
    
    //Manually set the size of the picker for better landscape experience
    //Older  devies do not like the custom size. It breaks the picker.
    
    //If the picker is in a portrait container, use std portrait picker dims
    
    if (viewBounds.size.height >= viewBounds.size.width) {
        self.datePicker.bounds = CGRectMake(0, 0, 320, 216);
    } else {
        self.datePicker.bounds = CGRectMake(0, 0, 480, 162);
    }
    
    // reset picker subviews
    for (UIView* subview in self.datePicker.subviews) {
        subview.frame = self.datePicker.bounds;
    }
    
    // reset the visible/hidden views
    int viewOffset = self.view.frame.origin.y;
    CGRect pickerBounds = self.datePicker.bounds;
    pickerShownFrame = CGRectMake(0, viewOffset+viewBounds.size.height-pickerBounds.size.height,
                                  viewBounds.size.width, pickerBounds.size.height);
    pickerHiddenFrame = CGRectMake(0, viewOffset+viewBounds.size.height,
                                   viewBounds.size.width, pickerBounds.size.height);
    
    //reset actual frame
    if (pickerDisplayed) {
        datePicker.frame = pickerShownFrame;
    } else {
        datePicker.frame = pickerHiddenFrame;
    }
}

- (IBAction)quit {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self updateTags];
    
    if (dirty && pushEnabledSwitch.on) {
        
        
        // Register for Push Notitications, if running iOS 8
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
        }
        else {
            
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                                   UIRemoteNotificationTypeAlert |
                                                                                   UIRemoteNotificationTypeSound)];
            
        }
        
        
        
    }
    
    if (dirty && !pushEnabledSwitch.on) {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        NSLog(@"UnRegistered for pushnotification");
    }
    
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)pickerValueChanged:(id)sender {
    
    dirty = YES;
    
    NSDate *date = [datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSInteger row = (NSInteger)[[self.tableView indexPathForSelectedRow] row];
    if (row == QuietTimeSectionStartCell) {
        fromCell.detailTextLabel.text = [formatter stringFromDate:date];
        [fromCell setNeedsLayout];
    } else if (row == QuietTimeSectionEndCell) {
        toCell.detailTextLabel.text = [formatter stringFromDate:date];
        [toCell setNeedsLayout];
    } else {
        NSDate *now = [[NSDate alloc] init];
        [datePicker setDate:now animated:YES];
        now = nil;
        return;
    }
    
}

- (IBAction)switchValueChanged:(id)sender {
    
    dirty = YES;
    
    //    tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    
    if (!quietTimeSwitch.on || !pushEnabledSwitch.on) {
        [self updateDatePicker:NO];
    }
    [self.tableView reloadData];
    
    
    //    if (airshipLocationEnabledSwitch_.on){
    //        [UALocationService setAirshipLocationServiceEnabled:YES];
    //    }
    //    else {
    //        [UALocationService setAirshipLocationServiceEnabled:NO];
    //    }
    
    //    if (negtagsEnabledSwitch.on){
    //
    //        //        check if tag exists.
    //
    //        if([[UAPush shared].tags containsObject:@"NEG40"]){
    //
    //
    //            NSLog(@"NEG40 already exists");
    //
    //        } else {
    //            [[UAPush shared] addTagToCurrentDevice:@"NEG40"];
    //
    //            [[UAPush shared] updateRegistration];
    //
    //            NSLog(@"NEG40 added to list");
    //        }
    //
    //
    //
    //    }
    //    else {
    //
    ////        check if tag exists before removing it.
    //
    //        if([[UAPush shared].tags containsObject:@"NEG40"]){
    //
    //            [[UAPush shared] removeTagFromCurrentDevice:@"NEG40"];
    //            NSLog(@"NEG40 removed from list");
    //            [[UAPush shared] updateRegistration];
    //
    //        }
    //
    //    }
    
    //    if (pushEnabledSwitch.on && negtagsEnabledSwitch.on && tagsEnabledSwitch.on){
    //
    //        tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    //
    //        NSLog(@"neg tag switch turned on");
    //
    //    } else if (pushEnabledSwitch.on && negtagsEnabledSwitch.on && !tagsEnabledSwitch.on){
    //
    //        tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    //
    //    } else if(pushEnabledSwitch.on && !negtagsEnabledSwitch.on && !tagsEnabledSwitch.on) {
    //
    //        tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    //
    //    } else if (pushEnabledSwitch.on && !negtagsEnabledSwitch.on && tagsEnabledSwitch.on ){
    //        tableView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    //    }
    //
    
    
    
    if (tagsEnabledSwitch.on){
        nsw300Cell.accessoryType = UITableViewCellAccessoryCheckmark;
        qld300Cell.accessoryType = UITableViewCellAccessoryCheckmark;
        sa300Cell.accessoryType = UITableViewCellAccessoryCheckmark;
        tas300Cell.accessoryType = UITableViewCellAccessoryCheckmark;
        vic300Cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSLog(@"tag switch turned on");
        
    }
    
    
    
}

- (void)updateDatePicker:(BOOL)show {
    
    [self updatePickerLayout];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    if (show) {
        [self.view addSubview:datePicker];
        pickerDisplayed = YES;
        datePicker.frame = pickerShownFrame;
        
        //Scroll the table view so the "To" field is just above the top of the data picker
        int scrollOffset = MAX(0,
                               toCell.frame.origin.y
                               + toCell.frame.size.height
                               + tableView.sectionFooterHeight
                               - datePicker.frame.origin.y);
        tableView.contentOffset = CGPointMake(0, scrollOffset);
    } else {
        pickerDisplayed = NO;
        tableView.contentOffset = CGPointZero;//reset scroll offset
        datePicker.frame = pickerHiddenFrame;
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    }
    [UIView commitAnimations];
    
    //remove picker display after animation
    if (!pickerDisplayed) {
        [datePicker removeFromSuperview];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *fromString = fromCell.detailTextLabel.text;
    NSString *toString = toCell.detailTextLabel.text;
    
    NSInteger row = (NSInteger)[[self.tableView indexPathForSelectedRow] row];
    if (row == 1 && [fromString length] != 0) {
        NSDate *fromDate = [formatter dateFromString:fromString];
        [datePicker setDate:fromDate animated:YES];
    } else if (row == 2 && [toString length] != 0) {
        NSDate *toDate = [formatter dateFromString:toString];
        [datePicker setDate:toDate animated:YES];
    }
}

//- (void)updateQuietTime {
//
//    if (quietTimeSwitch.on) {
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterNoStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//
//        NSString *fromString = fromCell.detailTextLabel.text;
//        NSString *toString = toCell.detailTextLabel.text;
//        NSDate *fromDate = [formatter dateFromString:fromString];
//        NSDate *toDate = [formatter dateFromString:toString];
//
//        UALOG(@"Start String: %@", fromString);
//        UALOG(@"End String: %@", toString);
//
//        [UAPush shared].quietTimeEnabled = YES;
//        [[UAPush shared] setQuietTimeFrom:fromDate to:toDate withTimeZone:[NSTimeZone localTimeZone]];
//        [[UAPush shared] updateRegistration];
//    } else {
//        [UAPush shared].quietTimeEnabled = NO;
//        [[UAPush shared] updateRegistration];
//    }
//
//
//}

- (void)updateTags {
    
    
    
    if (tagsEnabledSwitch.on) {
        
        //        if switch is on then assign all states tags
        
        
        NSArray *tagUpdate = [[NSArray alloc] initWithObjects:@"NSW300",@"QLD300",@"SA300",@"TAS300",@"VIC300",nil];
        
        //       [[UAPush shared] setTags:tagUpdate];
        
        //       [[UAPush shared] updateRegistration]; //update server
        
        // When users indicate they are Giants fans, we subscribe them to that channel.
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setChannels:tagUpdate];
        [currentInstallation saveInBackground];
        
        
        tagUpdate=nil;
        
        
        
        //        NSLog(@"All states tags updated");
        
    } else {
        
        //        remove all tags, then add each one individually
        
        NSArray *tagDelete = [[NSArray alloc] initWithObjects:@"NSW300",@"QLD300",@"SA300",@"TAS300",@"VIC300",nil];
        
        //        NSArray *tagDelete = [[NSArray alloc] initWithObjects:@"DUMMY",@"QLD300",@"SA300",@"TAS300",@"VIC300",nil];
        
        //      [[UAPush shared] removeTagsFromCurrentDevice:tagDelete];
        
        
        //below code unsubscribes from all channels
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        currentInstallation.channels = [NSArray array];
        [currentInstallation saveInBackground];
        
        
        //        NSLog(@"All states tags removed");
        
        NSMutableArray* tagUpdates = [[NSMutableArray alloc] init];
        tagDelete = nil;
        
        
        if(nsw300Cell.accessoryType==UITableViewCellAccessoryCheckmark){
            NSLog(@"NSW checked");
            
            [tagUpdates addObject:@"NSW300"];
            
            //   [tagUpdates addObject:@"DUMMY"];
            
        }
        if(qld300Cell.accessoryType==UITableViewCellAccessoryCheckmark){
            NSLog(@"QLD checked");
            
            [tagUpdates addObject:@"QLD300"];
        }
        if(sa300Cell.accessoryType==UITableViewCellAccessoryCheckmark){
            NSLog(@"SA checked");
            
            [tagUpdates addObject:@"SA300"];
        }
        if(tas300Cell.accessoryType==UITableViewCellAccessoryCheckmark){
            NSLog(@"TAS checked");
            
            [tagUpdates addObject:@"TAS300"];
        }
        if(vic300Cell.accessoryType==UITableViewCellAccessoryCheckmark){
            NSLog(@"VIC checked");
            
            [tagUpdates addObject:@"VIC300"];
        }
        
        //      now add each one individually
        
        NSLog(@"Tag Updates List is %@",tagUpdates);
        //        [[UAPush shared] setTags:tagUpdates];
        
        //        [[UAPush shared] updateRegistration];
        
        
        [currentInstallation setChannels:tagUpdates];
        [currentInstallation saveInBackground];
        
        tagUpdates=nil;
        
        
    }
    
    
    if (negtagsEnabledSwitch.on){
        
        //        check if tag exists.
        
        if([[PFInstallation currentInstallation].channels containsObject:@"NEG40"]){
            
            
            NSLog(@"NEG40 already exists");
            
        } else {
            [[PFInstallation currentInstallation] addUniqueObject:@"NEG40" forKey:@"channels"];
            
            [[PFInstallation currentInstallation] saveInBackground];
            
            NSLog(@"NEG40 added to list");
        }
        
        
        
    }
    else {
        
        //        check if tag exists before removing it.
        
        if([[PFInstallation currentInstallation].channels containsObject:@"NEG40"]){
            
            [[PFInstallation currentInstallation] removeObject:@"NEG40" forKey:@"channels"];
            
            [[PFInstallation currentInstallation] saveInBackground];
            NSLog(@"NEG40 removed from list");
            
            
        }
        
    }
}

@end
