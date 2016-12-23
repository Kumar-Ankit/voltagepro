//
//  UnderRightViewController.h
//  Sparky
//
//  Created by Hung on 28/04/13.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface UnderRightViewController : UIViewController<UITableViewDataSource, UITabBarControllerDelegate>{
    
    UITableView *mytableView;
    
}

- (IBAction)scrollBottom:(id)sender;
- (IBAction)scrollTop:(id)sender;
@property (nonatomic, assign) CGFloat peekLeftAmount;
@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic,strong) IBOutlet UITableView *mytableView;



@end
