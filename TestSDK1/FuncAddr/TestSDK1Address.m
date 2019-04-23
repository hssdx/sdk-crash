//
//  TestSDK1Address.m
//  TestSDK1
//
//  Created by xiongxunquan on 2019/4/18.
//

#import "TestSDK1Address.h"


extern void * TestSDK1FuncBegainAddress(void);
extern void * TestSDK1FuncEndAddress(void);
extern int64_t TestSDK1ExecuteImageSlide(void);


@implementation TestSDK1Address

+ (int64_t)begainAddress {
    return (int64_t)TestSDK1FuncBegainAddress();
}

+ (int64_t)endAddress {
    return (int64_t)TestSDK1FuncEndAddress();
}

+ (int64_t)realBegainAddress {
    return (int64_t)self.begainAddress - self.executeImageSlide;
}

+ (int64_t)realEndAddress {
    return (int64_t)self.endAddress - self.executeImageSlide;
}

+ (int64_t)executeImageSlide {
    return TestSDK1ExecuteImageSlide();
}

@end

