//
//  CustomCell5PD.h
//  Sparky
//
//  Created by Hung on 11/07/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell5PD : UITableViewCell{
    IBOutlet UILabel *stateLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *demandLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *genLabel;
    IBOutlet UILabel *ichgLabel;
}

@property (nonatomic,retain) IBOutlet UILabel *stateLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *demandLabel;
@property (nonatomic,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic,retain) IBOutlet UILabel *genLabel;
@property (nonatomic,retain) IBOutlet UILabel *ichgLabel;
@end
