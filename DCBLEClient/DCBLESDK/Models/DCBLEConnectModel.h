//
//  DCBLEConnectModel.h
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelPeriphralConnected       @"DCBLEModelPeriphralConnected"
#define kDCBLEModelPeriphralFailedToConnect @"DCBLEModelPeriphralFailedToConnect"
#define kDCBLEModelPeriphralDisconnect      @"DCBLEModelPeriphralDisconnect"

@interface DCBLEConnectModel : DCBaseModel
{
    DCPeripheral *_peripheral;
}

@property (nonatomic, strong) DCPeripheral *peripheral;

+ (DCBLEConnectModel *)sharedInstance;

- (void)connect:(DCPeripheral *)peripheral;
- (void)disconnect;

@end
