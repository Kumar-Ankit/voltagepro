//
//  GenDispGrpViewController.h
//  Sparky
//
//  Created by Hung on 22/08/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "URBSegmentedControl.h"

@interface GenDispGrpViewController : UIViewController{
    NSMutableArray *duidArray;
    NSMutableArray *scadaArray;
    NSMutableArray *descArray;
    
    //    NSMutableArray *duidGenArray;
    //    NSMutableArray *descGenArray;
    //
    NSMutableArray *ownerArray;
    NSMutableArray *fuelArray;
    NSMutableArray *techTypeArray;
    NSMutableArray *primTechTypeArray;
    NSMutableArray *regCapArray;
    NSMutableArray *maxCapArray;
    NSMutableArray *stateArray;
    
    NSMutableArray *alphabetIndexArray;
    
    UITableView *tableview1;
    
    NSString *stateString;
    
    double renewableGen;
    double combustionGen;
    double totalGen;
    double hydroGen;
    double windGen;
    
    NSString *urlString;
    UILabel *dateLastUpdated;
    
    UISegmentedControl *segSortType;
    URBSegmentedControl *segGenFilter;
    
    
    UISwitch *zeroSwitch;
    
    NSInteger minDuidVal;
    
}
- (IBAction)zeroTap:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *zeroSwitch;

@property (nonatomic, strong) NSMutableArray *alphabetIndexArray;

@property (nonatomic, strong) NSMutableArray *duidArray;
@property (nonatomic, strong) NSMutableArray *scadaArray;

@property (nonatomic, strong) NSMutableArray *descArray;

//@property (nonatomic, strong) NSMutableArray *duidGenArray;
//@property (nonatomic, strong) NSMutableArray *descGenArray;

@property (nonatomic, strong) NSMutableArray *ownerArray;
@property (nonatomic, strong) NSMutableArray *fuelArray;
@property (nonatomic, strong) NSMutableArray *techTypeArray;
@property (nonatomic, strong) NSMutableArray *primTechTypeArray;


@property (nonatomic, strong) NSMutableArray *regCapArray;
@property (nonatomic, strong) NSMutableArray *maxCapArray;
@property (nonatomic, strong) NSMutableArray *stateArray;

@property(nonatomic,retain) IBOutlet UITableView *tableview1;
@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;

- (IBAction)carbonIntesityTapped:(id)sender;
- (IBAction)refreshData:(id)sender;

@property (strong, nonatomic) IBOutlet URBSegmentedControl *segGenFilter;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSortType;
- (IBAction)segmentSortTypeTap:(UISegmentedControl *)sender;
- (IBAction)segmentGenFilterTap:(UISegmentedControl *)sender;

@end
