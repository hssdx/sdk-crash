//
//  XQExceptionHandler.h
//  KSOStatSDK lib
//
//  Created by yangzhenyu on 5/18/15.
//  Copyright (c) 2015 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kXQUncaughtExceptionInfoKey;

@class XQExceptionHandler;

@protocol UncaughtExceptionDelegate <NSObject>
- (void)exceptionHandler:(XQExceptionHandler *)handler
         handleException:(NSException *)exception;
@end


@interface XQExceptionHandler : NSObject

@property (weak, nonatomic) id<UncaughtExceptionDelegate> delegate;

+ (instancetype)sharedExceptionHandler;

- (void)handleException:(NSException *)exception;

@end
