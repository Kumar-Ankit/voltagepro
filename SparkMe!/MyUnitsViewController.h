//
//  MyUnitsViewController.h
//  Sparky
//
//  Created by Hung on 7/07/13.
//
//

#import <UIKit/UIKit.h>

@interface MyUnitsViewController : UIViewController{

    NSMutableArray *duidComboArray;
    NSMutableArray *duidGenArray;
    NSMutableArray *descGenArray;
    
    NSMutableArray *ownerGenArray;
    NSMutableArray *fuelGenArray;
    NSMutableArray *techTypeGenArray;
    
    NSMutableArray *regCapGenArray;
    NSMutableArray *maxCapGenArray;
    
    NSMutableArray *stateGenArray;
    NSMutableArray *primeTechGenArray;
    NSString *stateString;
    
    NSArray *sortedPreComboArray;
    NSArray *sortedDuidArray;
    
    NSMutableArray *selectDuidArray;
    NSMutableArray *selectIndexArray;

    NSMutableArray *alphabetIndexArray;
    
    UITableView *mytableView;
    

}
- (IBAction)tapSave:(id)sender;
- (IBAction)tapCancel:(id)sender;
- (IBAction)tapClearAll:(id)sender;

@property (nonatomic,strong) IBOutlet UITableView *mytableView;

@end
