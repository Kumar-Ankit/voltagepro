//
//  SettingsViewController.h
//  Sparky
//
//  Created by Hung on 28/07/12.
//
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UINavigationControllerDelegate>{
    UILabel *maxPrice;
    
    UIStepper *stepperMaxPrice;
    
    UILabel *maxDemand;
    
    UIStepper *stepperMaxDemand;
    
    UILabel *grpSection;
    
    
}
@property(nonatomic,strong) IBOutlet UILabel *maxPrice;
@property(nonatomic,strong) IBOutlet UIStepper *stepperMaxPrice;
@property(nonatomic,strong) IBOutlet UILabel *maxDemand;
@property(nonatomic,strong) IBOutlet UIStepper *stepperMaxDemand;

-(IBAction)stepperMaxPricePressed:(id) sender;
-(IBAction)stepperMaxDemandPressed:(id) sender;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@property(nonatomic,retain) IBOutlet UILabel *grpSection;

@end



