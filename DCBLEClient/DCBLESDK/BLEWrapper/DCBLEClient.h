//
//  DCBLEClient.h
//  DCBLESDK
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

// Notifications
#define kDCBLEPeripheralCountChanged @"DCBLEPeripheralCountChanged"
#define kDCBLEClientStateDidUpdate @"DCBLEClientStateDidUpdate"

#define kDCBLEPeripheralConnected @"DCBLEPeripheralConnected"
#define kDCBLEPeriphralFailedToConnect @"DCBLEPeriphralFailedToConnect"
#define kDCBLEPeripheralDisconnect @"DCBLEPeripheralDisconnect"

#define kDCBLEPeripheralRepuestFinished @"DCBLEPeripheralRepuestFinished"
#define kDCBLEPeripheralRequestFailed @"DCBLEPeripheralRequestFailed"

#define kDCBLEPerpheralOnKeyClick @"DCBLEPerpheralOnKeyClick"

#define kDCBLEDidRecevieOTAResponse @"DCBLEDidRecevieOTAResponse"

// UUIDs
#define DCBLE_SERVICE_UUID                  @"0000cc01-0000-1000-8000-00805f9b34fb"
#define DCBLE_WRITE_CHARACTERISTIC_UUID     @"0000cd20-0000-1000-8000-00805f9b34fb"
#define DCBLE_READ_CHARACTERISTIC_UUID      @"0000cd01-0000-1000-8000-00805f9b34fb"
#define DCBLE_READ2_CHARACTERISTIC_UUID     @"0000cd02-0000-1000-8000-00805f9b34fb"

#define DCBLE_SOUND_SERVICE_UUID            @"00001802-0000-1000-8000-00805f9b34fb"
#define DCBLE_SOUND_CHARACTERISTIC_UUID     @"00002a06-0000-1000-8000-00805f9b34fb"


// MTU Size: 20 bytes
#define kDCBLE_MTU_SIZE 20


typedef enum {
    DCBLEWorkModeNone,
    DCBLEWorkModeToken,
    DCBLEWorkModePin,
    DCBLEWorkModeBind,
    DCBLEWorkModeSound,
    DCBLEWorkModeReset
}DCBLEWorkMode;

@interface DCBLEClient : NSObject
{
    NSMutableArray *_peripherals;
    DCBLEWorkMode _mode;
    NSMutableData *_response;
    CBCentralManagerState _state;
    CBPeripheral *_peripheral;
}

@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, assign) DCBLEWorkMode mode;
@property (nonatomic, strong) NSMutableData *response;
@property (nonatomic, assign) CBCentralManagerState state;
@property (nonatomic, strong) CBPeripheral *peripheral;

+ (DCBLEClient *)sharedInstance;

+ (NSString *)UUIDString:(CBPeripheral *)peripheral;

- (void)scan;

- (void)stopScan;

- (void)connect:(CBPeripheral *)peripheral;
- (void)disconnect;

- (void)write:(NSData *)data;

- (void)sound:(NSData *)data;

- (BOOL)isConnected;

@end
