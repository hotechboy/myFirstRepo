//
//  DCModifyPinController.m
//  IDKEY
//
//  Created by roger on 15/1/19.
//  Copyright (c) 2015年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCModifyPinController.h"

@interface DCModifyPinController () <DCBluetoothDelegate>
{
    DCBluetooth *_bluetooth;
    NSString *_confirmPass;
}

@property (nonatomic, strong) NSString *confirmPass;

@end

@implementation DCModifyPinController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
    
    self.title = @"修改PIN";
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(modify:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)modify:(id)sender
{
    NSString *oldPass = _oldPasswordTextField.text;
    NSString *confirmPass = _confirmTextField.text;
    self.confirmPass = confirmPass;
    
    if ([oldPass isEqualToString:@""]) {
        [self alert:@"请输入旧密码"];
    }
    else if ([confirmPass isEqualToString:@""]) {
        [self alert:@"请输入新密码"];
    }
    else {
        [self waiting:@"正在验证PIN..."];
        [_bluetooth authPin:oldPass];
    }
}


#pragma mark
#pragma mark DCBluetoothDelegate Methods

- (void)operationDidFinish:(DCBluetooth *)bluetooth operation:(DCBluetoothOperation)operation error:(NSError *)error
{
    if (error) {
        NSLog(@"error: %@", [error description]);
        [self hide];
        return;
    }
    
    // success
    if (operation == DCBluetoothOperationAuthPin) {
        [self waiting:@"正在修改PIN..."];
        [_bluetooth updatePin:_confirmPass];
    }
    else if (operation == DCBluetoothOperationUpdatePin) {
        [self hide];
        [self alert:@"修改PIN成功"];
    }
}

@end
