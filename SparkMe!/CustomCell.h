//
//  CustomCell.h
//  Sparky
//
//  Created by Hung on 1/12/12.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell{
    IBOutlet UILabel *consIdLabel;
    IBOutlet UILabel *rhsLabel;
    IBOutlet UILabel *lhsLabel;
    IBOutlet UILabel *effDateLabel;

}

@property (nonatomic,retain) IBOutlet UILabel *consIdLabel;
@property (nonatomic,retain) IBOutlet UILabel *rhsLabel;
@property (nonatomic,retain) IBOutlet UILabel *lhsLabel;
@property (nonatomic,retain) IBOutlet UILabel *effDateLabel;


@end
