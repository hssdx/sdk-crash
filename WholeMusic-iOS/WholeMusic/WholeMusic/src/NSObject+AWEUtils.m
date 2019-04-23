//
//  NSObject+AWEUtils.m
//  Aweme
//
//  Created by xiongxunquan on 2019/3/19.
//  Copyright © 2019 Bytedance. All rights reserved.
//

#import "NSObject+AWEUtils.h"

@implementation NSObject (AWEUtils)

+ (UIViewController *)ad_topControllerWithController:(UIViewController *)controller {
    UIViewController *topVC = controller;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    NSParameterAssert(topVC);
    return topVC;
}

+ (UIViewController *)ad_topController {
    id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(window)]) {
        UIWindow *window = [delegate window];
        return [self ad_topControllerWithController:window.rootViewController];
    }
    NSParameterAssert(false);
    return nil;
}

+ (void)ad_safePresentViewController:(UIViewController *)controller {
    [self.ad_topController presentViewController:controller animated:YES completion:^{}];
}


- (UIViewController *)ad_topController {
    return [self.class ad_topController];
}

- (void)ad_safePresentViewController:(UIViewController *)controller {
    [self.class ad_safePresentViewController:controller];
}

@end
