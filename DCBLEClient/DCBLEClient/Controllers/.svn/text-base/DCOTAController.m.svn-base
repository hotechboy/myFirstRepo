//
//  DCOTAController.m
//  DCBLEClient
//
//  Created by roger on 14/12/16.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBluetooth.h"
#import "DCOTAController.h"

@interface DCOTAController () <DCBluetoothDelegate>
{
    DCBluetooth *_bluetooth;
    int _length;
}
@end

@implementation DCOTAController

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bluetooth = [[DCBluetooth alloc] init];
    _bluetooth.delegate = self;
    
    [_updateBtn setBackgroundImage:[DCOTAController imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    //[_bluetooth resume];
}


- (IBAction)onUpdateClick:(id)sender
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ota" ofType:@"bin"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _length = data.length;
    if (_length > 0) {
        
        //[_bluetooth update:path];
    }
    else {
        [self alert:@"固件不可用！"];
    }
}


#pragma mark
#pragma mark DCBluetoothDelegate 

- (void)bluetooth:(DCBluetooth *)bluetooth updateDataSent:(int)length result:(DCBluetoothUpdateResult)result
{
 
    float progress = length * 100.0f / _length;
    if (progress > 100.0f) {
        progress = 100.0f;
    }
    [_progressView setProgress:progress/100.0f];
}

- (void)bluetooth:(DCBluetooth *)bluetooth updateResult:(DCBluetoothUpdateResult)result
{
    NSLog(@"bluetooth updateResult: %d", result);
    if (result == DCBluetoothUpdateResultSuccess) {
        [self alert:@"固件更新成功！"];
    }
}

@end
