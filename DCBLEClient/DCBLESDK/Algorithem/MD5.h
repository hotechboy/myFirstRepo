//
//  MD5.h
//  Example
//
//  Created by yanming niu on 12/14/12.
//  Copyright (c) 2012 Dynamicode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>   //包含md5算法

@interface MD5 : NSObject
+(NSString *)md5:(NSString *)str;

@end
