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

@end
