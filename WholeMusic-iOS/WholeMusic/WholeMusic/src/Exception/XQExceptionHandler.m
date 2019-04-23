//
//  XQExceptionHandler.h
//  KSOStatSDK lib
//
//  Created by yangzhenyu on 5/18/15.
//  Copyright (c) 2015 Kingsoft. All rights reserved.
//

#import "XQExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString *const kXQUncaughtExceptionInfoKey = @"XQUncaughtExceptionInfoKey";

static NSString *const kUncaughtExceptionSignalException = @"XQUncaughtExceptionSignalException";
static NSString *const kUncaughtExceptionSignalKey = @"XQUncaughtExceptionSignalKey";

static volatile int32_t kUncaughtExceptionCount = 0;
static const int32_t kUncaughtExceptionMaximum = 10;

static const NSInteger kUncaughtExceptionSkipAddressCount = 0;
static const NSInteger kUncaughtExceptionReportAddressCount = 30;

#pragma mark - Global Exception Function

typedef void (*XQSignalHandlerType)(int signo, siginfo_t *info, void *context);
static XQSignalHandlerType previousSignalHandler = NULL;
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

static void XQPerformSelectorWithException(NSException *exception);
static void XQSignalHandler(int signal, siginfo_t* info, void* context);
static void XQUninstallSignalRigister(void);
static NSArray *XQBacktraceArray(void);


#define XQSIGACTION_DFL (void (*)(int,siginfo_t *,void *))0

static void XQSignalRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = XQSignalHandler;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}

static void XQSignalUnRegister(int signal) {
    struct sigaction action;
    action.sa_sigaction = XQSIGACTION_DFL;
    action.sa_flags = SA_NODEFER | SA_SIGINFO;
    sigemptyset(&action.sa_mask);
    sigaction(signal, &action, 0);
}

static void XQSignalHandler(int signal, siginfo_t* info, void* context) {
    //  获取堆栈，收集堆栈
    int32_t exceptionCount = OSAtomicIncrement32(&kUncaughtExceptionCount);
    if (exceptionCount > kUncaughtExceptionMaximum){
        return;
    }
    
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                      forKey:kUncaughtExceptionSignalKey];
    NSArray *callStack = XQBacktraceArray();
    [userInfo setObject:callStack forKey:kXQUncaughtExceptionInfoKey];
    NSException *newException = [NSException exceptionWithName:kUncaughtExceptionSignalException
                                                        reason:@"Signal was raised"
                                                      userInfo:userInfo];
    XQPerformSelectorWithException(newException);
    XQUninstallSignalRigister();
    
    // 处理前者注册的 handler
    if (previousSignalHandler) {
        previousSignalHandler(signal, info, context);
    }
}



static void XQInstallSignalRigister(void) {
    struct sigaction old_action;
    sigaction(SIGABRT, NULL, &old_action);
    if (old_action.sa_flags & SA_SIGINFO) {
        previousSignalHandler = old_action.sa_sigaction;
    }
#if 0
    signal(SIGABRT, XQSignalHandler);
    signal(SIGILL, XQSignalHandler);
    signal(SIGSEGV, XQSignalHandler);
    signal(SIGFPE, XQSignalHandler);
    signal(SIGBUS, XQSignalHandler);
    signal(SIGPIPE, XQSignalHandler);
#else
    XQSignalRegister(SIGABRT);
    XQSignalRegister(SIGILL);
    XQSignalRegister(SIGSEGV);
    XQSignalRegister(SIGFPE);
    XQSignalRegister(SIGBUS);
    XQSignalRegister(SIGPIPE);
#endif
}

static void XQUninstallSignalRigister(void) {
#if 0
    signal(SIGABRT, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
#else
    XQSignalUnRegister(SIGABRT);
    XQSignalUnRegister(SIGILL);
    XQSignalUnRegister(SIGSEGV);
    XQSignalUnRegister(SIGFPE);
    XQSignalUnRegister(SIGBUS);
    XQSignalUnRegister(SIGPIPE);
#endif
}

static void XQPerformSelectorWithException(NSException *exception) {
    if (!exception) {
        return;
    }
    XQExceptionHandler *exceptionHandler = [XQExceptionHandler sharedExceptionHandler];
    [exceptionHandler performSelectorOnMainThread:@selector(handleException:)
                                       withObject:exception
                                    waitUntilDone:YES];
}

static NSArray *XQBacktraceArray(void) {
    static const size_t max_len = 128;
    void* callstack[max_len];
    int frames = backtrace(callstack, max_len);
    char **strs = backtrace_symbols(callstack, frames);
    NSMutableArray *backtrace = [NSMutableArray array];
    for (NSInteger i = kUncaughtExceptionSkipAddressCount;
         i < kUncaughtExceptionSkipAddressCount + kUncaughtExceptionReportAddressCount &&
         i < max_len;
         i++)
    {
        if ([NSString stringWithUTF8String:strs[i]].length == 0) {
            break;
        }
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    free(strs);
    return [backtrace copy];
}

static void XQUncaughtExceptionHandler(NSException *exception) {
    // 获取堆栈，收集堆栈
    int32_t exceptionCount = OSAtomicIncrement32(&kUncaughtExceptionCount);
    if (exceptionCount > kUncaughtExceptionMaximum) {
        return;
    }
    
    NSArray *fullCallStack = [exception callStackSymbols];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:fullCallStack forKey:kXQUncaughtExceptionInfoKey];
    
    NSException *newException = [NSException exceptionWithName:[exception name]
                                                        reason:[exception reason]
                                                      userInfo:userInfo];
    XQPerformSelectorWithException(newException);
    
    //  处理前者注册的 handler
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
}

static void XQInstallExceptionHandler(void) {
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&XQUncaughtExceptionHandler);
}

static void XQUninstallExceptionHandler(void) {
    NSSetUncaughtExceptionHandler(NULL);
}


#pragma mark - XQExceptionHandler

@implementation XQExceptionHandler

+ (instancetype)sharedExceptionHandler{
    static XQExceptionHandler *sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[XQExceptionHandler alloc] init];
    });
    return sharedHandler;
}

- (id)init{
    self = [super init];
    if (self){
        //捕获信号
        XQInstallSignalRigister();
        //捕获异常
        XQInstallExceptionHandler();
        
        return self;
    }
    return nil;
}

- (void)dealloc {
    XQUninstallSignalRigister();
    XQUninstallExceptionHandler();
}

- (void)handleException:(NSException *)exception {
    if (self.delegate) {
        [self.delegate exceptionHandler:self handleException:exception];
    }
    
	if ([[exception name] isEqual:kUncaughtExceptionSignalException]){
		kill(getpid(), [[[exception userInfo] objectForKey:kUncaughtExceptionSignalKey] intValue]);
	}else{
		[exception raise];
	}
}

@end

