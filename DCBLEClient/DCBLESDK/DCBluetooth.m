//
//  DCBluetooth.m
//  DCBluetooth
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCBLEScanModel.h"
#import "DCBLEConnectModel.h"
#import "DCBLETokenModel.h"
#import "DCBLEPinModel.h"
#import "DCBLEBindModel.h"
#import "DCBLESoundModel.h"
#import "DCBLEResetModel.h"
#import "DCSyncModel.h"
//#import "otaApi.h"

static NSString * const DCDomain = @"com.dynamicode";

@interface DCBluetooth ()
{
    DCBLEScanModel *_scanModel;
    DCBLEConnectModel *_connectModel;
    DCBLETokenModel *_tokenModel;
    DCBLEPinModel *_pinModel;
    DCBLEBindModel *_bindModel;
    DCBLESoundModel *_soundModel;
    DCBLEResetModel *_resetModel;
    DCSyncModel *_syncModel;
    NSMutableArray *_notifications;
}
@end

@implementation DCBluetooth

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    if (self) {
        _notifications = [[NSMutableArray alloc] init];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(onKeyClick:) name:kDCBLEPerpheralOnKeyClick object:nil];
        [defaultCenter addObserver:self selector:@selector(bluetoothStateDidUpdate:) name:kDCBLEClientStateDidUpdate object:nil];
        _soundModel = [DCBLESoundModel sharedInstance];
    }
    return self;
}

