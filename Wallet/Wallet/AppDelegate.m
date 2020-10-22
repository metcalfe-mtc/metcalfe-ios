//
//  AppDelegate.m
//  Wallet
//
//  Created by 钱伟成 on 2019/8/23.
//  Copyright © 2019 MetcalfeChain. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "AccountMainScene.h"
#import "TabbarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 启动图片延时: 1秒
       [NSThread sleepForTimeInterval:1];
    
    //设置全局状态栏颜色为白色
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[JKDBHelper shareInstance] changeDBWithDirectoryName:LOCALWALLETS];
    NSArray *emptyCurrentList1 = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE secret = '%@'",@""]];
    [LocalWallet deleteObjects:emptyCurrentList1];
    NSArray *emptyCurrentList2 = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE account = '%@'",@""]];
    [LocalWallet deleteObjects:emptyCurrentList2];
    
    
    NSArray *currentList = [LocalWallet findByCriteria:[NSString stringWithFormat:@" WHERE isdefault = '%@'",@"1"]];
    if(currentList.count > 0){
        [UserManager sharedInstance].wallet = currentList[0];
        TabbarController *scene = [[TabbarController alloc] init];
        self.window.rootViewController = scene;
    }else{
        AccountMainScene *scene = [[AccountMainScene alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:scene];
        self.window.rootViewController = nav;
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
