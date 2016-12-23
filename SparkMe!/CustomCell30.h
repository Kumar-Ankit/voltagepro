//
//  CustomCell30.h
//  Sparky
//
//  Created by Hung on 21/12/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell30 : UITableViewCell{
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *demandLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *typeLabel;
}

@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *demandLabel;
@property (nonatomic,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic,retain) IBOutlet UILabel *typeLabel;

@end
