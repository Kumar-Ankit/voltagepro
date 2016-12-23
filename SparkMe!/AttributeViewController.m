//
//  AttributeViewController.m
//  Sparky
//
//  Created by Hung on 24/08/12.
//
//

#import "AttributeViewController.h"
#import "Utility.h"

@interface AttributeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@end

@implementation AttributeViewController

@synthesize blurView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)done:(id)sender{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.7098 green:0.7176 blue:0.7412 alpha:1];
    blurView.translucentAlpha = 0.65;
    blurView.translucentStyle = UIBarStyleDefault;
    blurView.translucentTintColor = [UIColor clearColor];
    blurView.backgroundColor = [UIColor clearColor];
    
    self.helpLabel.numberOfLines = 0;
    self.helpLabel.attributedText = [self getAttributedString];
}


- (NSAttributedString *)getAttributedString
{
    UIImage *imgRedBar = [UIImage imageNamed:@"redBar"];
    UIImage *imgYellowBar = [UIImage imageNamed:@"yellowBar"];
    UIImage *imgRedArrow = [UIImage imageNamed:@"right-arrow-3"];
    UIImage *imgYellowArrow = [UIImage imageNamed:@"right-arrow-3-yellow"];
    UIImage *imgYellowBar2 = [UIImage imageNamed:@"yellowBar2"];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = imgYellowBar;
    attachment.bounds = (CGRect) {0, 0, imgYellowBar.size};
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] init];
    NSString *string = @"Some helpful hints to navigate this page:\n\n1. Tapping on the Interconnector (IC) arrows will bring up Interconnector flows. This will also include a description of the constraint equations that are setting the Export and Import limits for that IC \n\n2. Interconnector Lines:\nYellow Line  ";
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    
    [myString appendAttributedString:attrString];
    [myString appendAttributedString:attachmentString];
    
    string = @"  IC flows from low price region to high price region.\nRed Line ";

    attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    
    NSTextAttachment *attachment2 = [[NSTextAttachment alloc] init];
    attachment2.image = imgRedBar;
    attachment2.bounds = (CGRect) {0, 0, imgRedBar.size};
    attachmentString = [NSAttributedString attributedStringWithAttachment:attachment2];
    
    [myString appendAttributedString:attrString];
    [myString appendAttributedString:attachmentString];
    
    
    string = @"  IC flows from high price region to low price region.\n\n3. Interconnector Arrows:\nYellow Arrow";
    attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    
    NSTextAttachment *attachment3 = [[NSTextAttachment alloc] init];
    attachment3.image = imgYellowArrow;
    attachment3.bounds = (CGRect) {0, 0, imgYellowArrow.size};
    attachmentString = [NSAttributedString attributedStringWithAttachment:attachment3];
    
    [myString appendAttributedString:attrString];
    [myString appendAttributedString:attachmentString];

    string = @" Unconstrained IC flow.\nRed Arrow";
    attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    
    NSTextAttachment *attachment4 = [[NSTextAttachment alloc] init];
    attachment4.image = imgRedArrow;
    attachment4.bounds = (CGRect) {0, 0, imgRedArrow.size};
    attachmentString = [NSAttributedString attributedStringWithAttachment:attachment4];
    
    [myString appendAttributedString:attrString];
    [myString appendAttributedString:attachmentString];

    
    string = @" Constrained IC flow.  Where MW Flow either equals Export Limit or Import Limit\nDouble lines ";
    attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    
    NSTextAttachment *attachment5 = [[NSTextAttachment alloc] init];
    attachment5.image = imgYellowBar2;
    attachment5.bounds = (CGRect) {0, 0, imgYellowBar2.size};
    attachmentString = [NSAttributedString attributedStringWithAttachment:attachment5];
    
    [myString appendAttributedString:attrString];
    [myString appendAttributedString:attachmentString];

    string = @" indicate zero ( 0 MW ) interconnector flow.";
    attrString = [[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : REGULAR(13.0), NSParagraphStyleAttributeName : style}];
    [myString appendAttributedString:attrString];
    
    return myString;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) shouldAutorotate {
    return NO;
}

@end