- (BOOL)contains:(NSString *)name
{
    if (_notifications && name && [name isKindOfClass:[NSString class]]) {
        
        for (NSString *notification in _notifications) {
            if ([name isEqualToString:notification]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)addNotification:(NSString *)name
{
    if (name && _notifications && ![self contains:name]) {
        [_notifications addObject:name];
    }
}

- (void)addNotifications:(NSArray *)names
{
    if (names) {
        for (NSString *name in names) {
            [self addNotification:name];
        }
    }
}

- (void)post:(NSString *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

- (BOOL)isPINValid:(NSString *)pin
{
    if (pin && pin.length == 6) {
        for (int i = 0; i < pin.length; i++) {
            char ch = [pin characterAtIndex:i];
            if (ch < 48 || ch > 57) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (void)scan
{
    if (!_scanModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _scanModel = [DCBLEScanModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(peripheralCountChanged:) name:kDCModelPeripheralCountChanged object:_scanModel];
        [self addNotification:kDCModelPeripheralCountChanged];
    }
    [_scanModel scan];
}

- (void)stopScan
{
    if (_scanModel) {
        [_scanModel stopScan];
    }
    else {
        NSLog(@"error: _scanModel is nil.");
    }
}

- (NSArray *)peripherals
{
    if (_scanModel) {
        return _scanModel.peripherals;
    }
    return nil;
}

- (void)initConnectModel
{
    if (!_connectModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _connectModel = [DCBLEConnectModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(peripheralConnected:) name:kDCBLEModelPeriphralConnected object:_connectModel];
        [defaultCenter addObserver:self selector:@selector(peripheralDisconnect:) name:kDCBLEModelPeriphralDisconnect object:_connectModel];
        [defaultCenter addObserver:self selector:@selector(peripheralDidFailToConnect:) name:kDCBLEModelPeriphralFailedToConnect object:_connectModel];
        [self addNotification:kDCBLEModelPeriphralConnected];
        [self addNotification:kDCBLEModelPeriphralDisconnect];
        [self addNotification:kDCBLEModelPeriphralFailedToConnect];
    }
}

- (DCPeripheral *)currentPeripheral
{
    [self initConnectModel];
    return _connectModel.peripheral;
}

- (void)connect:(DCPeripheral *)peripheral
{
    [self initConnectModel];
    [_connectModel connect:peripheral];
}

- (void)disconnect
{
    [self initConnectModel];
    [_connectModel disconnect];
}

- (BOOL)isConnected
{
    DCBLEClient *client = [DCBLEClient sharedInstance];
    return [client isConnected];
}

- (void)initTokenModel
{
    if (!_tokenModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _tokenModel = [DCBLETokenModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(getTokenCodeFinished:) name:kDCBLEModelGetTokenCodeFinished object:_tokenModel];
        [defaultCenter addObserver:self selector:@selector(getTokenCodeFailed:) name:kDCBLEModelGetTokenCodeFailed object:_tokenModel];
        [defaultCenter addObserver:self selector:@selector(getTokenSNFinished:) name:kDCBLEModelGetTokenSNFinished object:_tokenModel];
        [defaultCenter addObserver:self selector:@selector(getTokenSNFailed:) name:kDCBLEModelGetTokenSNFailed object:_tokenModel];
        [self addNotifications:@[ kDCBLEModelGetTokenCodeFinished, kDCBLEModelGetTokenCodeFailed, kDCBLEModelGetTokenSNFinished, kDCBLEModelGetTokenSNFailed ]];
    }
}

- (void)getTokenCode
{
    [self initTokenModel];
    [_tokenModel getTokenCode];
}

- (void)getTokenSN
{
    [self initTokenModel];
    [_tokenModel getTokenSN];
}

- (void)initPinModel
{
    if (!_pinModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _pinModel = [DCBLEPinModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(authPinFinished:) name:kDCBLEModelAuthPINFinished object:_pinModel];
        [defaultCenter addObserver:self selector:@selector(authPinFailed:) name:kDCBLEModelAuthPINFailed object:_pinModel];
        [defaultCenter addObserver:self selector:@selector(updatePinFinished:) name:kDCBLEModelUpdatePinFinished object:_pinModel];
        [defaultCenter addObserver:self selector:@selector(updatePinFailed:) name:kDCBLEModelUpdatePinFailed object:_pinModel];
        [self addNotifications:@[ kDCBLEModelAuthPINFinished, kDCBLEModelAuthPINFailed, kDCBLEModelUpdatePinFinished, kDCBLEModelUpdatePinFailed ]];
    }
}

- (void)authPin:(NSString *)pin
{
    [self initPinModel];
    if ([self isPINValid:pin]) {
        
        [_pinModel authPin:pin];
    }
    else {
        
        [self operationFailed:DCBluetoothOperationAuthPin description:@"不合法的PIN"];
    }
}

- (void)updatePin:(NSString *)pin
{
    [self initPinModel];
    if ([self isPINValid:pin]) {
        
        [_pinModel updatePin:pin];
    }
    else {
    
        [self operationFailed:DCBluetoothOperationUpdatePin description:@"不合法的PIN"];
    }
}

- (void)initBindModel
{
    if (!_bindModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _bindModel = [DCBLEBindModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(bindFinished:) name:kDCBLEModelBindFinished object:_bindModel];
        [defaultCenter addObserver:self selector:@selector(bindFailed:) name:kDCBLEModelBindFailed object:_bindModel];
        [defaultCenter addObserver:self selector:@selector(unbindFinished:) name:kDCBLEModelUnbindFinished object:_bindModel];
        [defaultCenter addObserver:self selector:@selector(unbindFailed:) name:kDCBLEModelUnbindFailed object:_bindModel];
        [self addNotifications:@[ kDCBLEModelBindFinished, kDCBLEModelBindFailed, kDCBLEModelUnbindFinished, kDCBLEModelUnbindFailed ]];
    }
}

- (void)bind:(NSString *)pin
{
    [self initBindModel];
    if ([self isPINValid:pin]) {
        
        [_bindModel bind:pin];
    }
    else {
        [self operationFailed:DCBluetoothOperationBind description:@"不合法的PIN"];
    }
}

- (void)unbind:(NSString *)pin
{
    [self initBindModel];
    if ([self isPINValid:pin]) {
        [_bindModel unbind:pin];
    }
    else {
        [self operationFailed:DCBluetoothOperationUnbind description:@"不合法的PIN"];
    }
}

- (void)buzz
{
    [_soundModel buzz];
}

- (void)silent
{
    [_soundModel silent];
}

- (void)initResetModel
{
    if (!_resetModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _resetModel = [DCBLEResetModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(resetFinished:) name:kDCBLEModelResetFinished object:_resetModel];
        [defaultCenter addObserver:self selector:@selector(resetFailed:) name:kDCBLEModelResetFailed object:_resetModel];
        [self addNotifications:@[ kDCBLEModelResetFinished, kDCBLEModelResetFailed ]];
    }
}

- (void)reset
{
    [self initResetModel];
    [_resetModel reset];
}

- (void)initSyncModel
{
    if (!_syncModel) {
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        _syncModel = [DCSyncModel sharedInstance];
        [defaultCenter addObserver:self selector:@selector(syncFinished:) name:kDCBLEModelSyncFinished object:_syncModel];
        [defaultCenter addObserver:self selector:@selector(syncFailed:) name:kDCBLEModelSyncFailed object:_syncModel];
        [self addNotifications:@[ kDCBLEModelSyncFinished, kDCBLEModelSyncFailed ]];
    }
}

- (void)syncServerTime
{
    [self initSyncModel];
    [_syncModel syncServerTime];
}

- (void)setServerURL:(NSString *)url
{
    [self initSyncModel];
    [_syncModel setServerURL:url];
}

#pragma mark
#pragma mark Handle Connection

- (void)peripheralConnected:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(bluetoothDidConnect:)]) {
            [_delegate bluetoothDidConnect:self];
        }
    }
}

- (void)peripheralDisconnect:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        if (_delegate && [_delegate respondsToSelector:@selector(bluetoothDisconnect:)]) {
            [_delegate bluetoothDisconnect:self];
        }
    }
}

- (void)peripheralDidFailToConnect:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        if (_delegate && [_delegate respondsToSelector:@selector(bluetoothDidFailToConnect:)]) {
            [_delegate bluetoothDidFailToConnect:self];
        }
    }
}

