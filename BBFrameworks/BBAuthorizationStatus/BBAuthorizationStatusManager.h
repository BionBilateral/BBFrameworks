//
//  BBAuthorizationStatusManager.h
//  BBFrameworks
//
//  Created by William Towe on 1/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

/**
 Enum describing the location authorization status.
 */
typedef NS_ENUM(int, BBLocationAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestLocationAuthorization:completion: to present the appropriate system alert to the user.
     */
    BBLocationAuthorizationStatusNotDetermined = kCLAuthorizationStatusNotDetermined,
    /**
     The status is restricted and cannot be changed by the user.
     */
    BBLocationAuthorizationStatusRestricted = kCLAuthorizationStatusRestricted,
    /**
     The status has been denied by the user.
     */
    BBLocationAuthorizationStatusDenied = kCLAuthorizationStatusDenied,
#if (TARGET_OS_IPHONE)
    /**
     The client has been authorized to access location regardless of application state.
     */
    BBLocationAuthorizationStatusAuthorizedAlways = kCLAuthorizationStatusAuthorizedAlways,
    /**
     The client has been authorized to access location when the application is active.
     */
    BBLocationAuthorizationStatusAuthorizedWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse
#else
    /**
     The client has been authorized to access location.
     */
    BBLocationAuthorizationStatusAuthorized = kCLAuthorizationStatusAuthorized
#endif
};

/**
 Enum describing the calendar authorization status.
 */
typedef NS_ENUM(NSInteger, BBCalendarAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestCalendarAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBCalendarAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and cannot be changed by the user.
     */
    BBCalendarAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     The status has been denied by the user.
     */
    BBCalendarAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     The client has been authorized to access calendars.
     */
    BBCalendarAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};

/**
 Enum describing the reminder authorization status.
 */
typedef NS_ENUM(NSInteger, BBReminderAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestReminderAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBReminderAuthorizationStatusNotDetermined = EKAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and cannot be changed by the user.
     */
    BBReminderAuthorizationStatusRestricted = EKAuthorizationStatusRestricted,
    /**
     The status has been denied.
     */
    BBReminderAuthorizationStatusDenied = EKAuthorizationStatusDenied,
    /**
     The client has been authorizd to access reminders.
     */
    BBReminderAuthorizationStatusAuthorized = EKAuthorizationStatusAuthorized
};

#if (TARGET_OS_IPHONE)
/**
 Enum describing the photo library authorization status.
 */
typedef NS_ENUM(NSInteger, BBPhotoLibraryAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestPhotoLibraryAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBPhotoLibraryAuthorizationStatusNotDetermined = PHAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and cannot be changed by the user.
     */
    BBPhotoLibraryAuthorizationStatusRestricted = PHAuthorizationStatusRestricted,
    /**
     The status has been denied by the user.
     */
    BBPhotoLibraryAuthorizationStatusDenied = PHAuthorizationStatusDenied,
    /**
     The client has been authorized to access the photo library.
     */
    BBPhotoLibraryAuthorizationStatusAuthorized = PHAuthorizationStatusAuthorized
};

/**
 Enum describing the camera authorization status.
 */
typedef NS_ENUM(NSInteger, BBCameraAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestCameraAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBCameraAuthorizationStatusNotDetermined = AVAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and cannot be changed by the user.
     */
    BBCameraAuthorizationStatusRestricted = AVAuthorizationStatusRestricted,
    /**
     The status has been denied by the user.
     */
    BBCameraAuthorizationStatusDenied = AVAuthorizationStatusDenied,
    /**
     The client has been authorized to access the camera.
     */
    BBCameraAuthorizationStatusAuthorized = AVAuthorizationStatusAuthorized
};

/**
 Enum describing the address book authorization status.
 */
typedef NS_ENUM(CFIndex, BBAddressBookAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestAddressBookAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBAddressBookAuthorizationStatusNotDetermined = kABAuthorizationStatusNotDetermined,
    /**
     The status has been restricted and cannot be changed by the user.
     */
    BBAddressBookAuthorizationStatusRestricted = kABAuthorizationStatusRestricted,
    /**
     The status has been denied by the user.
     */
    BBAddressBookAuthorizationStatusDenied = kABAuthorizationStatusDenied,
    /**
     The client has been authorized to access the address book.
     */
    BBAddressBookAuthorizationStatusAuthorized = kABAuthorizationStatusAuthorized
};

/**
 Enum describing the microphone authorization status.
 */
typedef NS_OPTIONS(NSUInteger, BBMicrophoneAuthorizationStatus) {
    /**
     The status has not been determined. The client should call requestMicrophoneAuthorizationWithCompletion: to present the appropriate system alert to the user.
     */
    BBMicrophoneAuthorizationStatusNotDetermined = AVAudioSessionRecordPermissionUndetermined,
    /**
     The status has been denied by the user.
     */
    BBMicrophoneAuthorizationStatusDenied = AVAudioSessionRecordPermissionDenied,
    /**
     The client has been authorized to access the microphone.
     */
    BBMicrophoneAuthorizationStatusAuthorized = AVAudioSessionRecordPermissionGranted
};
#endif

/**
 BBAuthorizationStatusManager provides properties and methods to manages the various permissions required by the client.
 */
