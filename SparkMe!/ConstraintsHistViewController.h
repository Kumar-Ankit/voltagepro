//
//  ConstraintsViewController.h
//  Sparky
//
//  Created by Hung on 1/12/12.
//
//

#import <UIKit/UIKit.h>
#import "DispConstraint.h"
#import <QuartzCore/QuartzCore.h>

@interface ConstraintsHistViewController : UIViewController{
    UILabel *dateLastUpdated;
    DispConstraint *dispCons;
    NSInteger priceIndex;
    NSInteger blockedConsIndex;
    NSInteger endConsIndex;
    
    UITableView *tableview2;
    UIButton *descLabel;
    
    NSInteger gradIndex;
    
    NSInteger tableRowIndex;
    
    NSInteger dIndex;
    NSInteger fIndex;
    NSInteger nIndex;
    NSInteger qIndex;
    NSInteger sIndex;
    NSInteger tIndex;
    NSInteger vIndex;
    UISegmentedControl *segSection;
    NSIndexPath *scrollIndexPath;
    
    UISegmentedControl *segConsCond;
    
    UILabel *lhsToMarginalLabel;
    UILabel *rhsToComboLabel;
    
    NSMutableArray *alphabetIndexArray;
    
}

@property (nonatomic, strong) NSMutableArray *alphabetIndexArray;

@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;

@property (nonatomic, strong) IBOutlet UILabel *lhsToMarginalLabel;

@property (nonatomic, strong) IBOutlet UILabel *rhsToComboLabel;

@property (nonatomic, strong) DispConstraint *dispCons;

@property(nonatomic,retain) IBOutlet UITableView *tableview2;

@property(nonatomic,retain) IBOutlet UIButton *descLabel;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segSection;
- (IBAction)segmentControlTap:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segConsCond;
- (IBAction)segmentConsCondTap:(UISegmentedControl *)sender;

@end



