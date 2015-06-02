//
//  DCOTAController.h
//  DCBLEClient
//
//  Created by roger on 14/12/16.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseController.h"

@interface DCOTAController : DCBaseController

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

- (IBAction)onUpdateClick:(id)sender;

@end
