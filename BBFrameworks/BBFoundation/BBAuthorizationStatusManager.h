//
//  BBAuthorizationStatusManager.h
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <TargetConditionals.h>

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocationManager.h>
#import <EventKit/EKTypes.h>
#if (TARGET_OS_IPHONE)
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVAudioSession.h>
#import <AddressBook/ABAddressBook.h>
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

typedef NS_ENUM(NSInteger, BBCalendarAuthorizationStatus) {
    BBCalendarAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    BBCalendarAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    BBCalendarAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    BBCalendarAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};

typedef NS_ENUM(NSInteger, BBReminderAuthorizationStatus) {
    BBReminderAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    BBReminderAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    BBReminderAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    BBReminderAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};

#if (TARGET_OS_IPHONE)
typedef NS_ENUM(NSInteger, BBPhotoLibraryAuthorizationStatus) {
    BBPhotoLibraryAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    BBPhotoLibraryAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    BBPhotoLibraryAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    BBPhotoLibraryAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};

typedef NS_ENUM(NSInteger, BBCameraAuthorizationStatus) {
    BBCameraAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    BBCameraAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    BBCameraAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    BBCameraAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};

typedef NS_ENUM(CFIndex, BBAddressBookAuthorizationStatus) {
    BBAddressBookAuthorizationStatusNotDetermined = kABAuthorizationStatusNotDetermined,
    BBAddressBookAuthorizationStatusRestricted = kABAuthorizationStatusRestricted,
    BBAddressBookAuthorizationStatusDenied = kABAuthorizationStatusDenied,
    BBAddressBookAuthorizationStatusAuthorized = kABAuthorizationStatusAuthorized
};

typedef NS_OPTIONS(NSUInteger, BBMicrophoneAuthorizationStatus) {
    BBMicrophoneAuthorizationStatusNotDetermined = AVAudioSessionRecordPermissionUndetermined,
    BBMicrophoneAuthorizationStatusDenied = AVAudioSessionRecordPermissionDenied,
    BBMicrophoneAuthorizationStatusAuthorized = AVAudioSessionRecordPermissionGranted
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

@property (readonly,nonatomic) BOOL hasCalendarAuthorization;
@property (readonly,nonatomic) BBCalendarAuthorizationStatus calendarAuthorizationStatus;

@property (readonly,nonatomic) BOOL hasReminderAuthorization;
@property (readonly,nonatomic) BBReminderAuthorizationStatus reminderAuthorizationStatus;

#if (TARGET_OS_IPHONE)
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
@property (readonly,nonatomic) BBPhotoLibraryAuthorizationStatus photoLibraryAuthorizationStatus;

@property (readonly,nonatomic) BOOL hasCameraAuthorization;
@property (readonly,nonatomic) BBCameraAuthorizationStatus cameraAuthorizationStatus;

@property (readonly,nonatomic) BOOL hasAddressBookAuthorization;
@property (readonly,nonatomic) BBAddressBookAuthorizationStatus addressBookAuthorizationStatus;

@property (readonly,nonatomic) BOOL hasMicrophoneAuthorization;
@property (readonly,nonatomic) BBMicrophoneAuthorizationStatus microphoneAuthorizationStatus;
#endif

+ (instancetype)sharedManager;

- (void)requestLocationAuthorization:(BBLocationAuthorizationStatus)authorization completion:(void(^)(BBLocationAuthorizationStatus status, NSError * _Nullable error))completion;
- (void)requestCalendarAuthorizationWithCompletion:(void(^)(BBCalendarAuthorizationStatus status, NSError * _Nullable error))completion;
- (void)requestReminderAuthorizationWithCompletion:(void(^)(BBReminderAuthorizationStatus status, NSError * _Nullable error))completion;
#if (TARGET_OS_IPHONE)
- (void)requestPhotoLibraryAuthorizationWithCompletion:(void(^)(BBPhotoLibraryAuthorizationStatus status, NSError * _Nullable error))completion;
- (void)requestCameraAuthorizationWithCompletion:(void(^)(BBCameraAuthorizationStatus status, NSError * _Nullable error))completion;
- (void)requestAddressBookAuthorizationWithCompletion:(void(^)(BBAddressBookAuthorizationStatus status, NSError * _Nullable error))completion;
- (void)requestMicrophoneAuthorizationWithCompletion:(void(^)(BBMicrophoneAuthorizationStatus status, NSError * _Nullable error))completion;
#endif

@end

NS_ASSUME_NONNULL_END
