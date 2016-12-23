//
//  SubMenuViewController.h
//  Sparky
//
//  Created by Hung on 18/08/12.
//
//

#import <UIKit/UIKit.h>

@interface SubMenuViewController : UIViewController{
    
    NSMutableArray *idNotice;
    NSMutableArray *dateNotice;
    NSMutableArray *catgyNotice;
    NSMutableArray *descNotice;
    NSMutableArray *hrefNotice;
    NSMutableArray *descNoticeRaw;
    NSMutableArray *hrefNoticeRaw;
    
    UILabel *grpSection;
    NSString *urlString;
    
    UITableView *tableview1;
    
}

- (IBAction)done:(id)sender;

@property (nonatomic, strong) NSMutableArray *descNoticeRaw;
@property (nonatomic, strong) NSMutableArray *hrefNoticeRaw;

@property (nonatomic, strong) NSMutableArray *idNotice;
@property (nonatomic, strong) NSMutableArray *dateNotice;
@property (nonatomic, strong) NSMutableArray *catgyNotice;
@property (nonatomic, strong) NSMutableArray *descNotice;
@property (nonatomic, strong) NSMutableArray *hrefNotice;

@property(nonatomic,retain) IBOutlet UILabel *grpSection;

@property(nonatomic,retain) IBOutlet UITableView *tableview1;

@property (nonatomic, copy)  NSString *urlString;

@end
