//
//  VPAutoDownloadViewController.m
//  Sparky
//
//  Created by Shivam Jaiswal on 10/20/17.
//

#import "VPAutoDownloadViewController.h"

@interface VPAutoDownloadViewController ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation VPAutoDownloadViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleForeground)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [self allocTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [self deallocTimer];
}

- (void)dealloc{
    [self deallocTimer];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [self deallocTimer];
}

- (float)refreshTimeIntervalInSeconds{
    return 60 * 5 ;
}

- (void)handleBackground{
    [self deallocTimer];
}

- (void)handleForeground{
    [self allocTimer];
    [self refreshData];
}

- (void)allocTimer{
    
    if (_timer) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:[self refreshTimeIntervalInSeconds]
                                              target:self selector:@selector(refreshData)
                                            userInfo:nil repeats:YES];
}

- (void)deallocTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)refreshData
{
    NSLog(@"refreshData at %@",[NSDate date]);
}

@end
