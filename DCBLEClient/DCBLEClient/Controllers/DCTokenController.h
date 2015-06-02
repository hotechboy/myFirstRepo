//
//  DCTokenController.h
//  DCBLEClient
//
//  Created by roger on 14/11/11.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBaseController.h"

@interface DCTokenController : DCBaseController

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

- (IBAction)getTokenCode:(id)sender;
- (IBAction)getTokenSN:(id)sender;
- (IBAction)syncServerTime:(id)sender;

@end
