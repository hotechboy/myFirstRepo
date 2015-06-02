//
//  DCBLEAPDU.m
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBLEAPDU.h"

@implementation DCBLEAPDU

// byte[] { (byte) 0x7C,(byte) 0x15, (byte) 0x01, (byte) 0x01, (byte) 0x00 };
+ (NSData *)StartAPDU
{
    Byte apdu[5] = { 0x7C, 0x15, 0x01, 0x01, 0x00 };
    NSData *data = [[NSData alloc] initWithBytes:apdu length:sizeof(apdu)];
    return data;
}

//CLS：7C
//INS：11
//PW1-PW2: 01 01
//Lc：04
//命令：00 12 32 65
//【备注：】4 个字节的时间值
//Le：00
//APDU：7C 11 01 01 04 00 12 32 65
//Response APDU:
//10 00
//SW1SW2

+ (NSData *)SendTimeFactorAPDU:(int)offset
{
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] + offset;
    long min = (long)(time/60);

    // convert to hex bytes
    Byte minBytes[4] = {0};
    minBytes[3] = (Byte)(min & 0x000000FF);
    minBytes[2] = (Byte)((min & 0x0000FF00) >> 8);
    minBytes[1] = (Byte)((min & 0x00FF0000) >> 16);
    minBytes[0] = (Byte)((min & 0xFF000000) >> 24);
    
    Byte apdu[5] = { 0x7C, 0x11, 0x01, 0x01, 0x04};
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:apdu length:sizeof(apdu)];
    [data appendBytes:minBytes length:sizeof(minBytes)];
    return  data;
}

//【备注：】期待收到的字节数为 16 位字节(8 字节动态密码+4 字节时间+4 字节 MAC 校验值)
//CLS：7C
//INS：16
//PW1-PW2: 01 01
//Lc：01
//命令：00
//Le：10
//APDU：7C 12 01 01 01 00 10
//Response APDU:02 05 63 A2 12 12 25 26 00 12 12 00 01 02 03 02 10 00
//8 字节动态密码+4 字节时间+4 字节 MAC 校验值+SW1SW2

+ (NSData *)GetTokenCodeAPDU
{
    Byte apdu[7] = { 0x7C, 0x12, 0x01, 0x01, 0x01, 0x00, 0x10 };
    NSData *data = [[NSData alloc] initWithBytes:apdu length:sizeof(apdu)];
    return data;
}

//	CLS：7C
//  INS：16
//  PW1-PW2: 01 01
//  Lc：01
//  命令：00
//  Le：10
// 【备注：】期待收到的字节数为 16 位字节(8 字节动态密码+4 字节时间+4 字节 MAC 校验值)APDU：7C 12 01 01 01 00 10
//private static final byte[] APDU_TOKEN_GET_TOKENSN = new byte[] { (byte) 0x7C,(byte) 0x16, (byte) 0x01, (byte) 0x01, (byte) 0x00 , (byte) 0x10};
+ (NSData *)GetTokenSnAPDU
{
    Byte apdu[6] = { 0x7C, 0x16, 0x01, 0x01, 0x00, 0x10 };
    NSData *data = [[NSData alloc] initWithBytes:apdu length:sizeof(apdu)];
    return data;
}


// PIN指令相关
//CLS：78
//INS：10
//PW1-PW2: 01 01
//Lc：03
//命令：06 F8 55
//修改PIN请求[+原始PIN]()
//上报原始PIN是否匹配()
// 输入两次PIN，检查输入一致性()
// 发送新的PIN()
//提示按下按键()
//检查是否按下按键()
//修改结果()
//【备注：】06 F8 55 转换为十进制就是 456789.所以输入的 PIN 码需要从 10 进制转换
//为 16 进制，占用 3 个字节。
//Le：
//APDU：78 10 01 01 03 06 F8 55
//Response APDU:
//10 00
//SW1SW2

