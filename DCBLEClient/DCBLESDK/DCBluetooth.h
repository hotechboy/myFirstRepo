//
//  DCBluetooth.h
//  DCBluetooth
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCPeripheral.h"

/*!
 *  @enum DCBluetoothState
 *
 *  @discussion 表示 DCBluetooth 的当前状态
 *
 *  @constant DCBluetoothStateUnknown           未知状态
 *  @constant DCBluetoothStateStateResetting    连接暂时断开, 并且正在重连
 *  @constant DCBluetoothStateUnsupported       手机不支持BLE
 *  @constant DCBluetoothStateUnauthorized      应用程序没有访问蓝牙的权限
 *  @constant DCBluetoothStatePoweredOff        蓝牙当前是关闭状态
 *  @constant DCBluetoothStatePoweredOn         蓝牙当前处于开启状态，可以使用
 *
 */

typedef NS_ENUM(NSInteger, DCBluetoothState) {
    DCBluetoothStateUnknown = 0,
    DCBluetoothStateStateResetting,
    DCBluetoothStateUnsupported,
    DCBluetoothStateUnauthorized,
    DCBluetoothStatePoweredOff,
    DCBluetoothStatePoweredOn
};


/*!
 *  @enum DCBluetoothOperation
 *
 *  @discussion 表示 DCBluetooth 执行的操作
 *
 *  @constant DCBluetoothOperationUnknow            未知操作 (这种情况，一般是出现错误了)
 *  @constant DCBluetoothOperationGetTokenCode      获取令牌动态码
 *  @constant DCBluetoothOperationGetTokenSN        获取令牌序列号
 *  @constant DCBluetoothOperationSyncServerTime    同步服务器时间
 *  @constant DCBluetoothOperationAuthPin           校验PIN
 *  @constant DCBluetoothOperationUpdatePin         修改PIN
 *  @constant DCBluetoothOperationBind              手机和外设绑定
 *  @constant DCBluetoothOperationUnbind            手机和外设解绑
 *  @constant DCBluetoothOperationBuzz              使外设发出响声
 *
 */

typedef NS_ENUM(NSInteger, DCBluetoothOperation) {
    DCBluetoothOperationUnknow = 0,
    DCBluetoothOperationGetTokenCode,
    DCBluetoothOperationGetTokenSN,
    DCBluetoothOperationSyncServerTime,
    DCBluetoothOperationAuthPin,
    DCBluetoothOperationUpdatePin,
    DCBluetoothOperationBind,
    DCBluetoothOperationUnbind,
    DCBluetoothOperationBuzz,
    DCBluetoothOperationReset
};


/*!
 *  @enum DCBluetoothOperation
 *
 *  @discussion 表示 DCBluetooth 执行的操作
 *
 *  @constant   DCBluetoothUpdateResultSuccess          更新固件成功
 *  @constant   DCBluetoothUpdateResultChecksumError    当前包校验和错误
 *  @constant   DCBluetoothUpdateResultLenError         当前包长度错误
 *  @constant   DCBluetoothUpdateResultNotSupport       设备不支持OTA
 *  @constant   DCBluetoothUpdateResultSizeError        固件太大或者为空
 *  @constant   DCBluetoothUpdateResultVerifyError      固件校验错误
 */

typedef NS_ENUM(NSInteger, DCBluetoothUpdateResult) {
    DCBluetoothUpdateResultSuccess = 0,
    DCBluetoothUpdateResultChecksumError,
    DCBluetoothUpdateResultLenError,
    DCBluetoothUpdateResultNotSupport,
    DCBluetoothUpdateResultSizeError,
    DCBluetoothUpdateResultVerifyError
};


@protocol DCBluetoothDelegate;
@interface DCBluetooth : NSObject
{
    __weak NSObject<DCBluetoothDelegate> *_delegate;
    DCBluetoothState _state;
    NSString *_tokenCode;
    NSString *_tokenSN;
}

@property (nonatomic, weak) NSObject<DCBluetoothDelegate> *delegate;
@property (nonatomic, assign) DCBluetoothState state;
@property (nonatomic, strong) NSString *tokenCode;
@property (nonatomic, strong) NSString *tokenSN;

/*!
 *  @method scan
 *
 *  @discuss 开始扫描
 */
- (void)scan;

/*!
 *  @method stopScan
 *
 *  @discuss 停止扫描
 */
- (void)stopScan;

/*!
 *  @method periphrals
 *
 *  @return 返回扫描到的外设列表，NSArray为DCPeripheral对象数组
 */
- (NSArray *)peripherals; // DCPeripheral objects

/*!
 *  @method currentPeripheral
 *
 *  @return 返回当前连接的设备
 */
- (DCPeripheral *)currentPeripheral;

/*!
 *  @method connect
 *
 *  @param peripheral DCPeripheral实例
 *
 *  @discuss 连接外设
 */
- (void)connect:(DCPeripheral *)peripheral;

