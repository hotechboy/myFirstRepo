//
//  DCCategory.h
//  KeyPairManageTool
//
//  Created by roger on 13-12-2.
//  Copyright (c) 2013年 Dynamicode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DCCategory)

- (id)safeObjectAtIndex:(NSUInteger)index;

@end


@interface NSString (DCCategory)

- (NSString *)md5;
- (NSString *)sha1;
- (CGSize)sizeWithDCFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (NSString *)urlDecode;

@end


@interface NSDictionary (DCCategory)

- (int)intForKey:(NSString *)key;

- (float)floatForKey:(NSString *)key;



@end

@interface UIView (DCCategory)

- (void)centerInHorizontal;

@end

@interface UIImage (DCCategory)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end