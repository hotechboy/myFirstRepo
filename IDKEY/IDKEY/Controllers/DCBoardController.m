//
//  DCBoardController.m
//  IDKEY
//
//  Created by roger on 14/12/17.
//  Copyright (c) 2014年 DynamiCode. All rights reserved.
//

#import "DCBoardController.h"
#import "DCDeviceManagerController.h"
#import "AppDelegate.h"

@interface DCBoardController ()

@end

@implementation DCBoardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_manageBtn setBackgroundImage:[DCBoardController imageWithColor:DCColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    [_manageBtn setBackgroundImage:[DCBoardController imageWithColor:DCColorFromRGB(0xf0f0f0)] forState:UIControlStateHighlighted];
    
    [_emergencyBtn setBackgroundImage:[DCBoardController imageWithColor:DCColorFromRGB(0xffffff)] forState:UIControlStateNormal];
    [_emergencyBtn setBackgroundImage:[DCBoardController imageWithColor:DCColorFromRGB(0xf0f0f0)] forState:UIControlStateHighlighted];
}

- (IBAction)onManageClick:(id)sender
{
    AppDelegate * app = [[UIApplication sharedApplication]delegate];
    DDMenuController *menu = app.menuController;
    if (menu && menu.rootViewController != app.deviceManagerController ) {
        DCDeviceManagerController *deviceController = [[DCDeviceManagerController alloc] initWithNibName:@"DCDeviceManagerController" bundle:nil];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:deviceController];
        app.deviceManagerController = navigationController;
        [menu setRootController:app.deviceManagerController animated:YES];
    }else {
        [menu showRootController:YES];
    }
}

- (IBAction)onEmergencyClick:(id)sender
{
    //TODO:emergency controller under construction
    AppDelegate * app = [[UIApplication sharedApplication]delegate];
    DDMenuController *menu = app.menuController;
    [menu showRootController:YES];
}

@end
