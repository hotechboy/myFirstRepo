//
//  DCOTAModel.h
//  IDKEY
//
//  Created by roger on 15/1/13.
//  Copyright (c) 2015年 DynamiCode. All rights reserved.
//

#import "DCBaseModel.h"

UIKIT_EXTERN NSString *const DCOTAUpdateFinished;
UIKIT_EXTERN NSString *const DCOTAUpdateFailed;

typedef NS_ENUM(NSInteger, DCOTACommand) {
    DCOTACommandInvalid,
    DCOTACommandMetaData,
    DCOTACommandBrickData,
    DCOTACommandDataVerify,
    DCOTACommandExcutionNewCode
};

typedef NS_ENUM(NSInteger, DCOTAResult) {
    DCOTAResultSuccess,
    DCOTAResultPKTCheckSumError,
    DCOTAResultPKTLenError,
    DCOTAResultDeviceNotSupportOTA,
    DCOTAResultFWSizeError,
    DCOTAResultFWVerifyError,
    DCOTAResultInvalidArgument
};

@interface DCOTAPacket : NSObject
{
    NSData *_data;
    short _length;
    short _checksum;
}

@property (nonatomic, strong) NSData *data;
@property (nonatomic, assign) short length;
@property (nonatomic, assign) short checksum;

@end

@interface DCOTAModel : DCBaseModel

+ (DCOTAModel *)sharedInstance;

- (void)update:(NSData *)fileData;

@end
