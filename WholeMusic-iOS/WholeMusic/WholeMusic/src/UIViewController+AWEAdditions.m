//
//  UIViewController+AWEAdditions.m
//  Aweme
//
//  Created by willorfang on 16/9/2.
//  Copyright © 2016年 Bytedance. All rights reserved.
//

#import "UIViewController+AWEAdditions.h"

@implementation UIViewController (AWEAdditions)



#pragma mark - question dialog
- (void)awe_question:(NSString *)question
              titles:(NSArray<NSString *> *)titles
             okBlock:(void(^)(NSInteger selectIdx))okBlock
         cancelBlock:(dispatch_block_t)cancelBlock
      preferredStyle:(UIAlertControllerStyle)preferredStyle {
    if (titles.count == 0) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:question
                                                                      preferredStyle:preferredStyle];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        UIAlertAction *selection =
        [UIAlertAction actionWithTitle:title
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
         {
             if (okBlock) {
                 okBlock(idx);
             }
         }];
        [alertController addAction:selection];
    }];
    if (cancelBlock) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * action) { cancelBlock(); }];
        [alertController addAction:cancel];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)awe_question:(NSString *)question
              titles:(NSArray<NSString *> *)titles
             okBlock:(void(^)(NSInteger selectIdx))okBlock
         cancelBlock:(dispatch_block_t)cancelBlock {
    [self awe_question:question titles:titles okBlock:okBlock cancelBlock:cancelBlock preferredStyle:UIAlertControllerStyleAlert];
}

- (void)awe_alertQuestion:(NSString *)question
                   titles:(NSArray<NSString *> *)titles
                  okBlock:(void(^)(NSInteger selectIdx))okBlock
              cancelBlock:(dispatch_block_t)cancelBlock {
    [self awe_question:question titles:titles okBlock:okBlock cancelBlock:cancelBlock preferredStyle:UIAlertControllerStyleAlert];
}

- (void)awe_sheetQuestion:(NSString *)question
                   titles:(NSArray<NSString *> *)titles
                  okBlock:(void(^)(NSInteger selectIdx))okBlock
              cancelBlock:(dispatch_block_t)cancelBlock {
    [self awe_question:question titles:titles okBlock:okBlock cancelBlock:cancelBlock preferredStyle:UIAlertControllerStyleActionSheet];
}

- (void)awe_question:(NSString *)question
             message:(NSString *)message
             okTitle:(NSString *)okTitle
             okStyle:(UIAlertActionStyle)okStyle
         cancelTitle:(NSString *)cancelTitle
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock {
    if (!okBlock && !cancelBlock) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:question message: message preferredStyle:UIAlertControllerStyleAlert];
    if (okBlock) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:okTitle
                                                     style:okStyle
                                                   handler:^(UIAlertAction * _Nonnull action)
                             {
                                 okBlock();
                             }];
        [alertController addAction:ok];
    }
    if (cancelBlock) {
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     cancelBlock();
                                 }];
        [alertController addAction:cancel];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)awe_question:(NSString *)question
             okTitle:(NSString *)okTitle
             okStyle:(UIAlertActionStyle)okStyle
         cancelTitle:(NSString *)cancelTitle
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock {
    if (!okBlock && !cancelBlock) {
        return;
    }
    [self awe_question:nil
               message:question
               okTitle:okTitle
               okStyle:okStyle
           cancelTitle:cancelTitle
               okBlock:okBlock
           cancelBlock:cancelBlock];
}

- (void)awe_question:(NSString *)question
             okBlock:(dispatch_block_t)okBlock
         cancelBlock:(dispatch_block_t)cancelBlock {
    [self awe_question:question
               okTitle:@"确定"
               okStyle:UIAlertActionStyleDestructive
           cancelTitle:@"取消"
               okBlock:okBlock
           cancelBlock:cancelBlock];
}

@end
