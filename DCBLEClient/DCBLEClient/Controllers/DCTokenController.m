//
//  DCTokenController.m
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCTokenController.h"

@interface DCTokenController () <DCBluetoothDelegate>
{
    DCBluetooth *_bluetooth;
}
@end

@implementation DCTokenController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear:)];
    self.navigationItem.rightBarButtonItem = clear;

    self.title = @"令牌功能";
}

- (void)clear:(id)sender
{
    _logTextView.text = @"";
}

- (IBAction)getTokenCode:(id)sender
{
    [_bluetooth getTokenCode];
}

- (IBAction)getTokenSN:(id)sender
{
    [_bluetooth getTokenSN];
}

- (IBAction)syncServerTime:(id)sender
{
    [self waiting:@"正在同步服务器时间..."];
    [_bluetooth syncServerTime];
}

#pragma mark
#pragma mark - DCBluetoothDelegate Methods

- (void)operationDidFinish:(DCBluetooth *)bluetooth operation:(DCBluetoothOperation)operation error:(NSError *)error
{
    if (operation == DCBluetoothOperationSyncServerTime) {
        [self hide];
    }
    if (error) {
        NSLog(@"operationDidFinished with error: %@", [error description]);
        NSString *desc = error.userInfo[NSLocalizedDescriptionKey];
        [self alert:desc];
        return;
    }
    
    if (operation == DCBluetoothOperationGetTokenCode) {
        NSLog(@"DCBluetoothOperationGetTokenCode success");
        NSString *text = _logTextView.text;
        _logTextView.text = [text stringByAppendingFormat:@"令牌动态码: %@\n", _bluetooth.tokenCode];
    }
    else if (operation == DCBluetoothOperationGetTokenSN) {
        NSLog(@"DCBluetoothOperationGetTokenSN success");
        NSString *text = _logTextView.text;
        _logTextView.text = [text stringByAppendingFormat:@"令牌序列号: %@\n", _bluetooth.tokenSN];
        
    }
    else if (operation == DCBluetoothOperationSyncServerTime) {
        
        NSLog(@"DCBluetoothOperationSyncServerTime success");
        NSString *text = _logTextView.text;
        _logTextView.text = [text stringByAppendingString:@"同步服务器时间成功~\n"];
    }
}

@end
