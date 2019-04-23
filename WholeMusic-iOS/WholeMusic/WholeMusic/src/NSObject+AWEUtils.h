//
//  NSObject+AWEUtils.h
//  Aweme
//
//  Created by xiongxunquan on 2019/3/19.
//  Copyright © 2019 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AWEUtils)

+ (UIViewController *)ad_topControllerWithController:(UIViewController *)controller;

+ (UIViewController *)ad_topController;

+ (void)ad_safePresentViewController:(UIViewController *)controller;

- (UIViewController *)ad_topController;

- (void)ad_safePresentViewController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
