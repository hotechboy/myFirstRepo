//
//  DCWaitingView.h
//  NewMobileToken
//
//  Created by roger on 14-5-26.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCWaitingView : UIWindow

- (void)setTitle:(NSString *)title;

- (void)show;

- (void)hide;

- (void)addTarget:(id)target action:(SEL)action;

@end
