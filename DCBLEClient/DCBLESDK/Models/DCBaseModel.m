//
//  DCBaseModel.m
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

@implementation DCBaseModel

- (id)init
{
    self = [super init];
    if (self) {
        _client = [DCBLEClient sharedInstance];
    }
    return self;
}

- (void)post:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

- (void)post:(NSString *)notification info:(NSDictionary *)info
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self userInfo:info];
}

@end
