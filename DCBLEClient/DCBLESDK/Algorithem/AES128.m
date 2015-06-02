//
//  AES128.m
//  Example
//
//  Created by yanming niu on 12/12/12.
//  Copyright (c) 2012 Dynamicode. All rights reserved.
//

#import "AES128.h"

@implementation NSData(AES)

- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv 
{ 
    char keyPtr[kCCKeySizeAES128 + 1];  
    memset(keyPtr, 0, sizeof(keyPtr)); 
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding]; 
    NSLog(@"key: %@  %lu",key, (unsigned long)key.length);
    
    char ivPtr[kCCBlockSizeAES128 + 1];  
    memset(ivPtr, 0, sizeof(ivPtr)); 
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding]; 
    
    //test  
    printf("ivPtr \n");
    for (int i = 0; i< kCCBlockSizeAES128 + 1; i++) {
    printf("%c ",ivPtr[i]);
    }
    printf("\n");
    //test
    NSLog(@"iv: %@",iv);
    
    NSUInteger dataLength = [self length]; 
    size_t bufferSize = dataLength + kCCBlockSizeAES128; 
    void *buffer = malloc(bufferSize); 
    
    size_t numBytesCrypted = 0; 
    CCCryptorStatus cryptStatus = CCCrypt(operation, 
                                          kCCAlgorithmAES128, 
                                          kCCOptionPKCS7Padding, 
                                          keyPtr, 
                                          kCCBlockSizeAES128, 
                                          ivPtr, 
                                          [self bytes], 
                                          dataLength, 
                                          buffer, 
                                          bufferSize, 
                                          &numBytesCrypted); 
    if (cryptStatus == kCCSuccess) { 
        //test 
        /*
        printf("test buffer!");
        const char *buff = (const char *)buffer;
        for (int i = 0; i< strlen(buff); i++) {
            printf("%d ",buff[i]);
            
        }
        printf("\n");
         */
        //test
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        
      
    } 
    free(buffer); 
    return nil; 
} 

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv 
{ 
    return [self AES128Operation:kCCEncrypt key:key iv:iv]; 
} 

- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv 
{ 
    return [self AES128Operation:kCCDecrypt key:key iv:iv]; 
} 
@end
