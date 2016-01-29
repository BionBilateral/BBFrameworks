//
//  AuthorizationStatusViewController.m
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import "AuthorizationStatusViewController.h"
#import <BBFrameworks/BBFoundation.h>
#import <BBFrameworks/BBAuthorizationStatus.h>

@interface AuthorizationStatusViewController ()
- (IBAction)_locationButtonAction:(id)sender;
@end

@implementation AuthorizationStatusViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

+ (NSString *)rowClassTitle {
    return @"Authorization";
}

- (IBAction)_locationButtonAction:(id)sender; {
    [[BBAuthorizationStatusManager sharedManager] requestLocationAuthorization:BBLocationAuthorizationStatusAuthorizedWhenInUse completion:^(BBLocationAuthorizationStatus status, NSError * _Nullable error) {
        BBLog(@"%@ %@",@(status),error);
    }];
}

@end
