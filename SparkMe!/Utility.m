//
//  Utility.m
//  Sparky
//
//  Created by Shivam Jaiswal on 12/17/16.
//
//

#import "Utility.h"
#import "KeychainItemWrapper.h"

@interface Utility ()
@property (nonatomic, strong) NSNumberFormatter *currencyFormatter;
@end

@implementation Utility

+(Utility *)shared
{
    static dispatch_once_t onceToken;
    static Utility *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[super allocWithZone:nil] init];
    });
    return sharedManager;
}

+ (void)showHUDonView:(UIView *)view title:(NSString *)title;
{
    MBProgressHUD *hudUpdateUIView = [MBProgressHUD showHUDAddedTo:view  animated:YES];
    hudUpdateUIView.labelText = title;
    hudUpdateUIView.yOffset = -70.f;
}

+ (void)showHUDonView:(UIView *)view 
{
    [Utility showHUDonView:view title:@"Loading..."];
}

+ (void)hideHUDForView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view  animated:YES];
}

+ (void)showErrorAlertTitle:(NSString *)title withMessage:(NSString *)message
{
    message =  message ? message : @"Something seems to have gone wrong. Please try again later.";
    title =  title ? title : @"Oops!";
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

+(void)saveData:(id)data forKey:(NSString *)key
{
    if (data && key) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)removeDataforKey:(NSString *)key{
    if (key) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:key];
        [prefs synchronize];
    }
}

+ (id)dataForKey:(NSString *)key{
    
    if (!key) {
        return key;
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    id data = [prefs objectForKey:key];
    return data;
}

+ (NSString *)userName{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"SparkyLoginData" accessGroup:nil];
    NSString *name = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    if (!name) {
        return @"";
    }
    return name;
}

+ (NSString *)password{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"SparkyLoginData" accessGroup:nil];
    NSString *password = [keychain objectForKey:(__bridge id)(kSecValueData)];
    if (!password) {
        return @"";
    }
    return password;
}

- (NSString *)currencyStringFromString:(NSString *)string
{
    if (!_currencyFormatter) {
        self.currencyFormatter = [[NSNumberFormatter alloc]init];
        [self.currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [self.currencyFormatter setCurrencySymbol:@"$"];
        self.currencyFormatter.groupingSize = 3;
        self.currencyFormatter.secondaryGroupingSize = 3;
        self.currencyFormatter.maximumFractionDigits = 2;
        self.currencyFormatter.minimumFractionDigits = 0;
    }

    NSString *str =  [_currencyFormatter stringFromNumber:[NSNumber numberWithDouble:string.doubleValue]];
    return str;
}

#pragma mark String Size
+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString width:(float)width
{
    CGSize size = [attrString boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font width:(float)width
{
    if (!font || !string) {
        return CGSizeZero;
    }
    
    CGSize size = [string boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX} options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName : font} context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForAttributedString:(NSAttributedString *)attrString
{
    if (!attrString) {
        return CGSizeZero;
    }
    
    CGSize size = attrString.size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font
{
    if (!font || !string) {
        return CGSizeZero;
    }
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName : font}];
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

- (NSDateFormatter *)am_pm_formatter
{
    if (!_am_pm_formatter) {
        _am_pm_formatter = [[NSDateFormatter alloc] init];
        [_am_pm_formatter setTimeStyle:NSDateFormatterShortStyle];
        [_am_pm_formatter setDateStyle:NSDateFormatterNoStyle];
    }
    return _am_pm_formatter;
}

- (NSDateFormatter *)time24formatter
{
    if (!_time24formatter) {
        _time24formatter = [[NSDateFormatter alloc] init];
        _time24formatter.dateFormat = @"HH:mm";
    }
    return _time24formatter;
}

- (NSString *)time24FromTimeString:(NSString *)am_pm_str
{
    NSDate *date = [self.am_pm_formatter dateFromString:am_pm_str];
    NSString *string = [self.time24formatter stringFromDate:date];
    return string;
}

- (NSString *)timeAM_PMFromTimeString:(NSString *)time24
{
    NSDate *date = [self.time24formatter dateFromString:time24];
    NSString *string = [self.am_pm_formatter stringFromDate:date];
    return string;
}

@end
