//
//  DCBoardController.h
//  IDKEY
//
//  Created by roger on 14/12/17.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseController.h"

@interface DCBoardController : DCBaseController

@property (weak, nonatomic) IBOutlet UIButton *manageBtn;
@property (weak, nonatomic) IBOutlet UIButton *emergencyBtn;


- (IBAction)onManageClick:(id)sender;
- (IBAction)onEmergencyClick:(id)sender;

@end
