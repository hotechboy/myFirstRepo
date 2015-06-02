//
//  DCBaseModel.h
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSingleton.h"
#import "DCPeripheral.h"
#import "DCBLEAPDU.h"
#import "DCBLEClient.h"


@interface DCBaseModel : NSObject
{
    DCBLEClient *_client;
}

- (void)post:(NSString *)notification;
- (void)post:(NSString *)notification info:(NSDictionary *)info;

@end
