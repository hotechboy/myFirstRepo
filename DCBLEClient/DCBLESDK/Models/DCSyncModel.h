//
//  DCSyncModel.h
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelSyncFinished     @"DCBLEModelSyncFinished"
#define kDCBLEModelSyncFailed       @"DCBLEModelSyncFailed"

@interface DCSyncModel : DCBaseModel
{
    NSTimeInterval _offset;
}

@property (nonatomic, assign) NSTimeInterval offset;

+ (DCSyncModel *)sharedInstance;

- (void)setServerURL:(NSString *)url;
- (void)syncServerTime;

@end
