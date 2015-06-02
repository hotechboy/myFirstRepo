//
//  GCDHelper.m
//  DCBLESDK
//
//  Created by roger on 14-10-30.
//  Copyright (c) 2014年 dynamicode. All rights reserved.
//


#import "GCDHelper.h"

@implementation GCDHelper

+ (void)dispatchBlock:(ZenGCDBlock)block complete:(ZenGCDBlock)completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            block();
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }
        }
    });
}

@end
