//
//  DCBLEBindModel.h
//  DCBLEClient
//
//  Created by roger on 14/11/7.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelBindFinished     @"DCBLEModelBindFinished"
#define kDCBLEModelBindFailed       @"DCBLEModelBindFailed"
#define kDCBLEModelUnbindFinished   @"DCBLEModelUnbindFinished"
#define kDCBLEModelUnbindFailed     @"DCBLEModelUnbindFailed"


typedef NS_ENUM(NSInteger, DCBLEBindAction) {
    DCBLEBindActionBind,
    DCBLEBindActionUnbind
};

@interface DCBLEBindModel : DCBaseModel
{
    DCBLEBindAction _action;
}

+ (DCBLEBindModel *)sharedInstance;

- (void)bind:(NSString *)pin;

- (void)unbind:(NSString *)pin;

@end
