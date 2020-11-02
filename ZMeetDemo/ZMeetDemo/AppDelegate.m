//
//  AppDelegate.m
//  ZmeetDemo
//
//  Created by bingo on 2020/10/9.
//

#import "AppDelegate.h"
#import <ZmeetCoreKit/ZRtcEngineKit.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ZRtcEngineKit sharedEngine];
    return YES;
}


@end
