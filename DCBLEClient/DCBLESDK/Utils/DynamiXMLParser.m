//
//  DynamiXMLParser.m
//  MobileTokenSDK
//
//  Created by user on 13-9-22.
//  Copyright (c) 2013年 DynamiCode. All rights reserved.
//


#import "DynamiXMLParser.h"

#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@interface DynamiXMLParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *root;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableString *text;

@end


@implementation DynamiXMLParser

+ (DynamiXMLParser *)sharedInstance
{
    static dispatch_once_t once;
    static DynamiXMLParser *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[DynamiXMLParser alloc] init];
    });
    return sharedInstance;
}

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data
{
    return [[[self sharedInstance] copy] dictionaryWithData:data];
}

- (id)init
{
    if ((self = [super init]))
    {
        _collapseTextNodes = YES;
        _trimWhiteSpace = YES;
        _alwaysUseArrays = NO;
        _preserveComments = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    DynamiXMLParser *copy = [[[self class] allocWithZone:zone] init];
    copy.collapseTextNodes = _collapseTextNodes;
    copy.trimWhiteSpace = _trimWhiteSpace;
    copy.alwaysUseArrays = _alwaysUseArrays;
    copy.preserveComments = _preserveComments;
    copy.attributesMode = _attributesMode;
    copy.nodeNameMode = _nodeNameMode;
    return copy;
}

- (NSDictionary *)dictionaryWithData:(NSData *)data
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    id result = _root;
    _root = nil;
    _stack = nil;
    _text = nil;
    return result;
}

- (NSDictionary *)dictionaryWithString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithData:data];
}

- (NSDictionary *)dictionaryWithFile:(NSString *)path
{	
	NSData *data = [NSData dataWithContentsOfFile:path];
	return [self dictionaryWithData:data];
}

+ (NSString *)XMLStringForNode:(id)node withNodeName:(NSString *)nodeName
{	
    if ([node isKindOfClass:[NSArray class]])
    {
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[node count]];
        for (id individualNode in node)
        {
            [nodes addObject:[self XMLStringForNode:individualNode withNodeName:nodeName]];
        }
        return [nodes componentsJoinedByString:@"\n"];
    }
    else if ([node isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *attributes = [(NSDictionary *)node attributes];
        NSMutableString *attributeString = [NSMutableString string];
        for (NSString *key in [attributes allKeys])
        {
            [attributeString appendFormat:@" %@=\"%@\"", [key XMLEncodedString], [attributes[key] XMLEncodedString]];
        }
        
        NSString *innerXML = [node innerXML];
        if ([innerXML length])
        {
            return [NSString stringWithFormat:@"<%1$@%2$@>%3$@</%1$@>", nodeName, attributeString, innerXML];
        }
        else
        {
            return [NSString stringWithFormat:@"<%@%@/>", nodeName, attributeString];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"<%1$@>%2$@</%1$@>", nodeName, [[node description] XMLEncodedString]];
    }
}

- (void)endText
{
	if (_trimWhiteSpace)
	{
		_text = [[_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
	}
	if ([_text length])
	{
        NSMutableDictionary *top = [_stack lastObject];
		id existing = top[XMLDictionaryTextKey];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:_text];
        }
        else if (existing)
        {
            top[XMLDictionaryTextKey] = [@[existing, _text] mutableCopy];
        }
		else
		{
			top[XMLDictionaryTextKey] = _text;
		}
	}
	_text = nil;
}

- (void)addText:(NSString *)text
{	
	if (!_text)
	{
		_text = [NSMutableString stringWithString:text];
	}
	else
	{
		[_text appendString:text];
	}
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{	
	[self endText];
	
	NSMutableDictionary *node = [NSMutableDictionary dictionary];
	switch (_nodeNameMode)
	{
        case XMLDictionaryNodeNameModeRootOnly:
        {
            if (!_root)
            {
                node[XMLDictionaryNodeNameKey] = elementName;
            }
            break;
        }
        case XMLDictionaryNodeNameModeAlways:
        {
            node[XMLDictionaryNodeNameKey] = elementName;
            break;
        }
        case XMLDictionaryNodeNameModeNever:
        {
            break;
        }
	}
    
	if ([attributeDict count])
	{
        switch (_attributesMode)
        {
            case XMLDictionaryAttributesModePrefixed:
            {
                for (NSString *key in [attributeDict allKeys])
                {
                    node[[XMLDictionaryAttributePrefix stringByAppendingString:key]] = attributeDict[key];
                }
                break;
            }
            case XMLDictionaryAttributesModeDictionary:
            {
                node[XMLDictionaryAttributesKey] = attributeDict;
                break;
            }
            case XMLDictionaryAttributesModeUnprefixed:
            {
                [node addEntriesFromDictionary:attributeDict];
                break;
            }
            case XMLDictionaryAttributesModeDiscard:
            {
                break;
            }
        }
	}
	
	if (!_root)
	{
		_root = node;
		_stack = [NSMutableArray arrayWithObject:node];
	}
	else
	{
        NSMutableDictionary *top = [_stack lastObject];
		id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:node];
        }
        else if (existing)
        {
            top[elementName] = [@[existing, node] mutableCopy];
        }
        else if (_alwaysUseArrays)
        {
            top[elementName] = [NSMutableArray arrayWithObject:node];
        }
		else
		{
			top[elementName] = node;
		}
		[_stack addObject:node];
	}
}

