//
//  Decrypt_.m
//  Example
//
//  Created by yanming niu on 12/13/12.
//  Copyright (c) 2012 Dynamicode. All rights reserved.
//

#import "Decrypt_.h"

@implementation Decrypt_
+(NSString *) decrypt:(NSString *)Ciphertext key:(NSString *)key iv:(NSString *)IV
{
    //注意:1.Key用MD5加密取前16位   2.密文转换为java Byte数组后,用AES128解密
    
    IV = @"0102030405060708";
    
    //md5加密key
    key = [MD5 md5:key];
    NSLog(@"md5: %@",key);
    if (key.length > 16) {
        key = [[key substringToIndex:16]uppercaseString];
        NSLog(@"key subto16: %@",key); 
    }
//    const  char *md5key = [key cStringUsingEncoding:NSASCIIStringEncoding];
//    NSString *keyStr = [NSString stringWithCString:md5key encoding:NSUTF8StringEncoding];
    
//    NSData *deData = [Ciphertext dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *deCodeBase64 = [GTMBase64 decodeData:deData];
    
    //加密内容转换为java二进制数组
    const char *contentStr = [Ciphertext cStringUsingEncoding:NSASCIIStringEncoding];
    char byte[strlen(contentStr)/2];
    hexstringToBytes(contentStr, byte, (unsigned long)strlen(contentStr));
    NSData *contentData = [NSData dataWithBytes:byte length:strlen(contentStr)/2];
    
    NSData *de = [contentData AES128DecryptWithKey:key iv:IV];
    NSLog(@"dccrypt: %@  length: %lu",de, (unsigned long)de.length);
    NSString *Plaintext = [[NSString alloc] initWithBytes:de.bytes length:de.length encoding:NSUTF8StringEncoding];   
    NSLog(@"de: %@",Plaintext);
    return Plaintext;
}


int hexcharToInt(char c)
{ 
    if (c >= '0' && c <= '9') return (c - '0');
    if (c >= 'A' && c <= 'F') return (c - 'A' + 10);
    if (c >= 'a' && c <= 'f') return (c - 'a' + 10);
    return 0;
}

void hexstringToBytes(const char* hexstring,char* bytes, unsigned long hexlength)
{         
    for (int i=0 ; i <hexlength ; i+=2) {
        bytes[i/2] = (char) ((hexcharToInt(hexstring[i]) << 4)
                             | hexcharToInt(hexstring[i+1]));
        printf(" %d",bytes[i/2]);
    }
    printf("\n");
}


@end
