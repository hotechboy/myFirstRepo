//
//  DynamiXMLParser.h
//  MobileTokenSDK
//
//  Created by user on 13-9-22.
//  Copyright (c) 2013年 DynamiCode. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    XMLDictionaryAttributesModePrefixed = 0, //default
    XMLDictionaryAttributesModeDictionary,
    XMLDictionaryAttributesModeUnprefixed,
    XMLDictionaryAttributesModeDiscard
}
XMLDictionaryAttributesMode;


typedef enum
{
    XMLDictionaryNodeNameModeRootOnly = 0, //default
    XMLDictionaryNodeNameModeAlways,
    XMLDictionaryNodeNameModeNever
}
XMLDictionaryNodeNameMode;


static NSString *const XMLDictionaryAttributesKey   = @"__attributes";
static NSString *const XMLDictionaryCommentsKey     = @"__comments";
static NSString *const XMLDictionaryTextKey         = @"__text";
static NSString *const XMLDictionaryNodeNameKey     = @"__name";
static NSString *const XMLDictionaryAttributePrefix = @"_";


@interface DynamiXMLParser : NSObject <NSCopying>

+ (DynamiXMLParser *)sharedInstance;
+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data;

@property (nonatomic, assign) BOOL collapseTextNodes; // defaults to YES
@property (nonatomic, assign) BOOL trimWhiteSpace;    // defaults to YES
@property (nonatomic, assign) BOOL alwaysUseArrays;   // defaults to NO
@property (nonatomic, assign) BOOL preserveComments;  // defaults to NO

@property (nonatomic, assign) XMLDictionaryAttributesMode attributesMode;
@property (nonatomic, assign) XMLDictionaryNodeNameMode nodeNameMode;

- (NSDictionary *)dictionaryWithData:(NSData *)data;
- (NSDictionary *)dictionaryWithString:(NSString *)string;
- (NSDictionary *)dictionaryWithFile:(NSString *)path;

@end


@interface NSDictionary (XMLDictionary)

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data;
+ (NSDictionary *)dictionaryWithXMLString:(NSString *)string;
+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)path;

- (NSDictionary *)attributes;
- (NSDictionary *)childNodes;
- (NSArray *)comments;
- (NSString *)nodeName;
- (NSString *)innerText;
- (NSString *)innerXML;
- (NSString *)XMLString;

@end


@interface NSString (XMLDictionary)

- (NSString *)XMLEncodedString;

@end

