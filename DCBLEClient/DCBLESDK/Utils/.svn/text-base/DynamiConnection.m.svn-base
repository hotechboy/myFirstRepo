//
//  DynamiConnection.m
//  MobileTokenSDK
//
//  Created by roger on 13-07-23.
//  Copyright (c) 2013年 DynamiCode. All rights reserved.
//

#import "DynamiConnection.h"

@interface DynamiConnection ()
{
    NSMutableData *_receivedData;
    NSURLConnection *_connection;
    NSURL *_url;
}
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURLConnection *connection;

@end

@implementation DynamiConnection
@synthesize didFinishedSelector = _didFinishedSelector;
@synthesize didFailedSelector = _didFailedSelector;
@synthesize url = _url;
@synthesize connection = _connection;
@synthesize delegate = _delegate;



- (void)dealloc
{
    [_connection release], _connection = nil;
    [_receivedData release], _receivedData = nil;    
    [_url release], _url = nil;
    _delegate = nil;
    _didFinishedSelector = nil;
    _didFailedSelector = nil;
    
    [super dealloc];
}


/**
 *  cheat the llvm
 *
 */

- (void)requestFinished:(DynamiConnection *)conn
{}

- (void)requestFailed:(DynamiConnection *)conn
{}


- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _delegate = nil;
        _receivedData = nil;
        _connection = nil;
        self.url = url;
        [self setDidFinishedSelector:@selector(requestFinished:)];
        [self setDidFailedSelector:@selector(requestFailed:)];
    }
    
    return self;
}


+ (DynamiConnection *)connectionWithURL:(NSURL *)url
{
    return [[[self alloc] initWithURL:url] autorelease];
}

#pragma mark -
#pragma mark Certificate Utils

OSStatus extractIdentityAndTrust(CFDataRef inP12data, SecIdentityRef *identity, SecTrustRef *trust)
{
    OSStatus securityError = errSecSuccess;
    
    CFStringRef password = CFSTR("123456");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import(inP12data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex(items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemIdentity);
        *identity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue(myIdentityAndTrust, kSecImportItemTrust);
        *trust = (SecTrustRef)tempTrust;
    }
    
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}

- (NSURLCredential *)loadCertificate
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
    NSData *p12data = [NSData dataWithContentsOfFile:path];
    CFDataRef inP12data = (CFDataRef)p12data;
    
    SecIdentityRef identity = nil;
    SecTrustRef trust;
    extractIdentityAndTrust(inP12data, &identity, &trust);
    
    SecCertificateRef certificate;
    if (identity) {
        SecIdentityCopyCertificate(identity, &certificate);
        const void *certs[] = { certificate };
        CFArrayRef certsArray = CFArrayCreate(NULL, certs, 1, NULL);
        
        NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(NSArray *)certsArray persistence:NSURLCredentialPersistenceNone];
        CFRelease(certsArray);
        return credential;
    }
    
    return nil;
}

- (BOOL)shouldTrustProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    // Load up the bundled certificate.
    NSString *certPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"der"];
    NSData *certData = [[NSData alloc] initWithContentsOfFile:certPath];
    CFDataRef certDataRef = (CFDataRef)certData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
    
    // Establish a chain of trust anchored on our bundled certificate.
    CFArrayRef certArrayRef = CFArrayCreate(NULL, (void *)&cert, 1, NULL);
    SecTrustRef serverTrust = protectionSpace.serverTrust;
    SecTrustSetAnchorCertificates(serverTrust, certArrayRef);
    
    // Verify that trust.
    SecTrustResultType trustResult;
    SecTrustEvaluate(serverTrust, &trustResult);
    
    // Clean up.
    CFRelease(certArrayRef);
    CFRelease(cert);
    CFRelease(certDataRef);
    
    // Did our custom trust chain evaluate successfully?
    return trustResult == kSecTrustResultUnspecified;
}


#pragma mark -
#pragma mark HTTP Methods

- (void)GET
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
}

- (void)POST:(NSData *)data
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_url];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [request release];
}


- (void)cancel
{
    _delegate = nil;
    if (_connection) {
        [_connection cancel];
        [_connection release], _connection = nil;
    }
    [_receivedData release], _receivedData = nil;
}


#pragma mark- 
#pragma mark NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:_didFailedSelector]) {
        [_delegate performSelector:_didFailedSelector withObject:self];
    }
    
    self.connection = nil;
    [_receivedData release], _receivedData = nil;
}


#pragma mark - 
#pragma mark NSURLConnectionDataDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc] initWithData:data];
    }
    else {
        [_receivedData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{        
    if (_delegate && [_delegate respondsToSelector:_didFinishedSelector]) {
        self.response = _receivedData;
        [_delegate performSelector:_didFinishedSelector withObject:self];
    }
    
    self.connection = nil;
    [_receivedData release], _receivedData = nil;
    self.response = nil;
}



- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
       [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    else {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
    
}

@end
