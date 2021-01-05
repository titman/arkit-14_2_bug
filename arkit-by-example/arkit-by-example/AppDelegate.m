//
//  AppDelegate.m
//  arkit-by-example
//
//  Created by md on 6/8/17.
//  Copyright © 2017 ruanestudios. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import <os/log.h>
#import <os/signpost.h>

@interface AppDelegate ()
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, assign) os_log_t oslog;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.oslog = os_log_create("com.autonavi.amap.arkitsample", OS_LOG_CATEGORY_POINTS_OF_INTEREST);

    [self startMotion];
    
  return YES;
}

- (void)startMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.deviceMotionUpdateInterval = 0.04;
    
    if (!self.motionManager.isDeviceMotionAvailable) {
        NSLog(@"unavilable");
        return ;
    }
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.operationQueue.name = @"com.amap.motion";
    
    __weak typeof(self) weakSelf = self;
    
    // Look around and wait 1~15 mins, CMMotionManager will stop working.
    [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXMagneticNorthZVertical toQueue:self.operationQueue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (error) {
            os_signpost_event_emit(weakSelf.oslog, 1, "Motion callback with an error!");
            NSLog(@"Motion callback with an error: %@!", error);
        } else {
            os_signpost_event_emit(weakSelf.oslog, 1, "Motion callback!");
            NSLog(@"Motion callback!");
        }
    }];
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
