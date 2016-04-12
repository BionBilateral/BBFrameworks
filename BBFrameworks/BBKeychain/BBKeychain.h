//
//  BBKeychain.h
//  BBFrameworks
//
//  Created by William Towe on 10/15/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum describing kechain security classes.
 */
typedef NS_ENUM(NSInteger, BBKeychainSecurityClass) {
    /**
     Security class for generic passwords.
     */
    BBKeychainSecurityClassGenericPassword,
    /**
     Security class for internet passwords.
     */
    BBKeychainSecurityClassInternetPassword,
    /**
     Security class for certificates.
     */
    BBKeychainSecurityClassCertificate,
    /**
     Security class for keys.
     */
    BBKeychainSecurityClassKey,
    /**
     Security class for identities.
     */
    BBKeychainSecurityClassIdentity
};

/**
 Enum describing the possible values that are used for the kSecAttrAccessible key, which controls when the keychain values can be accessed by the client. The default is BBKeychainAttributeAccessibleAfterFirstUnlock, which allows items to be accessed in the background after the user has unlocked their device.
 */
typedef NS_ENUM(NSInteger, BBKeychainAttributeAccessible) {
    /**
     Only allow access when the device is unlocked and client is in the foreground.
     */
    BBKeychainAttributeAccessibleWhenUnlocked,
    /**
     Allow access after the user has unlocked their device the first time between restarts. This is the most appropriate value for the majority of use cases and is used as the default.
     */
    BBKeychainAttributeAccessibleAfterFirstUnlock,
    /**
     Always allow access.
     */
    BBKeychainAttributeAccessibleAlways,
    /**
     Only allow access if the user has locked their device using a passcode. Values using this setting will not be transferred across devices using iCloud sync.
     */
    BBKeychainAttributeAccessibleWhenPasscodeSetThisDeviceOnly,
    /**
     See BBKeychainAttributeAccessibleWhenUnlocked. Values using this setting will not be transferred across devices using iCloud sync.
     */
    BBKeychainAttributeAccessibleWhenUnlockedThisDeviceOnly,
    /**
     See BBKeychainAttributeAccessibleAfterFirstUnlock. Values using this setting will not be transferred across devices using iCloud sync.
     */
    BBKeychainAttributeAccessibleAfterFirstUnlockThisDeviceOnly,
    /**
     See BBKeychainAttributeAccessibleAlways. Values using this setting will not be transferred across devices using iCloud sync.
     */
    BBKeychainAttributeAccessibleAlwaysThisDeviceOnly,
    /**
     Convenience value for the default, which is currently BBKeychainAttributeAccessibleAfterFirstUnlock.
     */
    BBKeychainAttributeAccessibleDefault = BBKeychainAttributeAccessibleAfterFirstUnlock
};

/**
 Error domain for errors returned by BBKeychain methods.
 */
extern NSString *const BBKeychainErrorDomain;

/**
 Key used to identify the account name in dictionary returned by account related methods.
 */
extern NSString *const BBKeychainAccountKeyName;
/**
 Key used to identify the account created at date which will be a string.
 */
extern NSString *const BBKeychainAccountKeyCreatedAt;
/**
 Key used to identify the label for an item.
 */
extern NSString *const BBKeychainAccountKeyLabel;
/**
 Key used to identify the description for an item.
 */
extern NSString *const BBKeychainAccountKeyDescription;
/**
 Key used to identify the last modified date which will be a string.
 */
extern NSString *const BBKeychainAccountKeyLastModified;
/**
 Key used to identify location where the item was created.
 */
extern NSString *const BBKeychainAccountKeyWhere;

/**
 BBKeychain is a NSObject subclass that provides an interface into the user's keychain using the Security framework.
 */
@interface BBKeychain : NSObject

/**
 Queries the keychain for a list of accounts matching the provided service, or all accounts if service is nil. The returned array contains NSDictionary objects keyed using the string constants starting with `BBKeychainAccountKey`.
 
 @param service The service for which to return accounts
 @param error If the call fails, an error providing information about the reason for failure
 @return An array of account dictionaries
 */
+ (nullable NSArray<NSDictionary<NSString*, id> *> *)accountsForService:(nullable NSString *)service error:(NSError **)error;

/**
 Calls [self passwordForService:account:keychainSecurityClass:error:] passing service, account, BBKeychainSecurityClassGenericPassword, and error respectively.
 
 @param service The service for which to return a password
 @param account The account for which to return a password
 @param error If the call fails, an error providing information about the reason for failure
 @return The password or nil
 */
+ (nullable NSString *)passwordForService:(nullable NSString *)service account:(nullable NSString *)account error:(NSError **)error;
/**
 Queries the keychain for a password matching the provided service and/or account.
 
 @param service The service for which to return a password
 @param account The account for which to return a password
 @param keychainSecurityClass The security class to query for
 @param error If the call fails, an error providing information about the reason for failure
 @return The password or nil
 */
+ (nullable NSString *)passwordForService:(nullable NSString *)service account:(nullable NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error;

/**
 Calls [self setPassword:forService:account:keychainSecurityClass:error:] passing password, service, account, BBKeychainSecurityClassGenericPassword, and error respectively.
 
 @param password The password to set
 @param service The service for which to set password
 @param account The account for which to set password
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if the password was set, otherwise NO
 */
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account error:(NSError **)error;
/**
 Calls `[self setPassword:forService:account:keychainSecurityClass:keychainAttributeAccessible:error:]`, passing password, service, account, keychainSecurityClass, BBKeychainAttributeAccessibleDefault, and error respectively.
 
 @param password The password to set
 @param service The service for which to set password
 @param account The account for which to set password
 @param keychainSecurityClass The security class for which to set the password
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if the password was set, otherwise NO
 */
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error;
/**
 Attempts to set the provided password for the provided service and account, returning a boolean to indicate success or failure.
 
 @param password The password to set
 @param service The service for which to set password
 @param account The account for which to set password
 @param keychainSecurityClass The security class for which to set the password
 @param keychainAttributeAccessible The accessible attribute to assign to the password
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if the password was set, otherwise NO
 */
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass keychainAttributeAccessible:(BBKeychainAttributeAccessible)keychainAttributeAccessible error:(NSError **)error;

/**
 Calls [self deletePasswordForService:account:keychainSecurityClass:error:] passing service, account, BBKeychainSecurityClassGenericPassword, and error respectively.
 
 @param service The service for which to delete the password
 @param account The account for which to delete the password
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if the password was deleted, otherwise NO
 */
+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account error:(NSError **)error;
/**
 Attempts to the delete the password for the provided service and account, returning a boolean to indicate success or failure.
 
 @param service The service for which to delete the password
 @param account The account for which to delete the password
 @param keychainSecurityClass The keychain security class for which to delete
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if the password was deleted, otherwise NO
 */
+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error;

#if (TARGET_OS_IPHONE)
/**
 Attempts to delete all items in the keychain for the provided security class, returning a boolean to indicate success or failure.
 
 @param keychainSecurityClass The keychain security class for which to delete keychain items
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if all items were deleted, otherwise NO
 */
+ (BOOL)deleteAllItemsForKeychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error;

/**
 Calls `[self deleteAllItemsForKeychainSecurityClass:error:]` for each security class available. Returns YES if all calls are successful, otherwise returns NO.
 
 @param error If the call fails, an error providing information about the reason for failure
 @return YES if all items for every security class were deleted, otherwise NO
 */
+ (BOOL)deleteAllItemsAndReturnError:(NSError **)error;
#endif

@end

NS_ASSUME_NONNULL_END
