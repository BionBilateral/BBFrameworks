//
//  BBAuthorizationStatusManager.m
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

#import "BBAuthorizationStatusManager.h"
#import "BBFoundationFunctions.h"
#import "BBFoundationDebugging.h"

#import <CoreLocation/CoreLocation.h>
#import <EventKit/EventKit.h>
#if (TARGET_OS_IPHONE)
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#endif

@interface BBAuthorizationStatusManager () <CLLocationManagerDelegate>
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (assign,nonatomic) BBLocationAuthorizationStatus requestedLocationAuthorizationStatus;
@property (copy,nonatomic) void(^locationCompletionBlock)(BBLocationAuthorizationStatus status,NSError * _Nullable error);
@end

@implementation BBAuthorizationStatusManager

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
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
            BBDispatchMainAsync(^{
                self.locationCompletionBlock(self.locationAuthorizationStatus,nil);
            });
            
            [self setLocationCompletionBlock:nil];
            [self setLocationManager:nil];
        }
    }
    else {
        BBDispatchMainAsync(^{
            self.locationCompletionBlock(self.locationAuthorizationStatus,nil);
        });
        
        [self setLocationCompletionBlock:nil];
        [self setLocationManager:nil];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    BBLogObject(error);
    BBDispatchMainAsync(^{
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
    NSParameterAssert(completion);
    
    if (self.locationAuthorizationStatus == authorization) {
        BBDispatchMainAsync(^{
            completion(self.locationAuthorizationStatus,nil);
        });
        return;
    }
    
    [self setRequestedLocationAuthorizationStatus:authorization];
    [self setLocationCompletionBlock:completion];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [self.locationManager setDelegate:self];
}
- (void)requestCalendarAuthorizationWithCompletion:(void(^)(BBCalendarAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.calendarAuthorizationStatus == BBCalendarAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.calendarAuthorizationStatus,nil);
        });
        return;
    }
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        BBDispatchMainAsync(^{
            completion(self.calendarAuthorizationStatus,error);
        });
    }];
}
- (void)requestReminderAuthorizationWithCompletion:(void(^)(BBReminderAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.reminderAuthorizationStatus == BBReminderAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.reminderAuthorizationStatus,nil);
        });
        return;
    }
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
        BBDispatchMainAsync(^{
            completion(self.reminderAuthorizationStatus,error);
        });
    }];
}
#if (TARGET_OS_IPHONE)
- (void)requestPhotoLibraryAuthorizationWithCompletion:(void(^)(BBPhotoLibraryAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.photoLibraryAuthorizationStatus == BBPhotoLibraryAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.photoLibraryAuthorizationStatus,nil);
        });
        return;
    }
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        BBDispatchMainAsync(^{
            completion((BBPhotoLibraryAuthorizationStatus)status,nil);
        });
    }];
}
- (void)requestCameraAuthorizationWithCompletion:(void(^)(BBCameraAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.cameraAuthorizationStatus == BBCameraAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.cameraAuthorizationStatus,nil);
        });
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        BBDispatchMainAsync(^{
            completion(self.cameraAuthorizationStatus,nil);
        });
    }];
}
- (void)requestAddressBookAuthorizationWithCompletion:(void(^)(BBAddressBookAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.addressBookAuthorizationStatus == BBAddressBookAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.addressBookAuthorizationStatus,nil);
        });
        return;
    }
    
    CFErrorRef outErrorRef;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &outErrorRef);
    
    if (addressBookRef == NULL) {
        NSError *outError = (__bridge NSError *)outErrorRef;
        
        BBDispatchMainAsync(^{
            completion(self.addressBookAuthorizationStatus,outError);
        });
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        NSError *outError = (__bridge NSError *)error;
        
        BBDispatchMainAsync(^{
            completion(self.addressBookAuthorizationStatus,outError);
        });
        
        CFRelease(addressBookRef);
    });
}
- (void)requestMicrophoneAuthorizationWithCompletion:(void(^)(BBMicrophoneAuthorizationStatus status, NSError * _Nullable error))completion; {
    if (self.microphoneAuthorizationStatus == BBMicrophoneAuthorizationStatusAuthorized) {
        BBDispatchMainAsync(^{
            completion(self.microphoneAuthorizationStatus,nil);
        });
        return;
    }
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        BBDispatchMainAsync(^{
            completion(self.microphoneAuthorizationStatus,nil);
        });
    }];
}
#endif

#if (TARGET_OS_IPHONE)
- (BOOL)hasLocationAuthorizationAlways {
    return [CLLocationManager locationServicesEnabled] && self.locationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedAlways;
}
- (BOOL)hasLocationAuthorizationWhenInUse {
    return [CLLocationManager locationServicesEnabled] && (self.locationAuthorizationStatus == BBLocationAuthorizationStatusAuthorizedWhenInUse || self.hasLocationAuthorizationAlways);
}

- (BOOL)hasPhotoLibraryAuthorization {
    return self.photoLibraryAuthorizationStatus == BBPhotoLibraryAuthorizationStatusAuthorized;
}
- (BBPhotoLibraryAuthorizationStatus)photoLibraryAuthorizationStatus {
    return (BBPhotoLibraryAuthorizationStatus)[PHPhotoLibrary authorizationStatus];
}

- (BOOL)hasCameraAuthorization {
    return self.cameraAuthorizationStatus == BBCameraAuthorizationStatusAuthorized;
}
- (BBCameraAuthorizationStatus)cameraAuthorizationStatus {
    return (BBCameraAuthorizationStatus)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
}

- (BOOL)hasAddressBookAuthorization {
    return self.addressBookAuthorizationStatus == BBAddressBookAuthorizationStatusAuthorized;
}
- (BBAddressBookAuthorizationStatus)addressBookAuthorizationStatus {
    return (BBAddressBookAuthorizationStatus)ABAddressBookGetAuthorizationStatus();
}

- (BOOL)hasMicrophoneAuthorization {
    return self.microphoneAuthorizationStatus == BBMicrophoneAuthorizationStatusAuthorized;
}
- (BBMicrophoneAuthorizationStatus)microphoneAuthorizationStatus {
    return (BBMicrophoneAuthorizationStatus)[[AVAudioSession sharedInstance] recordPermission];
}
#else
- (BOOL)hasLocationAuthorization {
    return [CLLocationManager locationServicesEnabled] && self.locationAuthorizationStatus == BBLocationAuthorizationStatusAuthorized;
}
#endif
- (BBLocationAuthorizationStatus)locationAuthorizationStatus {
    return (BBLocationAuthorizationStatus)[CLLocationManager authorizationStatus];
}

- (BOOL)hasCalendarAuthorization {
    return self.calendarAuthorizationStatus == BBCalendarAuthorizationStatusAuthorized;
}
- (BBCalendarAuthorizationStatus)calendarAuthorizationStatus {
    return (BBCalendarAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
}

- (BOOL)hasReminderAuthorization {
    return self.reminderAuthorizationStatus == BBReminderAuthorizationStatusAuthorized;
}
- (BBReminderAuthorizationStatus)reminderAuthorizationStatus {
    return (BBReminderAuthorizationStatus)[EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
}

@end
