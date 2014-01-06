//
//  RootViewController.m
//  NSToolsSDK
//
//  Created by Nemo on 14-1-4.
//  Copyright (c) 2014年 Nemo. All rights reserved.
//

#import "RootViewController.h"
#import "RootView.h"

@interface RootViewController ()
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[RootView alloc] init];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
