//
//  DCBLEScanModel.m
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCMacros.h"
#import "DCBLEScanModel.h"


@implementation DCBLEScanModel

SINGLETON_FOR_CLASS(DCBLEScanModel);

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clientPeripheralCountChanged:) name:kDCBLEPeripheralCountChanged object:_client];
        _peripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)scan
{
    [_client scan];
}

- (void)stopScan
{
    [_client stopScan];
}

#pragma mark
#pragma mark Handle DCBLEClient Notification


- (void)clientPeripheralCountChanged:(NSNotification *)notification
{
    [_peripherals removeAllObjects];
    for (CBPeripheral *peripheral in _client.peripherals) {
        DCPeripheral *device = [[DCPeripheral alloc] init];
        device.name = peripheral.name;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            device.uuid = [peripheral.identifier UUIDString];
        }
        else {
            device.uuid = [[NSString alloc] initWithData:[CBUUID UUIDWithCFUUID:[peripheral UUID]].data encoding:NSUTF8StringEncoding];
        }
        
        [_peripherals addObject:device];
    }
    
    [self post:kDCModelPeripheralCountChanged];
}

@end
