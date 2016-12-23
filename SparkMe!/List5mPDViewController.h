//
//  List5mPDViewController.h
//  Sparky
//
//  Created by Hung on 11/07/13.
//
//

#import <UIKit/UIKit.h>

@interface List5mPDViewController : UIViewController{
    
    UILabel *dateLastUpdated;
    UILabel *headerLabels;
    
    //    same for both overview and IC views
    
    NSMutableArray *timeArray;
    NSMutableArray *stateArray;
    NSInteger priceIndex;
    
    //    for overview view
    
    NSMutableArray *ichgArray;
    NSMutableArray *genArray;
    NSMutableArray *demandArray;
    NSMutableArray *priceArray;
    
    //    for IC view
    NSMutableArray *mwFlowArray;
    NSMutableArray *mwLossesArray;
    NSMutableArray *exportLimitArray;
    NSMutableArray *importLimitArray;
    NSMutableArray *EXPORTGENCONID_Array;
    NSMutableArray *IMPORTGENCONID_Array;
    
    UITableView *mytableView;
    
    UISegmentedControl *segVal;
    
}
// Region   Period         Price     Dem.    Gen.    Ichg.
@property (nonatomic,strong) IBOutlet UITableView *mytableView;
@property (nonatomic, strong) IBOutlet UILabel *dateLastUpdated;
@property (nonatomic, strong) IBOutlet UILabel *headerLabels;

@property (nonatomic,strong) IBOutlet UISegmentedControl *segVal;

-(IBAction)segmentControlTap:(UISegmentedControl *)sender;

-(IBAction)refreshData:(id)sender;
@end
