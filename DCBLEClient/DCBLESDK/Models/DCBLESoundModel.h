//
//  DCBLESoundModel.h
//  DCBLEClient
//
//  Created by roger on 14/11/10.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

@interface DCBLESoundModel : DCBaseModel


+ (DCBLESoundModel *)sharedInstance;

- (void)buzz;

- (void)silent;

@end
