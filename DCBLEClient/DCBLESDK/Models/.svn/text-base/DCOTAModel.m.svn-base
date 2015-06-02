//
//  DCOTAModel.m
//  IDKEY
//
//  Created by roger on 15/1/13.
//  Copyright (c) 2015年 DynamiCode. All rights reserved.
//

#import "DCOTAModel.h"

NSString *const DCOTAUpdateFinished = @"DCOTAUpdateFinished";
NSString *const DCOTAUpdateFailed = @"DCOTAUpdateFailed";


@implementation DCOTAPacket

@end


@interface DCOTAModel ()
{
    NSMutableData *_fileData;
    NSMutableData *_metaData;
    NSMutableData *_brickData;
    NSMutableData *_sendingData;
    NSMutableData *_remainData;
}
@end

@implementation DCOTAModel

SINGLETON_FOR_CLASS(DCOTAModel);

- (id)init
{
    self = [super init];
    if (self) {
        _fileData = [[NSMutableData alloc] init];
        _metaData = [[NSMutableData alloc] init];
        _brickData = [[NSMutableData alloc] init];
        _sendingData = [[NSMutableData alloc] init];
        _remainData = [[NSMutableData alloc] init];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(onResponse:) name:kDCBLEDidRecevieOTAResponse object:_client];
        [defaultCenter addObserver:self selector:@selector(requestFinished:) name:DCOTAUpdateFinished object:_client];
        [defaultCenter addObserver:self selector:@selector(requestFailed:) name:DCOTAUpdateFailed object:_client];
    }
    
    return self;
}

- (void)cleanup
{
    [_fileData setLength:0];
    [_metaData setLength:0];
    [_brickData setLength:0];
    [_sendingData setLength:0];
    [_remainData setLength:0];
}

- (Byte)cmdToVal:(DCOTACommand)cmd
{
    switch (cmd) {
        
        case DCOTACommandBrickData:
            return 1;
        case DCOTACommandDataVerify:
            return 2;
        case DCOTACommandExcutionNewCode:
            return 3;
        case DCOTACommandMetaData:
            return 4;
        default:
            break;
//        case DCOTACommandMetaData:
//            return 1;
//        case DCOTACommandBrickData:
//            return 2;
//        case DCOTACommandDataVerify:
//            return 3;
//        case DCOTACommandExcutionNewCode:
//            return 4;
//        default:
//            break;

    }
    return 0;
}

- (DCOTACommand)valToCmd:(int)value
{
    switch (value & 0x00ff) {
        case 1:
            return DCOTACommandMetaData;
        case 2:
            return DCOTACommandBrickData;
        case 3:
            return DCOTACommandDataVerify;
        case 4:
            return DCOTACommandExcutionNewCode;
        default:
            break;
    }
    return DCOTACommandInvalid;
}

- (BOOL)split:(NSData *)fileData
{
    if (!fileData) {
        NSLog(@"DCOTAModel split: data is nil.");
        return NO;
    }
    [_metaData setLength:0];
    [_brickData setLength:0];
    
    if (fileData && fileData.length > 2) {
        Byte *bytes = (Byte *)fileData.bytes;
        short metaLen = ((bytes[1] & 0x00FF) << 8) + bytes[0];
        if (fileData.length > metaLen + 2) {
            
            [_metaData appendBytes:fileData.bytes + 2 length:metaLen];
            [_brickData appendBytes:fileData.bytes + 2 + metaLen length:(fileData.length - metaLen - 2)];
            return YES;
        }
    }
    return NO;
}

- (short)checksumForCMD:(DCOTACommand)cmd andData:(NSData *)data
{
    if (data && data.length > 0) {
        
        short checksum = [self cmdToVal:cmd];
        for(int i = 0; i < data.length; i++) {
            Byte *bytes = (Byte *)data.bytes;
            checksum += bytes[i];
        }
        return checksum;
    }
    
    return -1;
}