/*!
 *  @method disconnect
 *
 *  @discuss 断开当前已连接的外设
 */
- (void)disconnect;

/*!
 *  @method isConnected
 *
 *  @discuss 检查手机当前是否与外设处于连接状态
 *
 *  @return YES - 已连接， NO - 未连接
 */
- (BOOL)isConnected;

/*!
 *  @method getTokenCode
 *
 *  @discuss 获取令牌动态码
 */
- (void)getTokenCode;

/*!
 *  @method getTokenSN
 *
 *  @discuss 获取令牌序列号
 */
- (void)getTokenSN;

/*!
 *  @method syncServerTime
 *
 *  @discuss 同步服务器时间
 */
- (void)syncServerTime;

/*!
 *  @method setServerURL
 *
 *  @param url 服务器地址
 *
 *  @discuss 设置服务器地址，没有设置则使用默认地址，该地址用于同步服务器时间
 */
- (void)setServerURL:(NSString *)url;

/*!
 *  @method authPin
 *
 *  @param pin 6位数字PIN码
 *
 *  @discuss 验证PIN码
 */
- (void)authPin:(NSString *)pin;

/*!
 *  @method updatePin
 *
 *  @param pin 6位数字PIN码
 *
 *  @discuss 修改PIN码
 */- (void)updatePin:(NSString *)pin;

/*!
 *  @method bind
 *
 *  @param pin 6位数字PIN码
 *
 *  @discuss 手机与外设绑定
 */
- (void)bind:(NSString *)pin;

/*!
 *  @method unbind
 *
 *  @param pin 6位数字PIN码
 *
 *  @discuss 手机与外设解除绑定
 */
- (void)unbind:(NSString *)pin;

/*!
 *  @method buzz
 *
 *  @discuss 开启外设蜂鸣
 */
- (void)buzz;

/*!
 *  @method silent
 *
 *  @discuss 关闭外设蜂鸣
 */
- (void)silent;

/*!
 *  @method reset
 *
 *  @discuss 重置设备
 */
- (void)reset;

@end

@protocol DCBluetoothDelegate <NSObject>

@optional

/*!
 *  @method bluetoothStateDidChange
 *
 *  @param bluetooth DCBluetooth实例
 *
 *  @discuss 当蓝牙状态发生改变时被调用，通过 bluetooth.state 访问改变后的状态；
 *
 */
- (void)bluetoothStateDidChange:(DCBluetooth *)bluetooth;

/*!
 *  @method peripheralCountDidChange
 *
 *  @param bluetooth DCBluetooth实例
 *
 *  @discuss 当扫描到符合条件的外设数量发生改变时被调用
 *
 */
- (void)peripheralCountDidChange:(DCBluetooth *)bluetooth;

/*!
 *  @method bluetoothDidConnect
 *
 *  @param bluetooth DCBluetooth实例
 *  
 *  @discuss 当调用 connect 方法，并且连接成功之后被调用
 *
 */
- (void)bluetoothDidConnect:(DCBluetooth *)bluetooth;

/*!
 *  @method bluetoothDidFailToConnect
 *
 *  @param bluetooth DCBluetooth实例
 *
 *  @discuss 当连接蓝牙失败时被调用
 *
 */
- (void)bluetoothDidFailToConnect:(DCBluetooth *)bluetooth;

/*!
 *  @method bluetoothDisconnect
 *
 *  @param bluetooth DCBluetooth实例
 *
 *  @discuss 当蓝牙设备连接断开时被调用
 *
 */
- (void)bluetoothDisconnect:(DCBluetooth *)bluetooth;

/*!
 *  @method operationDidFinish:operation:error
 *
 *  @param bluetooth DCBluetooth实例
 *  @param operation DCBluetoothOperation 枚举值
 *  @param error     NSError实例，如果操作发生错误则会有具体的错误信息，nil 表示操作成功
 *
 *  @discuss 调用具体接口后的异步回调，比如 调用接口 getTokenCode之后，operationDidFinish:operation:error:
 *      将被调用，operation = DCBluetoothOperationGetTokenCode
 *
 */
- (void)operationDidFinish:(DCBluetooth *)bluetooth operation:(DCBluetoothOperation)operation error:(NSError *)error;

/*!
 *  @method bluetooth:shortClick:longClick
 *
 *  @param bluetooth  DCBluetooth实例
 *  @param shortClick 短按键次数
 *  @param longClick  长按键次数
 *
 *  @discuss 当外设按键被按下时被调用， 支持组合按键
 *
 */
- (void)bluetooth:(DCBluetooth *)bluetooth shortClick:(int)shortClick longClick:(int)longClick;

- (void)bluetooth:(DCBluetooth *)bluetooth updateDataSent:(int)length result:(DCBluetoothUpdateResult)result;

- (void)bluetooth:(DCBluetooth *)bluetooth updateResult:(DCBluetoothUpdateResult)result;

@end