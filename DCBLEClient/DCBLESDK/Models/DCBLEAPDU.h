//
//  DCBLEAPDU.h
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCBLEAPDU : NSObject

// 令牌相关 APDU
+ (NSData *)StartAPDU;

+ (NSData *)SendTimeFactorAPDU:(int)offset;

+ (NSData *)GetTokenCodeAPDU;

+ (NSData *)GetTokenSnAPDU;

+ (NSData *)AuthPinAPDU:(NSString *)pin;

+ (NSData *)UpdatePinAPDU:(NSString *)pin;

+ (NSData *)BindAPDU:(NSString *)pin udid:(NSString *)udid;

+ (NSData *)unBindAPDU:(NSString *)pin udid:(NSString *)udid;

+ (NSData *)resetAPDU;

@end
