//
//  AppDelegate.m
//  WholeMusic
//
//  Created by quanxiong on 2018/2/11.
//  Copyright © 2018年 quanxiong. All rights reserved.
//

#import "AppDelegate.h"
#import "XQExceptionHandler.h"
#import "NSObject+AWEUtils.h"
#import "UIViewController+AWEAdditions.h"
#import <TestSDK1/TestSDK1.h>
#import <TestSDK1/TestSDK1Address.h>
#import <TestSDK2/TestSDK2.h>
#import <TestSDK2/TestSDK2Address.h>

@interface AppDelegate () <UncaughtExceptionDelegate>
@end

@implementation AppDelegate

- (BOOL)crashIsInSdk:(NSString *)sdkName stacks:(NSArray<NSString *> *)stacks {
    NSString *sdkAddrClassName = [NSString stringWithFormat:@"%@Address", sdkName];
    Class sdkAddrClass = NSClassFromString(sdkAddrClassName);
    
    NSLog(@"sdk start: %lld end: %lld", [sdkAddrClass begainAddress], [sdkAddrClass endAddress]);
    NSLog(@"sdk start: %lld end: %lld[real]", [sdkAddrClass realBegainAddress], [sdkAddrClass realEndAddress]);
    NSLog(@"## range %lld", [sdkAddrClass endAddress] - [sdkAddrClass begainAddress]);
    NSLog(@"## side %lld", [sdkAddrClass begainAddress] - [sdkAddrClass realBegainAddress]);
    int64_t begain = (int64_t)[sdkAddrClass begainAddress];
    int64_t end = (int64_t)[sdkAddrClass endAddress];
    
    NSLog(@"## %@-%@", @(begain), @(end));
    
    __block BOOL isInResult = NO;
    [stacks enumerateObjectsUsingBlock:^(NSString * symbolString, NSUInteger idx, BOOL * stop) {
        NSMutableArray<NSString *> *components = [NSMutableArray array];
        for (NSUInteger idx = 0; idx < symbolString.length;) {
            unichar ch = [symbolString characterAtIndex:idx];
            while ((ch == ' ' || ch == '\t' || ch == '\n') && idx < symbolString.length) {
                ++idx;
                if (idx < symbolString.length) {
                    ch = [symbolString characterAtIndex:idx];
                }
            }
            if (idx >= symbolString.length) {
                break;
            }
            NSUInteger jdx = idx;
            ch = [symbolString characterAtIndex:jdx];
            while ((ch != ' ' && ch != '\t' && ch != '\n') && jdx < symbolString.length) {
                ++jdx;
                if (jdx < symbolString.length) {
                    ch = [symbolString characterAtIndex:jdx];
                }
            }
            NSString *subString = [symbolString substringWithRange:NSMakeRange(idx, jdx - idx)];
            [components addObject:subString];
            
            idx = jdx;
            if (idx >= symbolString.length) {
                break;
            }
        }
        if (components.count >= 3) {
            NSString *result = [components objectAtIndex:2];
            int64_t address = (int64_t)strtoul([result UTF8String], 0, 16);
            NSLog(@"## %@-(%@)", @(address), result);
            if (begain <= address && address <= end) {
                NSLog(@"## IN SDK【%@】", sdkName);
                isInResult = YES;
                *stop = YES;
            }
        }
    }];
    return isInResult;
}

#pragma mark - UncaughtExceptionDelegate
- (void)exceptionHandler:(XQExceptionHandler *)handler handleException:(NSException *)exception {
    NSLog(@"%@", exception.userInfo);
    NSString *exceptionInfo = [NSString stringWithFormat:@"%@", exception.userInfo];
    [[self ad_topController] awe_question:exceptionInfo
                                  okBlock:^{}
                              cancelBlock:^{}];
    
    NSArray<NSString *> *stacks = exception.userInfo[kXQUncaughtExceptionInfoKey];
    
    BOOL isInSdk1 = [self crashIsInSdk:@"TestSDK1" stacks:stacks];
    BOOL isInSdk2 = [self crashIsInSdk:@"TestSDK2" stacks:stacks];
    
    if (isInSdk1) {
        NSLog(@"in sdk 1");
    }
    if (isInSdk2) {
        NSLog(@"in sdk 2");
    }
}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [XQExceptionHandler sharedExceptionHandler].delegate = self;
    
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window becomeKeyWindow];
    self.window.rootViewController.view.backgroundColor = [UIColor redColor];
    
//    [TestSDK1 testOverTheBoundary];
//    [TestSDK1 testUnrecognizedSelector];
//    [TestSDK1 illegalAccess];
    
    [TestSDK2 testOverTheBoundary];
    [TestSDK2 testUnrecognizedSelector];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
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
