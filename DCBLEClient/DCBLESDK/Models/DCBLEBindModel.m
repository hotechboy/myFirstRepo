//
//  DCBLEBindModel.m
//  DCBLEClient
//
//  Created by roger on 14/11/7.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DynamiOpenUDID.h"
#import "DCBLEAPDU.h"
#import "DCBLEBindModel.h"

@implementation DCBLEBindModel

SINGLETON_FOR_CLASS(DCBLEBindModel);

- (void)bind:(NSString *)pin
{
    NSString *value = [DynamiOpenUDID value];
    NSString *udid = [value substringToIndex:16];
    NSData *apdu = [DCBLEAPDU BindAPDU:pin udid:udid];
    NSLog(@"bind: %@",[apdu description]);
    _action = DCBLEBindActionBind;
    _client.mode = DCBLEWorkModeBind;
    [_client write:apdu];
}

- (void)unbind:(NSString *)pin
{
    NSString *value = [DynamiOpenUDID value];
    NSString *udid = [value substringToIndex:16];
    NSData *apdu = [DCBLEAPDU unBindAPDU:pin udid:udid];
    NSLog(@"unbind: %@", [apdu description]);
    _action = DCBLEBindActionUnbind;
    _client.mode = DCBLEWorkModeBind;
    [_client write:apdu];
}


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
            
            if (cls == 0x79) {
                Byte sw1 = bytes[lc + 5 - 2]; // byte before the last one
                Byte sw2 = bytes[lc + 5 - 1]; // last byte
                if (ins == 0x10) {
                    // bind
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        [self post:kDCBLEModelBindFinished];
                        return;
                    }
                    else if (sw1 == 0x55 && sw2 == 0x00) {
                        [self post:kDCBLEModelBindFailed info:@{ @"msg" : @"按键确认超时" }];
                        return;
                    }
                    else if (sw1 == 0x54 && sw2 == 0x00) {
                        [self post:kDCBLEModelBindFailed info:@{ @"msg" : @"PIN码错误" }];
                        return;
                    }
                }
                else if (ins == 0x11) {
                    // unbind
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        [self post:kDCBLEModelUnbindFinished];
                        return;
                    }
                    else if (sw1 == 0x54 && sw2 == 0x00) {
                        [self post:kDCBLEModelBindFailed info:@{ @"msg" : @"PIN码错误" }];
                        return;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"DCBLEPinModel handleData exception: %@", [exception description]);
    }
    NSString *notification = (_action == DCBLEBindActionBind)? kDCBLEModelBindFailed : kDCBLEModelUnbindFailed;
    [self post:notification];
}

#pragma mark
#pragma mark Handle Notifications from DCBLEClient

- (void)requestFinished:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeBind) {
        [self handleData:_client.response];
    }
}

- (void)requestFailed:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeBind) {
        NSString *name = (_action == DCBLEBindActionBind)? kDCBLEModelBindFailed : kDCBLEModelUnbindFailed;
        [self post:name];
    }
}


@end
