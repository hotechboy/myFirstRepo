//
//  DCBLETokenModel.m
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCSyncModel.h"
#import "DCBLETokenModel.h"

@interface DCBLETokenModel ()
{
    DCBLETokenAction _action;
}
@end

@implementation DCBLETokenModel

SINGLETON_FOR_CLASS(DCBLETokenModel);

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

// parser apdu response
- (void)handleData:(NSData *)data
{
    @try {
        
        if (data && data.length > 5) {
            // valid apdu
            Byte *bytes = (Byte *)data.bytes;
            Byte cls = bytes[0];
            Byte ins = bytes[1];
            Byte lc = bytes[4];
            
            if (cls == 0x7C) {
                Byte sw1 = bytes[lc + 5 - 2]; // byte before the last one
                Byte sw2 = bytes[lc + 5 - 1]; // last byte
                if (ins == 0x15) {
                    // start token
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        // success
                        NSLog(@"start success");
                        if (_action == DCBLETokenActionGetTokenCode) {
                            
                            [self sendTime:[DCSyncModel sharedInstance].offset];
                        }
                        else {
                            [self fetchTokenSN];
                        }
                        return;
                    }
                    
                }
                else if (ins == 0x11) {
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        // success
                        NSLog(@"send time success");
                        [self fetchTokenCode];
                        return;
                    }
                }
                else if (ins == 0x12) {
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        // success
                        NSLog(@"get token code success");
                        Byte *package = (Byte *)(bytes + 5);
                        
                        if (data.length - 5 > 8) {
                            NSMutableString *tmp = [[NSMutableString alloc] init];
                            for (int i = 0; i < 8; i++) {
                                [tmp appendFormat:@"%d", package[i]];
                            }
                            self.tokenCode = tmp;
                            NSLog(@"token code: %@", _tokenCode);
                            [self post:kDCBLEModelGetTokenCodeFinished];
                        }
                        return;
                    }
                }
                else if (ins == 0x16) {
                    // get token sn
                    if (sw1 == 0x10 && sw2 == 0x00) {
                        NSLog(@"get token sn success");
                        Byte *package = (Byte *)(bytes + 5);
                        int len = (int)(data.length - 5 - 2);
                        NSMutableString *tmp = [[NSMutableString alloc] init];
                        for (int i = 0; i < len; i++) {
                            [tmp appendFormat:@"%d", package[i]];
                        }
                        self.tokenSN = tmp;
                        NSLog(@"token sn: %@", _tokenSN);
                        [self post:kDCBLEModelGetTokenSNFinished];
                        return;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"DCBLETokenModel exception: %@", [exception description]);
    }
    // handle error
    NSString *notification = (_action == DCBLETokenActionGetTokenCode)? kDCBLEModelGetTokenCodeFailed : kDCBLEModelGetTokenSNFailed;
    [self post:notification];
}

- (void)startToken:(DCBLETokenAction)action
{
    _action = action;
    NSData *apdu = [DCBLEAPDU StartAPDU];
    NSLog(@"start token apdu: %@", [apdu description]);
    _client.mode = DCBLEWorkModeToken;
    [_client write:apdu];
}

- (void)sendTime:(NSTimeInterval)offset
{
    NSData *apdu = [DCBLEAPDU SendTimeFactorAPDU:offset];
    NSLog(@"send time apdu: %@", [apdu description]);
    _client.mode = DCBLEWorkModeToken;
    [_client write:apdu];
}

- (void)fetchTokenCode
{
    NSData *apdu = [DCBLEAPDU GetTokenCodeAPDU];
    NSLog(@"get token code apdu: %@", [apdu description]);
    _client.mode = DCBLEWorkModeToken;
    [_client write:apdu];
}

- (void)fetchTokenSN
{
    NSData *apdu = [DCBLEAPDU GetTokenSnAPDU];
    NSLog(@"get token sn apdu: %@", [apdu description]);
    _client.mode = DCBLEWorkModeToken;
    [_client write:apdu];
}


// startToken -> sendTime -> fetchTokenCode
- (void)getTokenCode
{
    [self startToken:DCBLETokenActionGetTokenCode];
}

// startToken -> fetchTokenSN
- (void)getTokenSN
{
    [self startToken:DCBLETokenActionGetTokenSN];
}

#pragma mark 

- (void)requestFinished:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeToken) {
        NSLog(@"Token Operation finished with response: %@", [_client.response description]);
        [self handleData:_client.response];
    }
}

- (void)requestFailed:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeToken) {
        
        NSString *name = (_action == DCBLETokenActionGetTokenCode)? kDCBLEModelGetTokenCodeFailed : kDCBLEModelGetTokenSNFailed;
        [self post:name];
    }
}

@end
