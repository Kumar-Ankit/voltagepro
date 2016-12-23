//
//  CustomCell5.h
//  Sparky
//
//  Created by Hung on 21/12/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell5 : UITableViewCell{
IBOutlet UILabel *dateLabel;
IBOutlet UILabel *demandLabel;
IBOutlet UILabel *priceLabel;

}

@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UILabel *demandLabel;
@property (nonatomic,retain) IBOutlet UILabel *priceLabel;

@end
