//
//  TestSDK2.m
//  facephoto
//
//  Created by xunquan on 16/6/29.
//  Copyright © 2019年 bytedance. All rights reserved.
//

#import "TestSDK2.h"

@interface TestSDK2()

@end

@implementation TestSDK2

+ (void)testOverTheBoundary {
    NSArray *arr = @[@1];
    NSLog(@"%@", arr[1]);
}

+ (void)testUnrecognizedSelector {
    id obj = self;
    [obj performSelector:@selector(viewWillAppear:) withObject:nil];
}

+ (void)illegalAccess {
    
    char *ch = malloc(sizeof(char) * 10);
    ch[5] = '8';
    free(ch);
    ch[5] = '9';
    NSLog(@"%s", ch);
//    char* ptr = (char*)-1;
//    *ptr = 1;
}

@end
