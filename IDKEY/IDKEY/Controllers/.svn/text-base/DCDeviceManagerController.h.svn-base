//
//  DCDeviceManagerController.h
//  IDKEY
//
//  Created by roger on 14/12/17.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCPeripheral.h"
#import "DCBaseController.h"

@interface DCDeviceManagerController : DCBaseController
{
    DCPeripheral *_peripheral;
}

@property (nonatomic, strong) DCPeripheral *peripheral;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *uuidLabel;

@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *unbindBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyPINBtn;

@property (weak, nonatomic) IBOutlet UIButton *addDeviceBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;


- (IBAction)onAddDevice:(id)sender;
- (IBAction)onBindClick:(id)sender;
- (IBAction)onUnbindClick:(id)sender;
- (IBAction)onModifyPinClick:(id)sender;
- (IBAction)onUpdate:(id)sender;


@end
