//
//  DCCategory.m
//  KeyPairManageTool
//
//  Created by roger on 13-12-2.
//  Copyright (c) 2013年 Dynamicode. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "DCCategory.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@implementation NSArray (DCCategory)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }
    return nil;
}
@end

@implementation NSString (DCCategory)

- (CGSize)sizeWithDCFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGSize newSize = CGSizeZero;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSDictionary *attrs = @{NSFontAttributeName:font};
        return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
    else {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return newSize;
}

- (NSString *)md5
{
    const char *str = [self UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *hash = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                      r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return hash;
}

- (NSString *)sha1
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02X", digest[i]];
    }
    
    return output;
}

- (NSString *)urlDecode
{
    if (self == nil || [self isEqualToString:@""]) {
        NSLog(@"urlDecode:msg is nil.");
        return nil;
    }
    NSString *result = nil;
    result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

@end


@implementation NSDictionary (DCCategory)

- (int)intForKey:(NSString *)key
{
    NSObject *obj = self[key];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return [((NSString *)obj) intValue];
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)obj intValue];
        }
    }
    return -1;
}

- (float)floatForKey:(NSString *)key
{
    NSObject *obj = self[key];
    if (obj) {
        if ([obj isKindOfClass:[NSString class]]) {
            return [((NSString *)obj) floatValue];
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)obj floatValue];
        }
    }
    return -1;
}

@end


@implementation UIView (DCCategory)

- (void)centerInHorizontal
{
    UIView *superView = self.superview;
    if (superView) {
        CGSize size = superView.frame.size;
        CGPoint center = self.center;
        center.x = size.width/2.0f;
        self.center = center;
    }
}

@end

@implementation UIImage (DCCategory)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end