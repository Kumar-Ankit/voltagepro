//
//  MenuViewController.h
//  SparkMe!
//
//  Created by Hung on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "JHTickerView.h"
#import "ILTranslucentView.h"

@interface MenuViewController : UIViewController{
    UIButton *phanalytics;
    UILabel *sparky;
    
    UIButton *marketSnapshot;
    UIButton *interConnect;
    UIButton *tradingData;
    UIButton *last24Data;
    UIButton *data5minPD;
    UIButton *marketNotice;
    UIButton *generatorLabel;
    
    UIButton *pushSettings;
    
    
    JHTickerView *ticker;
    NSInteger gradIndex;
    
    ILTranslucentView *blurView;
    
}

@property(nonatomic,retain) IBOutlet UIButton *pushSettings;

@property(nonatomic,retain) IBOutlet UIButton *phanalytics;
@property(nonatomic,retain) IBOutlet UILabel *sparky;

@property(nonatomic,retain) IBOutlet UIButton *marketSnapshot;
@property(nonatomic,retain) IBOutlet UIButton *tradingData;
@property(nonatomic,retain) IBOutlet UIButton *last24Data;
@property(nonatomic,retain) IBOutlet UIButton *interConnect;

@property(nonatomic,retain) IBOutlet UIButton *marketNotice;
@property(nonatomic,retain) IBOutlet UIButton *generatorLabel;

@property(nonatomic,retain) IBOutlet UIButton *data5minPD;

@property (strong, nonatomic) IBOutlet ILTranslucentView *blurView;

- (IBAction)logoPressed:(id)sender;

- (IBAction)pushNotificationTap:(id)sender;


//- (IBAction)goToSubview:(id)sender;

@end



