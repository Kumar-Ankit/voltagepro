//
//  LoginViewController.h
//  Sparky
//
//  Created by Hung on 1/09/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"
#import "ILTranslucentView.h"

@interface LoginViewController : UIViewController {
    
    NSURLConnection *urlConnection;
    UIButton *login;
    UILabel *sparkyLogo;
    UIButton *phanalytics;
    MBProgressHUD *HUD;
    UITextField *txtUsername;
    UITextField *txtPassword;
    
    NSString *appVersion;
    
    NSString *OsVersion;
    NSString *DeviceType;
    NSString *UAdevToken;
    
    NSString *responsePriceAlertFlag;
    
    KeychainItemWrapper *keychain;
    KeychainItemWrapper *keychainDeviceCred;
    
    NSInteger gradIndex;
    
    ILTranslucentView *blurView;
    
}

@property (nonatomic, strong) NSURLConnection *urlConnection;
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property(nonatomic,retain) IBOutlet UIButton *login;
@property(nonatomic,retain) IBOutlet UILabel *sparkyLogo;
@property(nonatomic,retain) IBOutlet UIButton *phanalytics;

@property (strong, nonatomic) IBOutlet ILTranslucentView *blurView;

- (IBAction)loginClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;

@end


