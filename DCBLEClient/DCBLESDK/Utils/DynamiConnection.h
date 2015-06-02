//
//  DynamiConnection.h
//  MobileTokenSDK
//
//  Created by roger on 13-07-23.
//  Copyright (c) 2013年 DynamiCode. All rights reserved.
//

@protocol DynamiConnectionDelegate;

@interface DynamiConnection : NSObject <NSURLConnectionDataDelegate>
{
    NSData *_response;
    SEL _didFinishedSelector;
    SEL _didFailedSelector;
    NSObject <DynamiConnectionDelegate> *_delegate;
}

@property (nonatomic, retain) NSData *response;
@property (nonatomic, assign) SEL didFinishedSelector;
@property (nonatomic, assign) SEL didFailedSelector;
@property (nonatomic, assign) NSObject <DynamiConnectionDelegate> *delegate;

/**
 *	init method
 *
 *	@param	url	- request url
 *
 *	@return	DynamiConnection Instance
 */
+ (DynamiConnection *)connectionWithURL:(NSURL *)url;

- (void)GET;
- (void)POST:(NSData *)data;
- (void)cancel;

@end

@protocol DynamiConnectionDelegate <NSObject>

@optional
- (void)requestFinished:(DynamiConnection *)conn;
- (void)requestFailed:(DynamiConnection *)conn;

@end