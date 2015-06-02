//
//  DCBaseController.h
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DCColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define kDCSelectedColor DCColorFromRGB(0xdfdfdf)

@interface DCBaseController : UIViewController

+ (UIImage *)imageWithColor:(UIColor *)color;

- (void)alert:(NSString *)msg;

- (void)waiting:(NSString *)msg;

- (void)hide;

- (void)breakWaiting:(id)sender;

- (void)blockDDMenu:(BOOL)flag;

@end
