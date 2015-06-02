//
//  DCBLETokenModel.h
//  DCBLEClient
//
//  Created by roger on 14/10/31.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

#define kDCBLEModelGetTokenCodeFinished @"DCBLEModelGetTokenCodeFinished"
#define kDCBLEModelGetTokenCodeFailed @"DCBLEModelGetTokenCodeFailed"

#define kDCBLEModelGetTokenSNFinished @"DCBLEModelGetTokenSNFinished"
#define kDCBLEModelGetTokenSNFailed @"DCBLEModelGetTokenSNFailed"

typedef enum {
    DCBLETokenActionGetTokenCode,
    DCBLETokenActionGetTokenSN
} DCBLETokenAction;

@interface DCBLETokenModel : DCBaseModel
{
    NSString *_tokenCode;
    NSString *_tokenSN;
}

@property (nonatomic, strong) NSString *tokenCode;
@property (nonatomic, strong) NSString *tokenSN;

+ (DCBLETokenModel *)sharedInstance;

- (void)getTokenCode;
- (void)getTokenSN;

@end
