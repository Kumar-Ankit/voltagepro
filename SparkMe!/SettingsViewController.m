//
//  SettingsViewController.m
//  Sparky
//
//  Created by Hung on 28/07/12.
//
//

#import "SettingsViewController.h"
#import "List30minViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize stepperMaxPrice, maxPrice, maxDemand, stepperMaxDemand, grpSection;




-(IBAction)stepperMaxPricePressed:(id) sender
{
    maxPrice.text=[NSString stringWithFormat:@"%.0f",stepperMaxPrice.value];
    NSLog(@"%f",stepperMaxPrice.value);
    
}

-(IBAction)stepperMaxDemandPressed:(id) sender
{
    maxDemand.text=[NSString stringWithFormat:@"%.0f",stepperMaxDemand.value];
    NSLog(@"%f",stepperMaxDemand.value);
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)done:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setDouble:stepperMaxPrice.value  forKey:@"myMaxPrice"];
    [[NSUserDefaults standardUserDefaults] setDouble:stepperMaxDemand.value  forKey:@"myMaxDemand"];
    
    
    NSLog(@"User Defaults Saved MaxPrice %f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]);
    NSLog(@"User Defaults Saved MaxDemand %f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DoUpdateLabel" object:nil userInfo:nil];
    
  	 [self dismissViewControllerAnimated:YES completion:Nil];
    
    
    
    //    need to save settings
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.7098 green:0.7176 blue:0.7412 alpha:1];
    
    grpSection.backgroundColor = [UIColor clearColor];
    grpSection.textColor = [UIColor grayColor];
    grpSection.shadowColor = [UIColor whiteColor];
    grpSection.shadowOffset = CGSizeMake(0.0, 1.0);
    grpSection.font = [UIFont boldSystemFontOfSize:20.0f];
    grpSection.text = @"Conditional Formatting Settings"; //sectionHeader;
    
    
    maxPrice.text=[NSString stringWithFormat:@"%.0f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"]];
    maxDemand.text=[NSString stringWithFormat:@"%.0f",[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"]];
    stepperMaxPrice.value=[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxPrice"];
    stepperMaxDemand.value=[[NSUserDefaults standardUserDefaults] doubleForKey:@"myMaxDemand"];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
