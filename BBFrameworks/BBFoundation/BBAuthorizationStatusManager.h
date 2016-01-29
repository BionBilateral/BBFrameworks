//
//  BBAuthorizationStatusManager.h
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int, BBLocationAuthorizationStatus) {
    BBLocationAuthorizationStatusNotDetermined = kCLAuthorizationStatusNotDetermined,
    BBLocationAuthorizationStatusRestricted = kCLAuthorizationStatusRestricted,
    BBLocationAuthorizationStatusDenied = kCLAuthorizationStatusDenied,
#if (TARGET_OS_IPHONE)
    BBLocationAuthorizationStatusAuthorizedAlways = kCLAuthorizationStatusAuthorizedAlways,
    BBLocationAuthorizationStatusAuthorizedWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse
#else
    BBLocationAuthorizationStatusAuthorized = kCLAuthorizationStatusAuthorized
#endif
};

@interface BBAuthorizationStatusManager : NSObject

#if (TARGET_OS_IPHONE)
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#else
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
#endif
@property (readonly,nonatomic) BBLocationAuthorizationStatus locationAuthorizationStatus;

+ (instancetype)sharedManager;

- (void)requestLocationAuthorization:(BBLocationAuthorizationStatus)authorization completion:(void(^)(BBLocationAuthorizationStatus status, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
