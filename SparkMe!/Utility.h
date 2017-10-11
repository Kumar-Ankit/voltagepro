//
//  Utility.h
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define CenteredOrigin(x, y) floor((x - y)/2.0)

#define kLightFontName @"HelveticaNeue-Light"
#define kRegularFontName @"HelveticaNeue"
#define kMediumFontName @"HelveticaNeue-Medium"
#define kBoldFontName @"HelveticaNeue-Bold"
#define kRegularItalic @"Eterea Pro Italic"

#define LIGHT(x) [UIFont fontWithName:kLightFontName size:x]
#define MEDIUM(x) [UIFont fontWithName:kMediumFontName size:x]
#define REGULAR(x) [UIFont fontWithName:kRegularFontName size:x]
#define BOLD(x) [UIFont fontWithName:kBoldFontName size:x]

#define GRAY(x) [UIColor colorWithWhite:x alpha:1.0]
#define GRAYA(x, a) [UIColor colorWithWhite:x alpha:a]
#define RGBA(x,y,z,a) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:a]
#define RGB(x,y,z) RGBA(x,y,z,1.0)

//Cells and TableView
#define kDefaultCellImageHeight 20.0
#define kDarkBlueGrayColor RGB(114, 124, 127)
#define kGreenColor RGB(21, 180, 128)
#define kButtonCancleColor GRAY(1)
#define kButtonSaveColor GRAY(1)
#define kTableViewCellTitleFont REGULAR(14.0)
#define kTableViewCellMainFont REGULAR(16.0)
#define kTableViewCellDescFont REGULAR(13.0)
#define kTableViewCellFooterFont REGULAR(13.0)
#define kCellButtonFont MEDIUM(15.0)
#define kAppNormalButtonFont REGULAR(15.0)

#define kTableViewSectionPadding 16.0
#define kTableViewSmallPadding 8.0
#define kTableViewMediumPadding 15.0
#define kTableViewSidePadding 15.0
#define kTableViewLargePadding 24.0
#define kDefaultCellHeight 44.0

#define kSeparatorColor RGB(219, 221, 222)
#define kTableViewCellMainColor GRAYA(0.0, 1.0)
#define kTableViewCellDescColor kDarkBlueGrayColor
#define kTableViewCellSeparatorColor kSeparatorColor
#define kTableTitleColor kDarkBlueGrayColor
#define kTableFooterColor kBlueGrayColor

// textField
#define kTextFieldSidePadding 15.0
#define kTfTextColor GRAY(0.1)
#define kAppSelectionRedColor RGBA(255.0, 89.0, 89.0, 1.0)
#define kAppSelectionBlueColor RGB(40.0, 170.0, 225.0)
#define kLightBlueGrayColor RGB(179, 188, 191)
#define kPlaceholderColor kLightBlueGrayColor

//globalDefs
#define kAppTintColor RGB(52, 145, 190)
#define kAppBackgroundColor RGB(242.0, 244.0, 245.0)
#define kDefaultInteritemPadding kTableViewSmallPadding
#define kDefaultSidePadding 15.0

@interface Utility : NSObject
+ (Utility *)shared;

+ (void)showHUDonView:(UIView *)view title:(NSString *)title;
+ (void)hideHUDForView:(UIView *)view;
+ (void)showHUDonView:(UIView *)view;
+ (void)showErrorAlertTitle:(NSString *)title withMessage:(NSString *)message;

+ (void)removeDataforKey:(NSString *)key;
+ (void)saveData:(id)data forKey:(NSString *)key;
+ (id)dataForKey:(NSString *)key;
+ (NSString *)userName;
+ (NSString *)password;
- (NSString *)currencyStringFromString:(NSString *)string;

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width;
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width;
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString;
+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font;

- (NSString *)time24FromTimeString:(NSString *)am_pm_str;
- (NSString *)timeAM_PMFromTimeString:(NSString *)time24;

@property (nonatomic,strong) NSDateFormatter *am_pm_formatter;
@property (nonatomic,strong) NSDateFormatter *time24formatter;

+ (void)registerForPushNotifications;
+ (void)sendTokenToServer:(NSString *)token;

@end
