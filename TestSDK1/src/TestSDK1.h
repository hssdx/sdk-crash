//
//  TestSDK1.h
//  test
//
//  Created by xunquan on 16/6/29.
//  Copyright © 2019年 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestSDK1 : NSObject

+ (void)testOverTheBoundary;

+ (void)testUnrecognizedSelector;

+ (void)illegalAccess;

@end
