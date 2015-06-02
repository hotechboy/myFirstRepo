//
//  DCBLEPinModel.m
//  DCBLEClient
//
//  Created by roger on 14/11/4.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBLEPinModel.h"

@interface DCBLEPinModel ()
{
    DCBLEPinAction _action;
}

@end

@implementation DCBLEPinModel

SINGLETON_FOR_CLASS(DCBLEPinModel);

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

- (void)handleData:(NSData *)data
{
    @try {
        
        if (data && data.length > 5) {
            // valid apdu
            Byte *bytes = (Byte *)data.bytes;
            Byte cls = bytes[0];
            Byte ins = bytes[1];
            Byte lc = bytes[4];
            
            if (cls == 0x78) {
                Byte sw1 = bytes[lc + 5 - 2]; // byte before the last one
                Byte sw2 = bytes[lc + 5 - 1]; // last byte
                if (ins == 0x10) {
                    // auth pin
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        [self post:kDCBLEModelAuthPINFinished];
                        return;
                    }
                }
                else if (ins == 0x11) {
                    // update pin
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        [self post:kDCBLEModelUpdatePinFinished];
                        return;
                    }
                    else if (sw1 == 0x55 && sw2 == 0x00) {
                        [self post:kDCBLEModelUpdatePinFailed info:@{ @"msg" : @"按键确认超时" }];
                        return;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"DCBLEPinModel handleData exception: %@", [exception description]);
    }
    NSString *notification = (_action == DCBLEPinActionAuth)? kDCBLEModelAuthPINFailed : kDCBLEModelUpdatePinFailed;
    [self post:notification];
}

- (void)authPin:(NSString *)pin
{
    _action = DCBLEPinActionAuth;
    NSData *apdu = [DCBLEAPDU AuthPinAPDU:pin];
    _client.mode = DCBLEWorkModePin;
    [_client write:apdu];
}

- (void)updatePin:(NSString *)pin
{
    _action = DCBLEPinActionUpdate;
    NSData *apdu = [DCBLEAPDU UpdatePinAPDU:pin];
    NSLog(@"updatePin apdu: %@", [apdu description]);
    _client.mode = DCBLEWorkModePin;
    [_client write:apdu];
}

#pragma mark
#pragma mark Handle Notifications from DCBLEClient

- (void)requestFinished:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModePin) {
        [self handleData:_client.response];
    }
}

- (void)requestFailed:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModePin) {
        NSString *name = (_action == DCBLEPinActionAuth)? kDCBLEModelAuthPINFailed : kDCBLEModelUpdatePinFailed;
        [self post:name];
    }
}

@end
