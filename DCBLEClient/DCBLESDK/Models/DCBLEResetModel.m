//
//  DCBLEResetModel.m
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBLEResetModel.h"

@implementation DCBLEResetModel

SINGLETON_FOR_CLASS(DCBLEResetModel);

- (id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(requestFinished:) name:kDCBLEPeripheralRepuestFinished object:_client];
        [defaultCenter addObserver:self selector:@selector(requestFailed:) name:kDCBLEPeripheralRequestFailed object:_client];
    }
    return self;
}

- (void)reset
{
    NSData *apdu = [DCBLEAPDU resetAPDU];
    _client.mode = DCBLEWorkModeReset;
    [_client write:apdu];
}

- (void)handleData:(NSData *)data
{
    @try {
        if (data && data.length > 5) {
            // valid apdu
            Byte *bytes = (Byte *)data.bytes;
            Byte cls = bytes[0];
            Byte ins = bytes[1];
            Byte lc = bytes[4];
            
            if (cls == 0x7A) {
                Byte sw1 = bytes[lc + 5 - 2]; // byte before the last one
                Byte sw2 = bytes[lc + 5 - 1]; // last byte
                if (ins == 0x10) {
                    // reset
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        [self post:kDCBLEModelResetFinished];
                        return;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"DCBLEResetModel handleData exception: %@", [exception description]);
    }
    [self post:kDCBLEModelResetFailed];
}

#pragma mark
#pragma mark - Handle DCBLEClient Notifications

- (void)requestFinished:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeReset) {
        [self handleData:_client.response];
    }
}

- (void)requestFailed:(NSNotification *)notification
{
    [self post:kDCBLEModelResetFailed];
}

@end