- (NSString *)OTAErrorStringForResult:(DCOTAResult)result
{
    switch (result) {
        case DCOTAResultPKTCheckSumError:
            return @"数据包校验和错误";
        case DCOTAResultDeviceNotSupportOTA:
            return @"设备不支持OTA";
        case DCOTAResultPKTLenError:
            return @"数据包长度错误";
        case DCOTAResultFWSizeError:
            return @"固件大小错误";
        case DCOTAResultFWVerifyError:
            return @"固件校验错误";
        default:
            break;
    }
    return @"未知错误";
}

- (void)handleResponse:(NSData *)response
{
    if (response && response.length > 4) {
        Byte *bytes = (Byte *)response.bytes;
        DCOTACommand cmd = (DCOTACommand)[self valToCmd:bytes[2]];
        DCOTAResult result = (DCOTAResult)bytes[3];
        if (result == DCOTAResultSuccess) {
            if (cmd == DCOTACommandBrickData) {
                // offset of brick data
            }
            //else if (cmd == ) {}
        }
        else {
            [self post:DCOTAUpdateFailed info:@{ @"msg" : [self OTAErrorStringForResult:result] }];
        }
    }
}

- (void)otaSendMetaData:(NSData *)metaData
{
    DCOTAPacket *packet = [[DCOTAPacket alloc] init];
    //packet
}

- (NSData *)metaData
{
    short checksum = [self checksumForCMD:DCOTACommandMetaData andData:_metaData];
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    Byte head[3] = { 0x01, 0x00, 0x03 };
    [mutableData appendBytes:head length:sizeof(head)];
    Byte sum[2] = { 0x00, 0x00 };
    sum[0] = 0x03;//(Byte)(checksum & 0x00ff);
    sum[1] = 0x00;//(Byte)((checksum & 0xff00) >> 8);
    [mutableData appendBytes:sum length:sizeof(sum)];
    return mutableData;
}

- (NSData *)brickData:(NSData *)data
{
    NSMutableData *body = [NSMutableData data];
    Byte head[3] = { 0 };
    head[0] = (Byte)((data.length + 1) & 0x00ff);
    head[1] = (Byte)(((data.length + 1) & 0xff00) >> 8);
    head[2] = [self cmdToVal:DCOTACommandBrickData];
    [body appendBytes:head length:sizeof(head)];
    
    [body appendData:data];
    short checksum = [self checksumForCMD:DCOTACommandBrickData andData:data];
    Byte sum[2] = { 0x00, 0x00 };
    sum[0] = (Byte)(checksum & 0x00ff);
    sum[1] = (Byte)((checksum & 0xff00) >> 8);
    [body appendBytes:sum length:sizeof(sum)];
    return body;
}

- (void)update:(NSData *)fileData
{
    [self cleanup];
    if(!fileData) {
        NSLog(@"fileData is nil.");
        [self post:DCOTAUpdateFailed info:@{ @"msg" : @"更新失败, 文件数据是空的." }];
        return;
    }
    // fill file data
    [_fileData appendData:fileData];
    
    // split file data into meta data and brick data
    [self split:_fileData];
    
    NSData *metaData = [self metaData];
    Byte bytes[5] = { 0x01, 0x00, 0x02, 0x02, 0x00 };
    NSData *verifyData = [NSData dataWithBytes:bytes length:5];
    _client.mode = DCBLEWorkModeMetaData;
    [_client update:verifyData];
    Byte resetBytes[5] = { 0x01, 0x00, 0x02, 0x02, 0x00 };
    NSData *resetData = [NSData dataWithBytes:resetBytes length:5];
    [_client update:resetData];
}



- (void)onResponse:(NSNotification *)notification
{
    
    if (_client.mode == DCBLEWorkModeMetaData) {
        //_client.response;
        [self handleResponse:_client.response];
    }
}

- (void)requestFinished:(NSNotification *)notification
{
    if (_client.mode == DCBLEWorkModeMetaData) {
        //_client.response;
    }
}

- (void)requestFailed:(NSNotification *)notification
{}

@end
