//
//  GRAppDelegate.m
//  PlayerModule
//
//  Created by 18578216982@163.com on 03/12/2020.
//  Copyright (c) 2020 18578216982@163.com. All rights reserved.
//

#import "GRAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "GRRemotePlayer.h"

@implementation GRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //告诉系统，接收远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    //
    [[GRRemotePlayer shareInstance] playBackAudioWithImage:@"pushu" propertyTitle:@"甜蜜蜜" propertyArtist:@"哈哈"];
    
    return YES;
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}

//响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {

    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"播放暂停");
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"切换");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"播放下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首");
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"开始播放");
                break;
            default:
                break;
        }
    }
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
