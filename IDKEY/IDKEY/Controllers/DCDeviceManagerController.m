//
//  DCDeviceManagerController.m
//  IDKEY
//
//  Created by roger on 14/12/17.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCDeviceManagerController.h"
#import "MainViewController.h"
#import "DCScanController.h"
#import "DCModifyPinController.h"
#import "AppDelegate.h"

@interface DCDeviceManagerController ()
{
    DCBluetooth *_bluetooth;
}
@end

@implementation DCDeviceManagerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bluetooth = [[DCBluetooth alloc] init];
    
    _nameLabel.text = _peripheral.name;
    _uuidLabel.text = _peripheral.uuid;
    
    [_bindBtn setBackgroundImage:[DCBaseController imageWithColor:kDCSelectedColor] forState:UIControlStateHighlighted];
    [_unbindBtn setBackgroundImage:[DCBaseController imageWithColor:kDCSelectedColor] forState:UIControlStateHighlighted];
    [_modifyPINBtn setBackgroundImage:[DCBaseController imageWithColor:kDCSelectedColor] forState:UIControlStateHighlighted];
    [_addDeviceBtn setBackgroundImage:[DCBaseController imageWithColor:kDCSelectedColor] forState:UIControlStateHighlighted];
    [_updateBtn setBackgroundImage:[DCBaseController imageWithColor:kDCSelectedColor] forState:UIControlStateHighlighted];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-icon-menu"] style:UIBarButtonItemStylePlain target:self action:@selector(menu:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self blockDDMenu:NO];
    
    if ([_bluetooth currentPeripheral]) {
        DCPeripheral *peripheral = [_bluetooth currentPeripheral];
        _nameLabel.text = peripheral.name;
        _uuidLabel.text = peripheral.uuid;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self blockDDMenu:YES];
}

- (void)menu:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.menuController showLeftController:YES];
}

- (void)showScanController
{
    DCScanController *controller = [[DCScanController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)onAddDevice:(id)sender
{
    if ([_bluetooth isConnected]) {
        
    }
    else {
        
    }
    [self showScanController];
}



- (IBAction)onBindClick:(id)sender
{
    if ([_bluetooth isConnected]) {
        
    }
    else {
        [self showScanController];
    }
}

- (IBAction)onUnbindClick:(id)sender
{
    if ([_bluetooth isConnected]) {
        
    }
    else {
        [self showScanController];
    }
}

- (IBAction)onModifyPinClick:(id)sender
{
    if ([_bluetooth isConnected]) {
        DCModifyPinController *controller = [[DCModifyPinController alloc] initWithNibName:@"DCModifyPinController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [self showScanController];
    }
}

- (IBAction)onUpdate:(id)sender
{
    if ([_bluetooth isConnected]) {
        [_bluetooth disconnect];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [self.navigationController pushViewController:delegate.otaController animated:YES];
}
@end
