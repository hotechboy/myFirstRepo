//
//  DCBaseController.h
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCBaseController : UIViewController

- (void)alert:(NSString *)msg;

- (void)waiting:(NSString *)msg;

- (void)hide;

- (void)breakWaiting:(id)sender;

@end
