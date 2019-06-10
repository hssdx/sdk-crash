//
//  MainViewController.m
//  WholeMusic
//
//  Created by xiongxunquan on 2019/6/10.
//  Copyright © 2019 quanxiong. All rights reserved.
//

#import "MainViewController.h"
#import "NSObject+AWEUtils.h"
#import "UIViewController+AWEAdditions.h"
#import <TestSDK1/TestSDK1.h>
#import <TestSDK1/TestSDK1Address.h>
#import <TestSDK2/TestSDK2.h>
#import <TestSDK2/TestSDK2Address.h>

@interface MainViewController ()

@property (nonatomic, strong) UIButton *doCrashInSDK1;
@property (nonatomic, strong) UIButton *doCrashInSDK2;
@property (nonatomic, strong) UIButton *doCrashInApp;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NSMutableString *infoMsg;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoMsg = [NSMutableString string];
    [XQExceptionHandler sharedExceptionHandler].delegate = self;
    [self setupUI];
}

- (void)log:(NSString *)msg {
    [_infoMsg appendString:msg];
    _infoLabel.text = [_infoMsg copy];
}

- (void)setupUI {
    _doCrashInSDK1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 100, 36)];
    _doCrashInSDK2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 100 + 36 + 8, 100, 36)];
    _doCrashInApp = [[UIButton alloc] initWithFrame:CGRectMake(0, 100 + 36 + 8 + 36 + 8, 100, 36)];
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(100 + 8, 100, 200, 400)];
    
    [self.view addSubview:_doCrashInSDK1];
    [self.view addSubview:_doCrashInSDK2];
    [self.view addSubview:_doCrashInApp];
    [self.view addSubview:_infoLabel];
    
    _infoLabel.text = @"信息";
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.backgroundColor = [UIColor grayColor];
    _infoLabel.textColor = [UIColor whiteColor];
    [_doCrashInSDK1 setTitle:@"SDK1 Crash" forState:UIControlStateNormal];
    [_doCrashInSDK2 setTitle:@"SDK2 Crash" forState:UIControlStateNormal];
    [_doCrashInApp setTitle:@"APP Crash" forState:UIControlStateNormal];
    [_doCrashInSDK1 addTarget:self action:@selector(doCrash:) forControlEvents:UIControlEventTouchUpInside];
    [_doCrashInSDK2 addTarget:self action:@selector(doCrash:) forControlEvents:UIControlEventTouchUpInside];
    [_doCrashInApp addTarget:self action:@selector(doCrash:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)testOverTheBoundary {
    NSArray *arr = @[@1];
    NSLog(@"%@", arr[1]);
}

- (void)doCrash:(UIButton *)sender {
    if (sender == _doCrashInSDK1) {
        [TestSDK1 testOverTheBoundary];
    } else if (sender == _doCrashInSDK2) {
        [TestSDK2 testOverTheBoundary];
    } else if (sender == _doCrashInApp) {
        [self testOverTheBoundary];
    }
    //    [TestSDK1 testOverTheBoundary];
    //    [TestSDK1 testUnrecognizedSelector];
    //    [TestSDK1 illegalAccess];
    //    [TestSDK2 testOverTheBoundary];
    //    [TestSDK2 testUnrecognizedSelector];
}

#pragma mark - UncaughtExceptionDelegate
- (void)exceptionHandler:(XQExceptionHandler *)handler handleException:(NSException *)exception {
    NSLog(@"%@", exception.userInfo);
//    NSString *exceptionInfo = [NSString stringWithFormat:@"%@", exception.userInfo];
//    [[self ad_topController] awe_question:exceptionInfo
//                                  okBlock:^{}
//                              cancelBlock:^{}];
    
    NSArray<NSString *> *stacks = exception.userInfo[kXQUncaughtExceptionInfoKey];
    
    BOOL isInSdk1 = [self crashIsInSdk:@"TestSDK1" stacks:stacks];
    BOOL isInSdk2 = [self crashIsInSdk:@"TestSDK2" stacks:stacks];
    
    NSString *msg = @"Other";
    if (isInSdk1) {
        msg = @"in sdk 1";
    }
    if (isInSdk2) {
        msg = @"in sdk 2";
    }
    [self awe_question:msg okBlock:^{} cancelBlock:nil];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    NSTimeInterval startTime = NSDate.date.timeIntervalSince1970;
    static BOOL ignore = NO;
    while (!ignore) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
        NSTimeInterval runTime = NSDate.date.timeIntervalSince1970;
        if (runTime - startTime > 5) {
            ignore = YES;
            exit(0);
        }
    }
    CFRelease(allModes);
}

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

@end
