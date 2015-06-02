//
//  DCBLEClient.m
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCMacros.h"
#import "DCSingleton.h"
#import "DCBLEClient.h"

@interface DCBLEClient () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_manager;
    CBCharacteristic *_characteristic; // for write data
    CBCharacteristic *_soundCharacteristic;
    NSMutableData *_sendingData;
    NSMutableData *_remainData;
    
    NSMutableData *_receipt;
}

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBCharacteristic *characteristic;
@property (nonatomic, strong) CBCharacteristic *soundCharacteristic;

@end

@implementation DCBLEClient

SINGLETON_FOR_CLASS(DCBLEClient)

+ (NSString *)UUIDString:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return @"";
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return [peripheral.identifier UUIDString];
    }
    else {
        NSData *uuidData = [[CBUUID UUIDWithCFUUID:peripheral.UUID] data];
        return [[NSString alloc] initWithData:uuidData encoding:NSUTF8StringEncoding];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _peripherals = [[NSMutableArray alloc] init];
        _sendingData = [[NSMutableData alloc] init];
        _remainData = [[NSMutableData alloc] init];
        
        _response = [[NSMutableData alloc] init];
        
        _receipt = [[NSMutableData alloc] init];
    }
    return self;
}


- (void)cleanup
{
    if (_peripheral) {
        
        // See if we are subscribed to a characteristic on the peripheral
        if (_peripheral.services != nil) {
            for (CBService *service in _peripheral.services) {
                if (service.characteristics != nil) {
                    for (CBCharacteristic *characteristic in service.characteristics) {
                        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ_CHARACTERISTIC_UUID]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ2_CHARACTERISTIC_UUID]]) {
                            if (characteristic.isNotifying) {
                                [_peripheral setNotifyValue:NO forCharacteristic:characteristic];
                            }
                        }
                        
                    }
                }
            }
        }
        
        [_manager cancelPeripheralConnection:_peripheral];
        self.peripheral = nil;
        self.characteristic = nil;
        self.soundCharacteristic = nil;
        [_receipt setLength:0];
        [_response setLength:0];
    }
}

- (void)scan
{
    [_peripherals removeAllObjects];
    [self post:kDCBLEPeripheralCountChanged];
    [_manager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:DCBLE_SERVICE_UUID], [CBUUID UUIDWithString:DCBLE_SOUND_SERVICE_UUID] ] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
}

- (void)stopScan
{
    [_manager stopScan];
}

- (void)connect:(CBPeripheral *)peripheral
{
    [self cleanup];
    self.peripheral = peripheral;
    _peripheral.delegate = self;
    [_manager connectPeripheral:peripheral options:nil];
}

- (void)disconnect
{
    if (_peripheral) {
        [_manager cancelPeripheralConnection:_peripheral];
        self.peripheral = nil;
        self.characteristic = nil;
        self.soundCharacteristic = nil;
    }
}

- (BOOL)isConnected
{
    if (_peripheral) {

        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            return (_peripheral.state == CBPeripheralStateConnected);
        }
        else {
            return [_peripheral isConnected];
        }
    }
    return NO;
}

- (void)check:(id)obj
{
    if (_receipt.length == 0) {
        // did not receive any data
        [self post:kDCBLEPeripheralRequestFailed];
    }
}

- (void)write:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic
{
    [_receipt setLength:0];
    [_response setLength:0];
    _peripheral.delegate = self;
    if (data) {
        if (_peripheral && characteristic) {
            if (data.length > kDCBLE_MTU_SIZE) {
                [_sendingData setLength:0];
                [_sendingData appendBytes:data.bytes length:kDCBLE_MTU_SIZE];
                [_remainData setLength:0];
                [_remainData appendBytes:(data.bytes + kDCBLE_MTU_SIZE) length:(data.length - kDCBLE_MTU_SIZE)];
            }
            else {
                [_sendingData setLength:0];
                [_sendingData appendData:data];
                [_remainData setLength:0];
            }
            [_peripheral writeValue:_sendingData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
            //success
            return;
        }
    }
    // failed
    NSLog(@"DCBLEClient write:forCharacteristic: something is wrong.");
    [self performSelector:@selector(check:) withObject:nil afterDelay:1.0f];
}

- (void)write:(NSData *)data
{
    [self write:data forCharacteristic:_characteristic];
}

- (void)sound:(NSData *)data
{
    [_response setLength:0];
    _peripheral.delegate = self;
    if (data) {
        if (_peripheral && _soundCharacteristic) {
            [_sendingData setLength:0];
            [_sendingData appendData:data];
            [_remainData setLength:0];
            [_peripheral writeValue:_sendingData forCharacteristic:_soundCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}


#pragma mark

- (void)post:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

- (void)addPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    for (CBPeripheral *device in _peripherals) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            if ([device.identifier isEqual:peripheral.identifier]) {
                return;
            }
        }
        else {
            if ([[CBUUID UUIDWithCFUUID:device.UUID] isEqual:[CBUUID UUIDWithCFUUID:peripheral.UUID]]) {
                return;
            }
        }
    }
    
    [_peripherals addObject:peripheral];
    [self post:kDCBLEPeripheralCountChanged];
}

- (BOOL)isRecievedDataFinished:(NSData *)data
{
    if (data.length >= 5) {
        Byte *bytes = (Byte *)data.bytes;
        Byte lc = bytes[4];
        Byte totalLen = 5 + lc;
        
        if (totalLen <= data.length) {
            return YES;
        }
    }
    return NO;
}

#pragma mark
#pragma mark CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    _state = central.state;
    [self post:kDCBLEClientStateDidUpdate];
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey];
    NSLog(@"DCBLESDK >>> local name: %@, rssi: %d", localName, [RSSI intValue]);
    [self addPeripheral:peripheral];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:@[ [CBUUID UUIDWithString:DCBLE_SERVICE_UUID], [CBUUID UUIDWithString:DCBLE_SOUND_SERVICE_UUID] ]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"didFailToConnectPeripheral error: %@", [error description]);
    }
    [self post:kDCBLEPeriphralFailedToConnect];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (error) {
        NSLog(@"didDisconnectPeripheral error: %@", [error description]);
    }
    [self cleanup];
    [self post:kDCBLEPeripheralDisconnect];
}

