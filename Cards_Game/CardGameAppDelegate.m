//
//  AppDelegate.m
//  Cards_Game
//
//  Created by KEVIN on 04/04/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

#import "CardGameAppDelegate.h"


@implementation CardGameAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
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
    
    NSAssert(self.bgTask == UIBackgroundTaskInvalid, nil);

    self.bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [application endBackgroundTask:self.bgTask];
            self.bgTask = UIBackgroundTaskInvalid;
        });
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        while ([application backgroundTimeRemaining] > 1.0) {
            [self scheduleNotificationForInterval:10];
            break;
        }
        [application endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //We remove the notification badgewhen the user launch the app
    application.applicationIconBadgeNumber = 0;

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)scheduleNotificationForInterval:(int)minutesAfter {
    
    NSMutableArray* scoreArray  = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Scores"] mutableCopy];
    
    int indexForLastWin = 0;
    NSNumber * score;
    for (int index = 0; index < [scoreArray count]; index ++)
    {
        score = [scoreArray objectAtIndex:index];
        if([score integerValue]>=0)
        {
            indexForLastWin = index;
            break;
        }
    }
    
    NSDate *lastWinDate =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"Dates"] objectAtIndex:indexForLastWin];
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil)
        return;
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastWinDate];
    if (timeInterval >= minutesAfter*60 )
    {
        
        localNotif.alertBody = [NSString stringWithFormat:@"Tu n'as pas gagné depuis %i minutes.", minutesAfter];
        localNotif.alertAction = @"Jouer";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] presentLocalNotificationNow:localNotif];

    }
   
}
@end
