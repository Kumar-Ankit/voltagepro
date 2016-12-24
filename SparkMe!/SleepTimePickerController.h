//
//  SleepTimePickerController.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/24/16.
//
//

#import <UIKit/UIKit.h>

typedef enum{
    SleepTimeTypeFrom,
    SleepTimeTypeTo
}SleepTimeType;

@class SleepTimePickerController;

@protocol SleepTimePickerControllerDelegate <NSObject>
- (void)didDismissSleepTimePickerController:(SleepTimePickerController*)controller;
@end

@interface SleepTimePickerController : UITableViewController
@property (nonatomic, weak) id<SleepTimePickerControllerDelegate> delegate;
@end
