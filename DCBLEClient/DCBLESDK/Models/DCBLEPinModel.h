//
//  DCBLEPinModel.h
//  DCBLEClient
//
//  Created by roger on 14/11/4.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelAuthPINFinished      @"DCBLEModelAuthPINFinished"
#define kDCBLEModelAuthPINFailed        @"DCBLEModelAuthPINFailed"

#define kDCBLEModelUpdatePinFinished    @"DCBLEModelUpdatePinFinished"
#define kDCBLEModelUpdatePinFailed      @"DCBLEModelUpdatePinFailed"

typedef enum {
    DCBLEPinActionAuth,
    DCBLEPinActionUpdate
} DCBLEPinAction;

@interface DCBLEPinModel : DCBaseModel

+ (DCBLEPinModel *)sharedInstance;
- (void)authPin:(NSString *)pin;
- (void)updatePin:(NSString *)pin;

@end
