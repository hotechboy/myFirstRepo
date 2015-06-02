//
//  DCOperationsController.m
//  DCBLEClient
//
//  Created by roger on 14/11/7.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCOperationsController.h"
#import "DCTokenController.h"
#import "DCKeyClickController.h"
#import "DCOTAController.h"

// Operation Tags for Alert
#define kDCOperationAuthPin     1001
#define kDCOperationUpdatePin   1002
#define kDCOperationBind        1003
#define kDCOperationUnbind      1004

@interface DCOperationsController () <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, DCBluetoothDelegate>
{
    NSArray *_operations;
    DCBluetooth *_bluetooth;
}

@property (nonatomic, strong) NSArray *operations;

@end

@implementation DCOperationsController

- (void)dealloc
{
    [_bluetooth disconnect];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *operations = @[ @"令牌功能",
                             @"验证PIN",
                             @"修改PIN",
                             @"绑定设备",
                             @"解绑设备",
                             @"智能按键",
                             @"开启蜂鸣",
                             @"解除蜂鸣",
                             @"重置设备"
                            ];
    self.operations = operations;
    
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark

- (void)input:(NSString *)title msg:(NSString *)msg tag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = tag;
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
}


#pragma mark
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _operations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"DCOperationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *text = _operations[indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        // 令牌功能
        DCTokenController *controller = [[DCTokenController alloc] initWithNibName:@"DCTokenController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (row == 1) {
        // 验证PIN
        [self input:@"验证PIN" msg:@"请输入PIN" tag:kDCOperationAuthPin];
    }
    else if (row == 2) {
        // 修改PIN
        [self input:@"修改PIN" msg:@"请输入PIN" tag:kDCOperationUpdatePin];
    }
    else if (row == 3) {
        // 绑定设备
        [self input:@"绑定设备" msg:@"请输入PIN" tag:kDCOperationBind];
        
    }
    else if (row == 4) {
        // 解绑设备
        [self input:@"解绑设备" msg:@"请输入PIN" tag:kDCOperationUnbind];
    }
    else if (row == 5) {
        // 智能按键
        DCKeyClickController *controller = [[DCKeyClickController alloc] initWithNibName:@"DCKeyClickController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (row == 6) {
        // 开启蜂鸣
        [_bluetooth buzz];
        NSLog(@"开启蜂鸣");
    }
    else if (row == 7) {
        // 解除蜂鸣
        [_bluetooth silent];
        NSLog(@"解除蜂鸣");
    }
    else if (row == 8) {
        // 重置设备
        [_bluetooth reset];
        NSLog(@"重置设备");
    }
}

#pragma mark
#pragma mark UIAlertViewDelegate Methods

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    [textField becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if (buttonIndex == 1) {
    
        NSInteger tag = alertView.tag;
        NSString *pin = textField.text;
        
        if (tag == kDCOperationAuthPin) {
            [_bluetooth authPin:pin];
        }
        else if (tag == kDCOperationUpdatePin) {
            [_bluetooth updatePin:pin];
            [self waiting:@"请按下蓝牙外设上的按钮确认修改PIN"];
        }
        else if (tag == kDCOperationBind) {
            [_bluetooth bind:pin];
            [self waiting:@"请按下蓝牙外设上的按钮确认绑定设备"];
        }
        else if (tag == kDCOperationUnbind) {
            [_bluetooth unbind:pin];
        }
    }
    [textField resignFirstResponder];
}


#pragma mark
#pragma mark DCBluetoothDelegate Methods

- (void)operationDidFinish:(DCBluetooth *)bluetooth operation:(DCBluetoothOperation)operation error:(NSError *)error
{
    
    if (operation == DCBluetoothOperationUpdatePin || operation == DCBluetoothOperationBind)
    {
        [self hide];
    }
    
    if (error) {
        NSLog(@"operationDidFinished with error: %@", [error description]);
        NSString *desc = error.userInfo[NSLocalizedDescriptionKey];
        [self alert:desc];
        return;
    }
    if (operation == DCBluetoothOperationAuthPin) {
        NSLog(@"DCBluetoothOperationAuthPin success");
        [self alert:@"验证PIN成功"];
    }
    else if (operation == DCBluetoothOperationUpdatePin) {
        NSLog(@"DCBluetoothOperationUpdatePin success");
        [self alert:@"修改PIN成功"];
    }
    else if (operation == DCBluetoothOperationBind) {
        NSLog(@"DCBluetoothOperationBind success");
        [self alert:@"手机与外设绑定成功"];
    }
    else if (operation == DCBluetoothOperationUnbind) {
        NSLog(@"DCBluetoothOperationUnbind success");
        [self alert:@"手机与外设解除绑定成功"];
    }
    else if (operation == DCBluetoothOperationReset) {
        NSLog(@"DCBluetoothOperationReset success");
        [self alert:@"重置设备成功！"];
    }
        
}

@end
