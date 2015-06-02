//
//  DCKeyClickController.m
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCKeyClickController.h"

@interface DCKeyClickController () <DCBluetoothDelegate>
{
    DCBluetooth *_bluetooth;
}
@end

@implementation DCKeyClickController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
    
    UIBarButtonItem *clear = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clear:)];
    self.navigationItem.rightBarButtonItem = clear;
    
    self.title = @"智能按键";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clear:(id)sender
{
    _logTextView.text = @"";
}

#pragma mark
#pragma mark DCBluetoothDelegate

- (void)bluetooth:(DCBluetooth *)bluetooth shortClick:(int)shortClick longClick:(int)longClick
{
    NSString *text = _logTextView.text;
    _logTextView.text = [text stringByAppendingFormat:@"短按键次数: %d, 长按键次数: %d\n", shortClick, longClick];
}

@end