+ (NSData *)AuthPinAPDU:(NSString *)pin
{
    Byte apdu[5] = { 0x78, 0x10, 0x01, 0x01, 0x03};
    int intPin = [pin intValue];
    Byte hexPin[3] = {0};
    hexPin[2] = (Byte)(intPin & 0x000000FF);
    hexPin[1] = (Byte)((intPin & 0x0000FF00) >> 8);
    hexPin[0] = (Byte)((intPin & 0x00FF0000) >> 16);
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:apdu length:sizeof(apdu)];
    [data appendBytes:hexPin length:sizeof(hexPin)];
    return data;
}

//CLS：78
//INS：11
//PW1-PW2: 01 01
//Lc：03
//命令：06 F8 55
//【备注：】06 F8 55 转换为十进制就是 456789.所以输入的 PIN 码需要从 10 进制转换
//为 16 进制，占用 3 个字节。
//Le：
//APDU：78 11 01 01 03 06 F8 55
//Response APDU:
//10 00
//SW1SW2
//private static final byte[] APDU_PIN_UPDATE = new byte[] { (byte) 0x78,(byte) 0x11, (byte) 0x01, (byte) 0x01 };
+ (NSData *)UpdatePinAPDU:(NSString *)pin
{
    Byte apdu[5] = { 0x78, 0x11, 0x01, 0x01, 0x03};
    int intPin = [pin intValue];
    Byte hexPin[3] = {0};
    hexPin[2] = (Byte)(intPin & 0x000000FF);
    hexPin[1] = (Byte)((intPin & 0x0000FF00) >> 8);
    hexPin[0] = (Byte)((intPin & 0x00FF0000) >> 16);
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:apdu length:sizeof(apdu)];
    [data appendBytes:hexPin length:sizeof(hexPin)];
    return data;
}

+ (NSData *)LEDAPDU
{
    Byte apdu[12] = { 0x7F, 0x10, 0x01, 0x01, 0x07, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x01};
    return [[NSData alloc] initWithBytes:apdu length:sizeof(apdu)];
}

+ (NSData *)hexStringToData:(NSString *)hexString
{
    int len = (int)(hexString.length/2);
    NSMutableData *data = [NSMutableData data];
    for (int i = 0; i < len; i++) {
        NSRange range = NSMakeRange(i * 2, 2);
        NSString *sub = [hexString substringWithRange:range];
        Byte b = (Byte)[sub intValue];
        [data appendBytes:&b length:1];
    }
    return data;
}

// 3-bytes pin and 8-bytes udid
+ (NSData *)BindAPDU:(NSString *)pin udid:(NSString *)udid
{
    Byte apdu[5] = { 0x79, 0x10, 0x01, 0x01, 0x0b};
    int intPin = [pin intValue];
    Byte hexPin[3] = {0};
    hexPin[2] = (Byte)(intPin & 0x000000FF);
    hexPin[1] = (Byte)((intPin & 0x0000FF00) >> 8);
    hexPin[0] = (Byte)((intPin & 0x00FF0000) >> 16);
    
    NSData *udidData = [DCBLEAPDU hexStringToData:udid];
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:apdu length:sizeof(apdu)];
    [data appendBytes:hexPin length:sizeof(hexPin)];
    [data appendData:udidData];
    return data;
}


+ (NSData *)unBindAPDU:(NSString *)pin udid:(NSString *)udid
{
    Byte apdu[5] = { 0x79, 0x11, 0x01, 0x01, 0x0b};
    int intPin = [pin intValue];
    Byte hexPin[3] = {0};
    hexPin[2] = (Byte)(intPin & 0x000000FF);
    hexPin[1] = (Byte)((intPin & 0x0000FF00) >> 8);
    hexPin[0] = (Byte)((intPin & 0x00FF0000) >> 16);
    
    NSData *udidData = [DCBLEAPDU hexStringToData:udid];
    
    NSMutableData *data = [NSMutableData data];
    [data appendBytes:apdu length:sizeof(apdu)];
    [data appendBytes:hexPin length:sizeof(hexPin)];
    [data appendData:udidData];
    return data;
}

+ (NSData *)resetAPDU
{
    Byte apdu[4] = { 0x7A, 0x10, 0x01, 0x01 };
    return [NSData dataWithBytes:apdu length:4];
}

@end
