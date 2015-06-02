//
//  AES128.h
//  Example
//
//  Created by yanming niu on 12/12/12.
//  Copyright (c) 2012 Dynamicode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h> 

@interface NSData(AES)
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv; 
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv; 
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv; 
@end
