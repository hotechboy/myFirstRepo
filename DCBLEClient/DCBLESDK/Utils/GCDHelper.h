//
//  GCDHelper.h
//  DCBLESDK
//
//  Created by roger on 14-10-30.
//  Copyright (c) 2014年 dynamicode. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef void (^ZenGCDBlock)(void);

@interface GCDHelper : NSObject
+ (void)dispatchBlock:(ZenGCDBlock)block complete:(ZenGCDBlock)completion;
@end