@interface BBAuthorizationStatusManager : NSObject

#if (TARGET_OS_IPHONE)
/**
 Get whether the client is authorized to always access location information.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationAlways;
/**
 Get whether the client is authorized to access location information only when in use.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorizationWhenInUse;
#else
/**
 Get whether the client can always access location information.
 */
@property (readonly,nonatomic) BOOL hasLocationAuthorization;
#endif
/**
 Get the current location authorization status.
 
 @see BBLocationAuthorizationStatus
 */
@property (readonly,nonatomic) BBLocationAuthorizationStatus locationAuthorizationStatus;

/**
 Get whether the client has calendar access.
 */
@property (readonly,nonatomic) BOOL hasCalendarAuthorization;
/**
 Get the current calendary authorization status.
 
 @see BBCalendarAuthorizationStatus
 */
@property (readonly,nonatomic) BBCalendarAuthorizationStatus calendarAuthorizationStatus;

/**
 Get whether the client has reminder access.
 */
@property (readonly,nonatomic) BOOL hasReminderAuthorization;
/**
 Get the current reminder authorization status.
 
 @see BBReminderAuthorizationStatus
 */
@property (readonly,nonatomic) BBReminderAuthorizationStatus reminderAuthorizationStatus;

#if (TARGET_OS_IPHONE)
/**
 Get whether the client has photo library access.
 */
@property (readonly,nonatomic) BOOL hasPhotoLibraryAuthorization;
/**
 Get the current photo library authorization status.
 
 @see BBPhotoLibraryAuthorizationStatus
 */
@property (readonly,nonatomic) BBPhotoLibraryAuthorizationStatus photoLibraryAuthorizationStatus;

/**
 Get whether the client has camera access.
 */
@property (readonly,nonatomic) BOOL hasCameraAuthorization;
/**
 Get the current camera authorization status.
 
 @see BBCameraAuthorizationStatus
 */
@property (readonly,nonatomic) BBCameraAuthorizationStatus cameraAuthorizationStatus;

/**
 Get whether the client has address book access.
 */
@property (readonly,nonatomic) BOOL hasAddressBookAuthorization;
/**
 Get the current address book authorization status.
 
 @see BBAddressBookAuthorizationStatus
 */
@property (readonly,nonatomic) BBAddressBookAuthorizationStatus addressBookAuthorizationStatus;

/**
 Get whether the client has microphone access.
 */
@property (readonly,nonatomic) BOOL hasMicrophoneAuthorization;
/**
 Get the current microphone authorization status.
 
 @see BBMicrophoneAuthorizationStatus
 */
@property (readonly,nonatomic) BBMicrophoneAuthorizationStatus microphoneAuthorizationStatus;
#endif

/**
 Returns the shared manager singleton.
 
 @return The shared manager
 */
+ (instancetype)sharedManager;

/**
 Requests location authorization of the appropriate type. On iOS, pass either BBLocationAuthorizationStatusAuthorizedAlways or BBLocationAuthorizationStatusAuthorizedWhenInUse for the authorization parameter. On OSX, pass BBLocationAuthorizationStatusAuthorized. The completion block will be invoked once the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to anything provided by the CoreLocation framework.
 
 @param authorization The location authorization to request
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestLocationAuthorization:(BBLocationAuthorizationStatus)authorization completion:(void(^)(BBLocationAuthorizationStatus status, NSError * _Nullable error))completion;
/**
 Requests calendar authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to entities in the EventKit framework of type EKEntityTypeEvent.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestCalendarAuthorizationWithCompletion:(void(^)(BBCalendarAuthorizationStatus status, NSError * _Nullable error))completion;
/**
 Requests reminder authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to entities in the EventKit framework of type EKEntityTypeReminder.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestReminderAuthorizationWithCompletion:(void(^)(BBReminderAuthorizationStatus status, NSError * _Nullable error))completion;
#if (TARGET_OS_IPHONE)
/**
 Requests photo library authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to anything provided by the Photos framework.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestPhotoLibraryAuthorizationWithCompletion:(void(^)(BBPhotoLibraryAuthorizationStatus status, NSError * _Nullable error))completion;
/**
 Requests camera authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to the AVFoundation framework; specifically AVCaptureDevice with a type of AVMediaTypeVideo.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestCameraAuthorizationWithCompletion:(void(^)(BBCameraAuthorizationStatus status, NSError * _Nullable error))completion;
/**
 Requests address book authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to anything provided by the AddressBook framework.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestAddressBookAuthorizationWithCompletion:(void(^)(BBAddressBookAuthorizationStatus status, NSError * _Nullable error))completion;
/**
 Requests microphone authorization and invokes the completion block when the authorization status has been determined. The completion block is always invoked on the main thread.
 
 This authorization relates to the AVFoundation framework; specifically AVAudioSession.
 
 @param completion The completion block to invoke when the authorization status has been determined
 @exception NSException Thrown if completion is nil
 */
- (void)requestMicrophoneAuthorizationWithCompletion:(void(^)(BBMicrophoneAuthorizationStatus status, NSError * _Nullable error))completion;
#endif

@end

NS_ASSUME_NONNULL_END
