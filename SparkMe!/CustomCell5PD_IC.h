//
//  CustomCell5PD_IC.h
//  Sparky
//
//  Created by Hung on 5/09/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell5PD_IC : UITableViewCell{
    IBOutlet UILabel *stateLabel;
    IBOutlet UILabel *dateLabel;
    
    IBOutlet UILabel *mwFlowLabel;
//    IBOutlet UILabel *mwLossesLabel;
    IBOutlet UILabel *exportLimitLabel;
    IBOutlet UILabel *importLimitLabel;
    
    
    
}

@property (nonatomic,retain) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;



@property (nonatomic,retain) IBOutlet UILabel *mwFlowLabel;
//@property (nonatomic,retain) IBOutlet UILabel *mwLossesLabel;
@property (nonatomic,retain) IBOutlet UILabel *exportLimitLabel;
@property (nonatomic,retain) IBOutlet UILabel *importLimitLabel;



@end

