//
//  UIViewController+AWEAdditions.h
//  Aweme
//
//  Created by willorfang on 16/9/2.
//  Copyright © 2016年 Bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (AWEAdditions)

#pragma mark - question dialog
/// alert 样式弹窗
- (void)awe_question:(NSString *)question
              titles:(NSArray<NSString *> *)titles
             okBlock:(void(^)(NSInteger selectIdx))okBlock
         cancelBlock:(dispatch_block_t)cancelBlock;

/// alert 样式弹窗
- (void)awe_alertQuestion:(NSString *)question
                   titles:(NSArray<NSString *> *)titles
                  okBlock:(void(^)(NSInteger selectIdx))okBlock
              cancelBlock:(dispatch_block_t)cancelBlock;

/// sheet 样式弹窗
- (void)awe_sheetQuestion:(NSString *)question
                   titles:(NSArray<NSString *> *)titles
                  okBlock:(void(^)(NSInteger selectIdx))okBlock
              cancelBlock:(dispatch_block_t)cancelBlock;

- (void)awe_question:(NSString *)question
             message:(NSString *)message
             okTitle:(NSString *)okTitle
             okStyle:(UIAlertActionStyle)okStyle
         cancelTitle:(NSString *)cancelTitle
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock;

- (void)awe_question:(NSString *)question
             okTitle:(NSString *)okTitle
             okStyle:(UIAlertActionStyle)okStyle
         cancelTitle:(NSString *)cancelTitle
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock;

- (void)awe_question:(NSString *)question
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock;


@end
