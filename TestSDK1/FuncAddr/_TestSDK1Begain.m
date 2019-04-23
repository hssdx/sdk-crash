//
//  _TestSDK1Begain.m
//  test
//
//  Created by xunquan on 16/6/29.
//  Copyright © 2019年 bytedance. All rights reserved.
//


#import "TestSDK1Address.h"
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

extern void * TestSDK1FuncBegainAddress(void) {
    return &TestSDK1FuncBegainAddress;
}


extern int64_t TestSDK1ExecuteImageSlide(void) {
    int64_t slide = 0;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = (int64_t)_dyld_get_image_vmaddr_slide(i);
            break;
        }
#if 0
        const char *pszModName = _dyld_get_image_name(i);
        NSString *imageName = [NSString stringWithUTF8String:pszModName];
        if ([imageName hasSuffix:@"WholeMusic"]) {
            slide = (int64_t)_dyld_get_image_vmaddr_slide(i);
            break;
        }
#endif
    }
    return slide;
}

