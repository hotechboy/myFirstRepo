//
//  DCWaitingView.m
//  NewMobileToken
//
//  Created by roger on 14-5-26.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//
//
//  DCWaitTransDataView.m
//  DCUIDemo
//
//  Created by roger on 13-11-14.
//  Copyright (c) 2013年 DynamiCode. All rights reserved.
//

#import "DCWaitingView.h"

#define DCColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
#define kDCMessageBoxFrame CGRectMake(0.0f, 0.0f, 280.0f, 124.0f)
#define kDCAlertViewCloseButtonColor DCColorFromRGB(0x0b6aff)
#define kDCAlertViewCloseButtonColorSelected DCColorFromRGB(0xe67e22)

@interface DCWaitingView ()
{
    UIView *_mask;
    UIImageView *_messageBg;
    UIActivityIndicatorView *_indicator;
    UILabel *_messageLabel;
    UIButton *_closeButton;
}

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DCWaitingView

- (id)init
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal + 1.0f;;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
        _mask = mask;
        mask.backgroundColor = [UIColor blackColor];
        mask.alpha = 0.0f;
        
        [self addSubview:mask];
        
        UIImageView *messageBoxBg = [[UIImageView alloc] initWithFrame:kDCMessageBoxFrame];
        messageBoxBg.center = CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f);
        messageBoxBg.image = [UIImage imageNamed:@"alert_bg"];
        messageBoxBg.layer.shadowColor = [UIColor blackColor].CGColor;
        messageBoxBg.layer.shadowOffset = CGSizeMake(0, 0);
        messageBoxBg.layer.shadowRadius = 5.0f;
        messageBoxBg.layer.shadowOpacity = 0.2;
        messageBoxBg.layer.shouldRasterize = YES;
        
        _messageBg = messageBoxBg;
        _messageBg.userInteractionEnabled = YES;
        [self addSubview:messageBoxBg];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        CGRect frame = _indicator.frame;
        frame.origin.x = (CGRectGetWidth(_messageBg.frame) - CGRectGetWidth(frame))/2.0f;
        frame.origin.y = 10.0f;
        _indicator.frame = frame;
        [_messageBg addSubview:_indicator];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, CGRectGetMaxY(_indicator.frame) + 10.0f, 240.0f, 20.0f)];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageLabel = messageLabel;
        [_messageBg addSubview:messageLabel];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(90.0f, CGRectGetMaxY(_messageLabel.frame) + 10.0f, 100.0f, 40.0f);
        [_closeButton setTitle:@"取消" forState:UIControlStateNormal];
        [_closeButton setTitleColor:kDCAlertViewCloseButtonColor forState:UIControlStateNormal];
        [_closeButton setTitleColor:kDCAlertViewCloseButtonColorSelected forState:UIControlStateHighlighted];
        _closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [_messageBg addSubview:_closeButton];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [_closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)show
{
    self.hidden = NO;
    
    _mask.alpha = 0;
    [UIView animateWithDuration:0.1 animations:^{
        _mask.alpha = 0.2;
    }];
    _messageBg.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.2],
                              [NSNumber numberWithFloat:0.9],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.2f;
    bounceAnimation.removedOnCompletion = NO;
    [_messageBg.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    [_indicator startAnimating];
}

- (void)hide
{
    _mask.alpha = 0.2;
    [UIView animateWithDuration:0.1 animations:^{
        _mask.alpha = 0.0f;
    }];
    
    
    _messageBg.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0);
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.0], nil];
    bounceAnimation.duration = 0.2f;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.delegate = self;
    [_messageBg.layer addAnimation:bounceAnimation forKey:@"hidebounce"];
    [_indicator stopAnimating];
    
}

- (void)setTitle:(NSString *)title
{
    self.messageLabel.text = title;
}

#pragma mark -

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if ([[_messageBg.layer animationForKey:@"hidebounce"] isEqual:theAnimation]) {
        self.hidden = YES;
    }
}


@end
