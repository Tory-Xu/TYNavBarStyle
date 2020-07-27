//
//  TYAppDelegate.m
//  TYNavBarStyle
//
//  Created by 756165690@qq.com on 10/11/2019.
//  Copyright (c) 2019 756165690@qq.com. All rights reserved.
//

#import "TYAppDelegate.h"
#import "TYNavBarStyle.h"

/**
 1，控制按钮左/右的距离
 */

@implementation TYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    #if DEBUG
    [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
    #endif
    
    [self config];
    return YES;
}

- (void)config {
    TYNavBarTintEngine *tintEngine = [TYNavBarTintEngine createSharedEngine];
    tintEngine.debugModel = YES;
    tintEngine.navBarItemHorizontalMargin = 14;
    tintEngine.autoCreateBackItemWhenPresent = YES;
    [tintEngine setBackItemConfig:^(UIButton *backButton) {
        UIImage *backImage = [UIImage imageNamed:@"back"];
        [backButton setImage:backImage
                    forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 0, 44, 44);
    }];
    
    // 过滤系统页面
    tintEngine.ignoreConfigNavBarVcClass = @[@"ABNewPersonViewController",
                                             @"CNContactViewHostViewController",
                                             @"CNContactViewController",];
    TYNavBarStyleConfig *defaultConfig = [TYNavBarStyleConfig navBarStyleConfigWithTitleColor:[UIColor blackColor]
                                                                                    titleFont:[UIFont systemFontOfSize:20]
                                                                                    tintColor:[UIColor redColor]
                                                                                     itemFont:[UIFont boldSystemFontOfSize:12]
                                                                                 barTintColor:[UIColor grayColor]
                                                                               statusBarStyle:UIStatusBarStyleDefault];
    tintEngine.navBarStyleConfigs = @{TYNavBarStyleDefault: defaultConfig};
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