#pragma mark
#pragma mark CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"didDiscoverServices error: %@", [error description]);
        [self cleanup];
        [self post:kDCBLEPeriphralFailedToConnect];
        return;
    }
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:DCBLE_SERVICE_UUID]]) {

            NSArray *characteristics = @[ [CBUUID UUIDWithString:DCBLE_READ_CHARACTERISTIC_UUID], [CBUUID UUIDWithString:DCBLE_READ2_CHARACTERISTIC_UUID], [CBUUID UUIDWithString:DCBLE_WRITE_CHARACTERISTIC_UUID] ];
            [peripheral discoverCharacteristics:characteristics forService:service];
        }
        else if ([service.UUID isEqual:[CBUUID UUIDWithString:DCBLE_SOUND_SERVICE_UUID]]) {
             [peripheral discoverCharacteristics:@[ [CBUUID UUIDWithString:DCBLE_SOUND_CHARACTERISTIC_UUID] ] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService error: %@", [error description]);
        [self cleanup];
        [self post:kDCBLEPeriphralFailedToConnect];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ_CHARACTERISTIC_UUID]]) {
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"find DCBLE_READ_CHARACTERISTIC_UUID");
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ2_CHARACTERISTIC_UUID]]) {
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"find DCBLE_READ2_CHARACTERISTIC_UUID");
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_WRITE_CHARACTERISTIC_UUID]]) {
            self.characteristic = characteristic;
            NSLog(@"DCBLE_WRITE_CHARACTERISTIC_UUID");
        }
        else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_SOUND_CHARACTERISTIC_UUID]]) {
            self.soundCharacteristic = characteristic;
            NSLog(@"DCBLE_SOUND_CHARACTERISTIC_UUID");
        }
    }
    if (_soundCharacteristic && _characteristic) {
        [self post:kDCBLEPeripheralConnected];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"didUpdateValueForCharacteristic error: %@", [error description]);
        [self post:kDCBLEPeripheralRequestFailed];
        return;
    }
    NSLog(@"didUpdateValueForCharacteristic: %@", [characteristic.value description]);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ_CHARACTERISTIC_UUID]] ||
        [characteristic.UUID isEqual:[CBUUID UUIDWithString:DCBLE_READ2_CHARACTERISTIC_UUID]] ) {
        
        NSData *receivedData = characteristic.value;
        if (receivedData && receivedData.length >= 7) {
            
            Byte *bytes = (Byte *)receivedData.bytes;
            Byte cls = bytes[0];
            if (cls == 0x7D) {
                // key click event
                [_response setLength:0];
                [_response appendData:receivedData];
                [self post:kDCBLEPerpheralOnKeyClick];
            }
            else if (cls == 0x7B) {
                // on receive receipt
                [_receipt setLength:0];
                [_receipt appendData:receivedData];
            }
            else {
                // normal response
                [_response appendData:receivedData];
                if ([self isRecievedDataFinished:_response]) {
                    // receive data finished
                    [self post:kDCBLEPeripheralRepuestFinished];
                }
            }
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"didWriteValueForCharacteristic error mode: %d, error: %@", _mode, [error description]);
        [self post:kDCBLEPeripheralRequestFailed];
        return;
    }
    NSLog(@"didWriteValueForCharacteristic mode: %d", _mode);
    
    if (_remainData.length > 0) {
        
        [self write:_remainData];
    }
}

@end
