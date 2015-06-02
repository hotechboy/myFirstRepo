//
//  DCSyncModel.m
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "Decrypt_.h"
#import "DCCategory.h"
#import "DynamiConnection.h"
#import "DynamiXMLParser.h"
#import "DCSyncModel.h"

#define kDefaultSyncURL     @"http://www.dctoken.com/dynamicode"
#define kDCSyncServerURL    @"DCSyncServerURL"

@interface DCSyncModel () <DynamiConnectionDelegate>
{
    DynamiConnection *_connection;
    NSString *_url;
}

@property (nonatomic, strong) DynamiConnection *connection;
@property (nonatomic, strong) NSString *url;

@end

@implementation DCSyncModel

SINGLETON_FOR_CLASS(DCSyncModel);

- (id)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *url = [ud stringForKey:kDCSyncServerURL];
    if (!url) {
        self.url = kDefaultSyncURL;
    }
}

- (NSString *)randomString
{
    unsigned int a = 0;
    NSString *str = nil;
    NSMutableString *result = [[NSMutableString alloc] init];
    
    for (int i = 0; i<16; i++) {
        a = arc4random() % 16;
        str = [NSString stringWithFormat:@"%X", a];
        [result appendString:str];
    }
    
    return  result;
}

- (void)setServerURL:(NSString *)url
{
    if (url && [url isKindOfClass:[NSString class]]) {
        self.url = url;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:url forKey:kDCSyncServerURL];
        [ud synchronize];
    }
}

- (void)syncServerTime
{
    NSString *version = @"2.0";
    NSString *packageType = @"4";
    NSString *etpsId = @"62810013";
    NSString *keyDisperseFactor = [self randomString];
    NSString *mobileType = @"2";
    NSString *packageMacString = [NSString stringWithFormat:@"%@;%@;%@;%@;%@", version, packageType, keyDisperseFactor, etpsId, mobileType];
    
    NSString *packageMac = [packageMacString sha1];
    
    NSString *requestXML = [NSString stringWithFormat:@"<?xml version='1.0' encoding='utf-8'?><TokenProtocol><Version>%@</Version><PackageType>%@</PackageType><KeyDisperseFactor>%@</KeyDisperseFactor><EtpsId>%@</EtpsId><MobileType>%@</MobileType><PackageMac>%@</PackageMac></TokenProtocol>", version, packageType, keyDisperseFactor, etpsId, mobileType, packageMac];
    
    NSLog(@"request XML: %@", requestXML);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/openapi/TokenOper", _url]];
    DynamiConnection *connection = [DynamiConnection connectionWithURL:url];
    self.connection = connection;
    connection.delegate = self;
    NSData *data = [requestXML dataUsingEncoding:NSUTF8StringEncoding];
    [connection POST:data];
}

- (void)requestFinished:(DynamiConnection *)conn;
{
    NSString *msg = @"同步服务器时间失败";
    @try {
        NSDictionary *dict = [DynamiXMLParser dictionaryWithXMLData:conn.response];
        if (dict) {
            NSLog(@"syncServerTime Response: %@", [dict description]);
            int responseCode = [dict intForKey:@"ResponseCode"];
            msg = [dict objectForKey:@"ResponseCodeDesc"];
            if (responseCode == 0) {
                
                NSString *keyDisperseFactor = dict[@"KeyDisperseFactor"];
                NSString *serverTime = dict[@"DCServerTime"];
                
                serverTime = [Decrypt_ decrypt:serverTime key:keyDisperseFactor iv:nil];
                NSLog(@"server time: %@", serverTime);
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeZone *serverZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
                [dateFormatter  setTimeZone:serverZone];
                NSDate *serverDate = [dateFormatter dateFromString:serverTime];
                _offset = [serverDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
                [self post:kDCBLEModelSyncFinished];
                return;
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Sync Server Time exception: %@", [exception description]);
    }
    NSString *error = msg == nil? @"同步服务器时间失败" : msg;
    [self post:kDCBLEModelSyncFailed info:@{ @"msg" : error }];
}

- (void)requestFailed:(DynamiConnection *)conn
{
    [self post:kDCBLEModelSyncFailed info:@{ @"msg" : @"网络错误" }];
}

@end
