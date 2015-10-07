//
//  UIAlertController+BBExtensions.h
//  BBFrameworks
//
//  Created by Jason Anderson on 7/3/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The constant button index used to indicate the user tapped on the cancel button.
 */
extern NSInteger const BBKitUIAlertControllerCancelButtonIndex;

/**
 Typedef for block that is invoked after the user has tapped on one of the alert buttons and the alert has been dismissed.
 
 @param buttonIndex The index of the button that was tapped
 */
typedef void(^BBKitUIAlertControllerCompletionBlock)(NSInteger buttonIndex);

/**
 Category on UIAlertController providing convenience methods related to creation from error objects.
 */
@interface UIAlertController (BBKitExtensions)

/**
 Calls `[self BB_presentAlertControllerWithError:completion:]`, passing error and nil respectively.
 
 @param error The error from which to create and present the alert controller
 */
+ (void)BB_presentAlertControllerWithError:(nullable NSError *)error;
/**
 Calls `[self BB_presentAlertControllerWithTitle:message:cancelButtonTitle:otherButtonTitles:completion:]`, passing [error BB_alertTitle], [error BB_alertMessage], nil, nil, and completion respectively.
 
 @param error The error from which to create and present the alert controller
 @param completion The completion block to invoke after the alert controller is dismissed
 */
+ (void)BB_presentAlertControllerWithError:(nullable NSError *)error completion:(nullable BBKitUIAlertControllerCompletionBlock)completion;
/**
 Creates and presents an alert controller using the provided parameters. If you want to present the alert yourself, use `BB_alertControllerWithTitle:message:cancelButtonTitle:otherButtonTitles:completion:` instead.
 
 @param title The title of the alert, if nil a localized default is used
 @param message The message of the alert, if nil a localized default is used
 @param cancelButtonTitle The cancel button title of the alert, if nil a localized default is used
 @param otherButtonTitles The array of other button titles to add to the receiver
 @param completion The completion block to invoke after the alert controller is dismissed
 */
+ (void)BB_presentAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles completion:(nullable BBKitUIAlertControllerCompletionBlock)completion;

/**
 Calls `[self BB_alertControllerWithError:completion:]`, passing error and nil respectively.
 
 @param error The error from which to create the alert controller
 @return The alert controller
 */
+ (UIAlertController *)BB_alertControllerWithError:(nullable NSError *)error;
/**
 Calls `[self BB_alertControllerWithTitle:message:cancelButtonTitle:otherButtonTitles:completion:]`, passing [error BB_alertTitle], [error BB_alertMessage], nil, nil, and completion respectively.
 
 @param error The error from which to create the alert controller
 @param completion The completion block to invoke after the alert controller is dismissed
 @return The alert controller
 */
+ (UIAlertController *)BB_alertControllerWithError:(nullable NSError *)error completion:(nullable BBKitUIAlertControllerCompletionBlock)completion;
/**
 Creates and returns a alert controller using the provided parameters.
 
 @param title The title of the alert, if nil a localized default is used
 @param message The message of the alert, if nil a localized default is used
 @param cancelButtonTitle The cancel button title of the alert, if nil a localized default is used
 @param otherButtonTitles The array of other button titles to add to the receiver
 @param completion The completion block to invoke after the alert controller is dismissed
 @return The alert controller
 */
+ (UIAlertController *)BB_alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles completion:(nullable BBKitUIAlertControllerCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END