//
//  DCBLESoundModel.m
//  DCBLEClient
//
//  Created by roger on 14/11/10.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCSingleton.h"
#import "DCBLESoundModel.h"

@implementation DCBLESoundModel

SINGLETON_FOR_CLASS(DCBLESoundModel);

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)buzz
{
    Byte byte[1] = { 0x02 };
    NSData *data = [NSData dataWithBytes:byte length:1];
    _client.mode = DCBLEWorkModeSound;
    [_client sound:data];
    _client.mode = DCBLEWorkModeNone;
}

- (void)silent
{
    Byte byte[1] = { 0x00 };
    NSData *data = [NSData dataWithBytes:byte length:1];
    _client.mode = DCBLEWorkModeSound;
    [_client sound:data];
    _client.mode = DCBLEWorkModeNone;
}

#pragma mark

@end
