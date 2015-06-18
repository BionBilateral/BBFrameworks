//
//  BaseRowViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/18/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import "BaseRowViewController.h"

@interface BaseRowViewController ()

@end

@implementation BaseRowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setLeftBarButtonItems:@[self.splitViewController.displayModeButtonItem]];
    [self.navigationItem setLeftItemsSupplementBackButton:YES];
}

@end
