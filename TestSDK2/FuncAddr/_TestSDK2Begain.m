//
//  _TestSDK2Begain.m
//  test
//
//  Created by xunquan on 16/6/29.
//  Copyright © 2019年 bytedance. All rights reserved.
//


#import "TestSDK2Address.h"
#import <mach-o/dyld.h>


extern void * TestSDK2FuncBegainAddress(void) {
    return &TestSDK2FuncBegainAddress;
}


extern int64_t TestSDK2ExecuteImageSlide(void) {
    int64_t slide = -1;
    for (uint32_t i = 0; i < _dyld_image_count(); i++) {
        if (_dyld_get_image_header(i)->filetype == MH_EXECUTE) {
            slide = (int64_t)_dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
    return slide;
}

