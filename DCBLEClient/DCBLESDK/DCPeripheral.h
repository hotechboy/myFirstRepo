//
//  DCPeripheral.h
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCPeripheral : NSObject
{
    NSString *_name;
    NSString *_uuid;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;

@end
