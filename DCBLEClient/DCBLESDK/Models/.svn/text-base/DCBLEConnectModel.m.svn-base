//
//  DCBLEConnectModel.m
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBLEClient.h"
#import "DCBLEConnectModel.h"

@implementation DCBLEConnectModel

SINGLETON_FOR_CLASS(DCBLEConnectModel);

- (id)init
{
    self = [super init];
    if (self) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(peripheralConnected:) name:kDCBLEPeripheralConnected object:_client];
        [defaultCenter addObserver:self selector:@selector(failedToConnect:) name:kDCBLEPeriphralFailedToConnect object:_client];
        [defaultCenter addObserver:self selector:@selector(peripheralDisconnect:) name:kDCBLEPeripheralDisconnect object:_client];
    }
    return self;
}

- (CBPeripheral *)lookup:(DCPeripheral *)peripheral
{
    DCBLEClient *client = [DCBLEClient sharedInstance];
    if (client.peripherals) {
        for (CBPeripheral *device in client.peripherals) {
            if ([peripheral.uuid isEqualToString:[DCBLEClient UUIDString:device]]) {
                return device;
            }
        }
    }
    return nil;
}

- (void)connect:(DCPeripheral *)peripheral
{
    if (!peripheral) {
        NSLog(@"DCBLEConnectModel connect error: @param peripheral is nil.");
        [self post:kDCBLEModelPeriphralFailedToConnect];
        return;
    }
    CBPeripheral *device = [self lookup:peripheral];
    if (!device) {
        NSLog(@"DCBLEConnectModel connect error: @param peripheral not exist.");
        [self post:kDCBLEModelPeriphralFailedToConnect];
        return;
    }
    self.peripheral = peripheral;
    [_client connect:device];
}

- (void)disconnect
{
    self.peripheral = nil;
    [_client disconnect];
}

#pragma mark 
#pragma mark Handle

- (void)peripheralConnected:(NSNotification *)notification
{
    [self post:kDCBLEModelPeriphralConnected];
}

- (void)failedToConnect:(NSNotification *)notification
{
    [self post:kDCBLEModelPeriphralFailedToConnect];
    self.peripheral = nil;
}

- (void)peripheralDisconnect:(NSNotification *)notification
{
    [self post:kDCBLEModelPeriphralDisconnect];
    self.peripheral = nil;
}

@end