- (NSString *)nameForNode:(NSDictionary *)node inDictionary:(NSDictionary *)dict
{
	if (node.nodeName)
	{
		return node.nodeName;
	}
	else
	{
		for (NSString *name in dict)
		{
			id object = dict[name];
			if (object == node)
			{
				return name;
			}
			else if ([object isKindOfClass:[NSArray class]] && [object containsObject:node])
			{
				return name;
			}
		}
	}
	return nil;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
	[self endText];
    
    NSMutableDictionary *top = [_stack lastObject];
	if (_collapseTextNodes &&
		!top.attributes && !top.childNodes &&
        !top.comments && top.innerText)
	{
		[_stack removeLastObject];
        NSMutableDictionary *newTop = [_stack lastObject];
		NSString *nodeName = [self nameForNode:top inDictionary:newTop];
		if (nodeName)
		{
			id parentNode = newTop[nodeName];
			if ([parentNode isKindOfClass:[NSArray class]])
			{
				parentNode[[parentNode count] - 1] = top.innerText;
			}
			else
			{
				newTop[nodeName] = top.innerText;
			}
		}
	}
	else
	{
		[_stack removeLastObject];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[self addText:string];
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	[self addText:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
	if (_preserveComments)
	{
        NSMutableDictionary *top = [_stack lastObject];
		NSMutableArray *comments = top[XMLDictionaryCommentsKey];
		if (!comments)
		{
			comments = [@[comment] mutableCopy];
			top[XMLDictionaryCommentsKey] = comments;
		}
		else
		{
			[comments addObject:comment];
		}
	}
}

@end


@implementation NSDictionary(XMLDictionary)

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data
{
	return [[[DynamiXMLParser sharedInstance] copy] dictionaryWithData:data];
}

+ (NSDictionary *)dictionaryWithXMLString:(NSString *)string
{
	return [[[DynamiXMLParser sharedInstance] copy] dictionaryWithString:string];
}

+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)path
{
	return [[[DynamiXMLParser sharedInstance] copy] dictionaryWithFile:path];
}

- (NSDictionary *)attributes
{
	NSDictionary *attributes = self[XMLDictionaryAttributesKey];
	if (attributes)
	{
		return [attributes count]? attributes: nil;
	}
	else
	{
		NSMutableDictionary *filteredDict = [NSMutableDictionary dictionaryWithDictionary:self];
        [filteredDict removeObjectsForKeys:@[XMLDictionaryCommentsKey, XMLDictionaryTextKey, XMLDictionaryNodeNameKey]];
        for (NSString *key in [filteredDict allKeys])
        {
            [filteredDict removeObjectForKey:key];
            if ([key hasPrefix:XMLDictionaryAttributePrefix])
            {
                filteredDict[[key substringFromIndex:[XMLDictionaryAttributePrefix length]]] = self[key];
            }
        }
        return [filteredDict count]? filteredDict: nil;
	}
	return nil;
}

- (NSDictionary *)childNodes
{	
	NSMutableDictionary *filteredDict = [self mutableCopy];
	[filteredDict removeObjectsForKeys:@[XMLDictionaryAttributesKey, XMLDictionaryCommentsKey, XMLDictionaryTextKey, XMLDictionaryNodeNameKey]];
	for (NSString *key in [filteredDict allKeys])
    {
        if ([key hasPrefix:XMLDictionaryAttributePrefix])
        {
            [filteredDict removeObjectForKey:key];
        }
    }
    return [filteredDict count]? filteredDict: nil;
}

- (NSArray *)comments
{
	return self[XMLDictionaryCommentsKey];
}

- (NSString *)nodeName
{
	return self[XMLDictionaryNodeNameKey];
}

- (id)innerText
{	
	id text = self[XMLDictionaryTextKey];
	if ([text isKindOfClass:[NSArray class]])
	{
		return [text componentsJoinedByString:@"\n"];
	}
	else
	{
		return text;
	}
}

- (NSString *)innerXML
{	
	NSMutableArray *nodes = [NSMutableArray array];
	
	for (NSString *comment in [self comments])
	{
        [nodes addObject:[NSString stringWithFormat:@"<!--%@-->", [comment XMLEncodedString]]];
	}
    
    NSDictionary *childNodes = [self childNodes];
	for (NSString *key in childNodes)
	{
		[nodes addObject:[DynamiXMLParser XMLStringForNode:childNodes[key] withNodeName:key]];
	}
	
    NSString *text = [self innerText];
    if (text)
    {
        [nodes addObject:[text XMLEncodedString]];
    }
	
	return [nodes componentsJoinedByString:@"\n"];
}

- (NSString *)XMLString
{	
	return [DynamiXMLParser XMLStringForNode:self withNodeName:[self nodeName] ?: @"root"];
}

@end


@implementation NSString (XMLDictionary)

- (NSString *)XMLEncodedString
{	
	return [[[[[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
               stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
              stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
             stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
            stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"];
}

@end
