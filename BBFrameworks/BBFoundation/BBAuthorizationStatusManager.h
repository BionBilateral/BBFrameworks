//
//  BBAuthorizationStatusManager.h
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#if (TARGET_OS_IPHONE)
#import <Photos/PHPhotoLibrary.h>
#endif

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

#if (TARGET_OS_IPHONE)
typedef NS_ENUM(NSInteger, BBPhotoLibraryAuthorizationStatus) {
    BBPhotoLibraryAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    BBPhotoLibraryAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    BBPhotoLibraryAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    BBPhotoLibraryAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};
#endif

@interface BBAuthorizationStatusManager : NSObject

#if (TARGET_OS_IPHONE)
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#else
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
#endif
@property (readonly,nonatomic) BBLocationAuthorizationStatus locationAuthorizationStatus;

#if (TARGET_OS_IPHONE)
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
@property (readonly,nonatomic) BBPhotoLibraryAuthorizationStatus photoLibraryAuthorizationStatus;
#endif

+ (instancetype)sharedManager;

- (void)requestLocationAuthorization:(BBLocationAuthorizationStatus)authorization completion:(void(^)(BBLocationAuthorizationStatus status, NSError * _Nullable error))completion;
#if (TARGET_OS_IPHONE)
- (void)requestPhotoLibraryAuthorizationWithCompletion:(void(^)(BBPhotoLibraryAuthorizationStatus status, NSError * _Nullable error))completion;
#endif

@end

NS_ASSUME_NONNULL_END
