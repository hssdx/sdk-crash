//
//  TestSDK2Address.m
//  TestSDK2
//
//  Created by xiongxunquan on 2019/4/18.
//

#import "TestSDK2Address.h"


extern void * TestSDK2FuncBegainAddress(void);
extern void * TestSDK2FuncEndAddress(void);
extern int64_t TestSDK2ExecuteImageSlide(void);


@implementation TestSDK2Address

+ (int64_t)begainAddress {
    return (int64_t)TestSDK2FuncBegainAddress();
}

+ (int64_t)endAddress {
    return (int64_t)TestSDK2FuncEndAddress();
}

+ (int64_t)realBegainAddress {
    return (int64_t)self.begainAddress - self.executeImageSlide;
}

+ (int64_t)realEndAddress {
    return (int64_t)self.endAddress - self.executeImageSlide;
}

+ (int64_t)executeImageSlide {
    return TestSDK2ExecuteImageSlide();
}

@end

