//
//  DCBLEResetModel.h
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelResetFinished    @"DCBLEModelResetFinished"
#define kDCBLEModelResetFailed      @"DCBLEModelResetFailed"

@interface DCBLEResetModel : DCBaseModel

+ (DCBLEResetModel *)sharedInstance;

- (void)reset;

@end
