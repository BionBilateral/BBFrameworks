//
//  BBAuthorizationStatusManager.m
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import "BBAuthorizationStatusManager.h"
#import "BBFoundationFunctions.h"
#import "BBFoundationDebugging.h"

#import <CoreLocation/CoreLocation.h>

@interface BBAuthorizationStatusManager () <CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (assign,nonatomic) BBLocationAuthorizationStatus requestedLocationAuthorizationStatus;
@property (copy,nonatomic) void(^locationCompletionBlock)(BBLocationAuthorizationStatus status,NSError * _Nullable error);
@end

@implementation BBAuthorizationStatusManager

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    BBLogObject(@(status));
    if ((BBLocationAuthorizationStatus)status == BBLocationAuthorizationStatusNotDetermined) {
#if (TARGET_OS_IPHONE)
        if (self.requestedLocationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedWhenInUse) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        else if (self.requestedLocationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedAlways) {
            [self.locationManager requestAlwaysAuthorization];
        }
#else
        if (self.requestedLocationAuthorizationStatus == BBLocationAuthorizationStatusAuthorized) {
            [self.locationManager startUpdatingLocation];
        }
#endif
        else {
            BBDispatchMainSyncSafe(^{
                self.locationCompletionBlock(self.locationAuthorizationStatus,nil);
            });
            
            [self setLocationCompletionBlock:nil];
            [self setLocationManager:nil];
        }
    }
    else {
        BBDispatchMainSyncSafe(^{
            self.locationCompletionBlock(self.locationAuthorizationStatus,nil);
        });
        
        [self setLocationCompletionBlock:nil];
        [self setLocationManager:nil];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    BBLogObject(error);
    BBDispatchMainSyncSafe(^{
        self.locationCompletionBlock(self.locationAuthorizationStatus,error);
    });
    
    [self setLocationCompletionBlock:nil];
    [self setLocationManager:nil];
}

+ (instancetype)sharedManager; {
    static BBAuthorizationStatusManager *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[BBAuthorizationStatusManager alloc] init];
    });
    return kRetval;
}

- (void)requestLocationAuthorization:(BBLocationAuthorizationStatus)authorization completion:(void(^)(BBLocationAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.locationAuthorizationStatus == authorization) {
        BBDispatchMainSyncSafe(^{
            completion(self.locationAuthorizationStatus,nil);
        });
        return;
    }
    
    [self setRequestedLocationAuthorizationStatus:authorization];
    [self setLocationCompletionBlock:completion];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDelegate:self];
}

#if (TARGET_OS_IPHONE)
- (BOOL)hasLocationAuthorizationAlways {
    return [CLLocationManager locationServicesEnabled] && self.locationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedAlways;
}
- (BOOL)hasLocationAuthorizationWhenInUse {
    return [CLLocationManager locationServicesEnabled] && (self.locationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedWhenInUse || self.hasLocationAuthorizationAlways);
}
#else
- (BOOL)hasLocationAuthorization {
    return [CLLocationManager locationServicesEnabled] && self.locationAuthorizationStatus = BBLocationAuthorizationStatusAuthorized;
}
#endif
- (BBLocationAuthorizationStatus)locationAuthorizationStatus {
    return (BBLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
}

@end
