//
//  DCBLEScanModel.h
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCPeripheral.h"
#import "DCBaseModel.h"

#define kDCModelPeripheralCountChanged @"DCModelPeripheralCountChanged"

@interface DCBLEScanModel : DCBaseModel
{
    NSMutableArray *_peripherals;
}

@property (nonatomic, strong) NSMutableArray *peripherals;

+ (DCBLEScanModel *)sharedInstance;

- (void)scan;
- (void)stopScan;

@end
