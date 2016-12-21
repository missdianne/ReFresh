//
//  ReFreshAppDelegate.m
//  ReFresh
//
//  Created by Dianne Na on 5/25/14.
//  Copyright (c) 2014 CS193P. All rights reserved.
//

#import "ReFreshAppDelegate.h"
#import "ReFreshDatabase.h"
#import <Parse/Parse.h>


@implementation ReFreshAppDelegate
#define FETCH_DEBUG NO
#define FOREGROUND_FETCH_INTERVAL (FETCH_DEBUG ? 5 : (15*60))


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"ZgClf5NYSOvzhHMTW49gpZYcZx9IjX5DFfrxVCGD"
                  clientKey:@"6CLf9GAGK520QBPeBf7uuBqGir4xPaPgSRayCH06"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    // Override point for customization after application launch.
    
    [NSTimer scheduledTimerWithTimeInterval:FOREGROUND_FETCH_INTERVAL
                                     target:self
                                   selector:@selector(processFetchTimer:)
                                   userInfo:nil
                                    repeats:YES];
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}


- (void)processFetchTimer:(NSTimer *)timer
{
    [[ReFreshDatabase sharedDefaultReFreshDatabase] fetch];
   // NSLog(@"a");
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[ReFreshDatabase sharedDefaultReFreshDatabase] fetchWithCompletionHandler:^(BOOL success) {
        completionHandler(success ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultNoData);
    }];
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

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
