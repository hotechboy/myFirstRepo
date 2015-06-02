//
//  DCMacros.h
//  DCBLESDK
//
//  Created by roger on 14-10-30.
//  Copyright (c) 2014年 dynamicode. All rights reserved.
//


// Color Stuff
#define CGColorConvert(value)  (value/255.0f)
#define DCColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define DCColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:0.8]


//iOS Version
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)

// Other things
#define kDCDeviceiPad (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom])