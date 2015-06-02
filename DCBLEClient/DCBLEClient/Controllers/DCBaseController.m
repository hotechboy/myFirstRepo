//
//  DCBaseController.m
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCWaitingView.h"
#import "DCBaseController.h"

@interface DCBaseController ()
{
    DCWaitingView *_wait;
}
@end

@implementation DCBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // UI adapt for iOS 7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _wait = [[DCWaitingView alloc] init];
    [_wait addTarget:self action:@selector(breakWaiting:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alert:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)waiting:(NSString *)msg
{
    [_wait setTitle:msg];
    if (_wait.hidden) {
        [_wait show];
    }
}

- (void)hide
{
    [_wait hide];
}

- (void)breakWaiting:(id)sender
{
    [self hide];
}

@end
