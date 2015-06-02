//
//  DCScanController.m
//  DCBLEClient
//
//  Created by roger on 14/10/30.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "AppDelegate.h"
#import "DCBluetooth.h"
#import "EGORefreshTableHeaderView.h"
#import "DCDeviceManagerController.h"
#import "DCScanController.h"

#define kDCScanTimeout 5.0f

@interface DCScanController () <UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, DCBluetoothDelegate>
{
    UITableView *_table;
    EGORefreshTableHeaderView *_headerView;
    BOOL _reloading;
    DCBluetooth *_bluetooth;
    NSTimer *_timer;
    UIBarButtonItem *_disConnBarItem;
}

@property (nonatomic, strong) DCBluetooth *bluetooth;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIBarButtonItem *disConnBarItem;

@end

@implementation DCScanController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // DCBLEAPI Stuff
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
    
    // layout
    self.title = @"设备管理";
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds];
    _table = table;
    _table.delegate = self;
    _table.dataSource = self;
    _table.scrollsToTop = YES;
    _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_table setAllowsSelection:YES];
    [self.view addSubview:table];
    
    EGORefreshTableHeaderView *header = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, - CGRectGetHeight(_table.frame), CGRectGetWidth(_table.frame), CGRectGetHeight(_table.frame))];
    header.delegate = self;
    _headerView = header;
    [_table addSubview:header];
    
    
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"断开" style:UIBarButtonItemStylePlain target:self action:@selector(disconnect:)];
    self.disConnBarItem = rightBarItem;
   
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem setEnabled:NO];
    [self load];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _table.frame = self.view.bounds;
    
    if ([_bluetooth isConnected]) {
        [_disConnBarItem setEnabled:YES];
    }
    else {
        [_disConnBarItem setEnabled:NO];
    }
}

- (void)disconnect:(id)sender
{
    [_bluetooth disconnect];
}

- (void)test:(id)sender
{
    [_bluetooth bind:@"234562"];
}

- (void)buzz:(id)sender
{
    [_bluetooth buzz];
}

- (void)silent:(id)sender
{
    [_bluetooth silent];
}

- (void)load
{
    [_headerView pullTheTrigle:_table];
}

- (void)startTimer
{
    [self cancelTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kDCScanTimeout target:self selector:@selector(timeout:) userInfo:nil repeats:NO];
}

- (void)cancelTimer
{
    if (_timer) {
        [_timer invalidate];
        self.timer = nil;
    }
}

- (void)timeout:(NSTimer *)timer
{
    [_bluetooth stopScan];
    [self doneReloadingData];
    [_table reloadData];
    [self cancelTimer];
}

#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_headerView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark -
#pragma mark  Reloading Methods

- (void)reloadData
{
    _reloading = YES;
    [_bluetooth scan];
    [self startTimer];
}

- (void)doneReloadingData
{
    _reloading = NO;
    [_headerView egoRefreshScrollViewDataSourceDidFinishedLoading:_table];
}

#pragma mark -
#pragma egoRefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

#pragma mark
#pragma mark - UITableViewDataSource and UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *peripherals = [_bluetooth peripherals];
    return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"DCPeripheralCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *peripherals = [_bluetooth peripherals];
    DCPeripheral *peripheral = peripherals[indexPath.row];
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = peripheral.uuid;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *peripherals = [_bluetooth peripherals];
    DCPeripheral *peripheral = peripherals[indexPath.row];
    DCPeripheral *currentPeripheral = [_bluetooth currentPeripheral];
    if ([currentPeripheral.uuid isEqualToString:peripheral.uuid]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([_bluetooth isConnected]) {
        [self alert:@"蓝牙已连接，请先断开连接"];
        return;
    }
    
    [self waiting:@"正在连接..."];
    [_bluetooth connect:peripheral];
   
}

#pragma mark
#pragma mark Handle DCBLEAPI Notifications

- (void)bluetoothStateDidChange:(DCBluetooth *)bluetooth
{
    DCBluetoothState state = bluetooth.state;
    switch (state) {
        case DCBluetoothStatePoweredOn:
            NSLog(@"DCBluetoothStatePoweredOn");
            break;
        case DCBluetoothStatePoweredOff:
            NSLog(@"DCBluetoothStatePoweredOff");
            break;
        case DCBluetoothStateUnsupported:
            NSLog(@"DCBluetoothStateUnsupported");
            break;
        default:
            break;
    }
}

- (void)peripheralCountDidChange:(DCBluetooth *)bluetooth
{
    [_table reloadData];
}

- (void)bluetoothDidConnect:(DCBluetooth *)bluetooth
{
    [self hide];
    [self.navigationController popViewControllerAnimated:YES];
    [_disConnBarItem setEnabled:YES];
}

- (void)bluetoothDidFailToConnect:(DCBluetooth *)bluetooth
{
    [self hide];
    [self alert:@"连接蓝牙外设失败！"];
    [_disConnBarItem setEnabled:NO];
}

- (void)bluetoothDisconnect:(DCBluetooth *)bluetooth
{
    NSLog(@"蓝牙连接断开");
    [_disConnBarItem setEnabled:NO];
}

- (void)bluetooth:(DCBluetooth *)bluetooth shortClick:(int)shortClick longClick:(int)longClick
{
    NSLog(@"短按键次数: %d, 长按键次数: %d", shortClick, longClick);
}

@end