- (void)operationFailed:(DCBluetoothOperation)operation description:(NSString *)description
{
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidFinish:operation:error:)]) {
        NSError *error = [NSError errorWithDomain:DCDomain code:-1 userInfo:@{ NSLocalizedDescriptionKey : description }];
        [_delegate operationDidFinish:self operation:operation error:error];
    }
}

- (void)operationFinished:(DCBluetoothOperation)operation
{
    if (_delegate && [_delegate respondsToSelector:@selector(operationDidFinish:operation:error:)]) {
        [_delegate operationDidFinish:self operation:operation error:nil];
    }
}

#pragma mark
#pragma mark Handle Notifications

- (void)peripheralCountChanged:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        if (_delegate && [_delegate respondsToSelector:@selector(peripheralCountDidChange:)]) {
            [_delegate peripheralCountDidChange:self];
        }
    }
}

- (void)getTokenCodeFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
    
        self.tokenCode = _tokenModel.tokenCode;
        [self operationFinished:DCBluetoothOperationGetTokenCode];
    }
}

- (void)getTokenCodeFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFailed:DCBluetoothOperationGetTokenCode description:@"获取动态码失败"];
    }
}

- (void)getTokenSNFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        self.tokenSN = _tokenModel.tokenSN;
        [self operationFinished:DCBluetoothOperationGetTokenSN];
    }
}

- (void)getTokenSNFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFailed:DCBluetoothOperationGetTokenSN description:@"获取令牌序列号失败"];
    }
}

- (void)authPinFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationAuthPin];
    }
}

- (void)authPinFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFailed:DCBluetoothOperationAuthPin description:@"校验PIN失败"];
    }
}

- (void)updatePinFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationUpdatePin];
    }
}

- (void)updatePinFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        NSString *msg = @"修改PIN失败";
        NSDictionary *info = notification.userInfo;
        if (info) {
            msg = info[@"msg"];
        }
        [self operationFailed:DCBluetoothOperationUpdatePin description:msg];
    }
}

- (void)bindFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationBind];
    }
}

- (void)bindFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
    
        NSString *msg = @"绑定失败";
        NSDictionary *info = notification.userInfo;
        if (info) {
            msg = info[@"msg"];
        }
        [self operationFailed:DCBluetoothOperationBind description:msg];
    }
}

- (void)unbindFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationUnbind];
    }
}

- (void)unbindFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        NSString *msg = @"解绑失败";
        NSDictionary *info = notification.userInfo;
        if (info) {
            msg = info[@"msg"];
        }
        [self operationFailed:DCBluetoothOperationUnbind description:@"解绑失败"];
    }
}

- (void)resetFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationReset];
    }
}

- (void)resetFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFailed:DCBluetoothOperationReset description:@"重置设备失败"];
    }
}

- (void)syncFinished:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        [self operationFinished:DCBluetoothOperationSyncServerTime];
    }
}

- (void)syncFailed:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        NSString *msg = @"同步服务器时间失败";
        NSDictionary *info = notification.userInfo;
        if (info) {
            msg = info[@"msg"];
        }
        [self operationFailed:DCBluetoothOperationSyncServerTime description:msg];
    }
}

#pragma mark
#pragma mark Handle Notification From DCBLEClient

- (void)onKeyClick:(NSNotification *)notification
{
    if (_delegate && [_delegate respondsToSelector:@selector(bluetooth:shortClick:longClick:)]) {
        DCBLEClient *client = [DCBLEClient sharedInstance];
        NSData *response = client.response;
        if (response && response.length >= 7) {
            Byte *bytes = (Byte *)response.bytes;
            Byte cls = bytes[0];
            if (cls == 0x7D) {
                int shortClick = bytes[6];
                int longClick = bytes[5];
                [_delegate bluetooth:self shortClick:shortClick longClick:longClick];
                
            }
        }
    }
}

- (void)bluetoothStateDidUpdate:(NSNotification *)notification
{
    if (_delegate && [_delegate respondsToSelector:@selector(bluetoothStateDidChange:)]) {
        [_delegate bluetoothStateDidChange:self];
    }
}

- (void)bluetoothDidConnect:(NSNotification *)notification
{
    if ([self contains:notification.name]) {
        if (_delegate && [_delegate respondsToSelector:@selector(bluetoothDidConnect:)]) {
            [_delegate bluetoothDidConnect:self];
        }
    }
}

@end
