//
//  BBKeychain.m
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

#import "BBKeychain.h"
#import "BBFrameworksFunctions.h"

#import <Security/Security.h>

NSString *const BBKeychainErrorDomain = @"com.bionbilateral.bbkeychain";

NSString *const BBKeychainAccountKeyName = @"acct";
NSString *const BBKeychainAccountKeyCreatedAt = @"cdat";
NSString *const BBKeychainAccountKeyLabel = @"labl";
NSString *const BBKeychainAccountKeyDescription = @"desc";
NSString *const BBKeychainAccountKeyLastModified = @"mdat";
NSString *const BBKeychainAccountKeyWhere = @"svce";

static NSString *BBKeychainSecClassForKeychainSecurityClass(BBKeychainSecurityClass keychainSecurityClass) {
    switch (keychainSecurityClass) {
        case BBKeychainSecurityClassCertificate:
            return (__bridge NSString *)kSecClassCertificate;
        case BBKeychainSecurityClassGenericPassword:
            return (__bridge NSString *)kSecClassGenericPassword;
        case BBKeychainSecurityClassIdentity:
            return (__bridge NSString *)kSecClassIdentity;
        case BBKeychainSecurityClassInternetPassword:
            return (__bridge NSString *)kSecClassInternetPassword;
        case BBKeychainSecurityClassKey:
            return (__bridge NSString *)kSecClassKey;
        default:
            return nil;
    }
}

static NSDictionary *BBKeychainQueryDictionaryForServiceAndAccount(NSString *service, NSString *account, BBKeychainSecurityClass securityClass) {
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    
    [query setObject:BBKeychainSecClassForKeychainSecurityClass(securityClass) forKey:(__bridge id)kSecClass];
    
    if (service) {
        [query setObject:service forKey:(__bridge id)kSecAttrService];
    }
    if (account) {
        [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    }
    
    return [query copy];
}

static NSError *BBKeychainErrorForOSStatus(OSStatus status) {
    NSString *message = nil;
    
    switch (status) {
#if (TARGET_OS_IPHONE)
        case errSecUnimplemented:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_UNIMPLEMENTED", @"Keychain", BBFrameworksResourcesBundle(), @"Function or operation not implemented.", @"errSecUnimplemented");
            break;
        case errSecParam:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_PARAM", @"Keychain", BBFrameworksResourcesBundle(), @"One or more parameters passed to a function where not valid.", @"errSecParam");
            break;
        case errSecAllocate:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_ALLOCATE", @"Keychain", BBFrameworksResourcesBundle(), @"Failed to allocate memory.", @"errSecAllocate");
            break;
        case errSecNotAvailable:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_NOT_AVAILABLE", @"Keychain", BBFrameworksResourcesBundle(), @"No keychain is available. You may need to restart your computer.", @"errSecNotAvailable");
            break;
        case errSecDuplicateItem:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_DUPLICATE_ITEM", @"Keychain", BBFrameworksResourcesBundle(), @"The specified item already exists in the keychain.", @"errSecDuplicateItem");
            break;
        case errSecItemNotFound:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_ITEM_NOT_FOUND", @"Keychain", BBFrameworksResourcesBundle(), @"The specified item could not be found in the keychain.", @"errSecItemNotFound");
            break;
        case errSecInteractionNotAllowed:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_ITEM_NOT_ALLOWED", @"Keychain", BBFrameworksResourcesBundle(), @"User interaction is not allowed.", @"errSecInteractionNotAllowed");
            break;
        case errSecDecode:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_DECODE", @"Keychain", BBFrameworksResourcesBundle(), @"Unable to decode the provided data.", @"errSecDecode");
            break;
        case errSecAuthFailed:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_AUTH_FAILED", @"Keychain", BBFrameworksResourcesBundle(), @"The user name or passphrase you entered is not correct.", @"errSecAuthFailed");
            break;
        default:
            message = NSLocalizedStringWithDefaultValue(@"KEYCHAIN_ERR_SEC_DEFAULT", @"Keychain", BBFrameworksResourcesBundle(), @"Refer to <Security/SecBase.h> for description", @"default keychain error");
            break;
#else
        default:
            message = (__bridge_transfer NSString *)SecCopyErrorMessageString(status, NULL);
            break;
#endif
    }
    
    return [NSError errorWithDomain:BBKeychainErrorDomain code:status userInfo:message ? @{NSLocalizedDescriptionKey: message} : nil];
}

@implementation BBKeychain

+ (nullable NSArray<NSDictionary<NSString*, id> *> *)accounts; {
    return [self accountsForService:nil error:NULL];
}
+ (nullable NSArray<NSDictionary<NSString*, id> *> *)accounts:(NSError **)error; {
    return [self accountsForService:nil error:error];
}
+ (nullable NSArray<NSDictionary<NSString*, id> *> *)accountsForService:(nullable NSString *)service; {
    return [self accountsForService:service error:NULL];
}
+ (nullable NSArray<NSDictionary<NSString*, id> *> *)accountsForService:(nullable NSString *)service error:(NSError **)error; {
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, nil, BBKeychainSecurityClassGenericPassword) mutableCopy];
    
    [query setObject:@YES forKey:(__bridge id)kSecReturnAttributes];
    [query setObject:(__bridge id)kSecMatchLimitAll forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status != errSecSuccess) {
        if (error) {
            *error = BBKeychainErrorForOSStatus(status);
        }
        return nil;
    }
    
    NSArray *retval = (__bridge_transfer NSArray *)result;
    
    return retval;
}

+ (nullable NSString *)passwordForService:(NSString *)service; {
    return [self passwordForService:service account:nil error:NULL];
}
+ (nullable NSString *)passwordForAccount:(NSString *)account; {
    return [self passwordForService:nil account:account error:NULL];
}
+ (nullable NSString *)passwordForService:(NSString *)service error:(NSError **)error; {
    return [self passwordForService:service account:nil error:error];
}
+ (nullable NSString *)passwordForAccount:(NSString *)account error:(NSError **)error; {
    return [self passwordForService:nil account:account error:error];
}
+ (nullable NSString *)passwordForService:(nullable NSString *)service account:(nullable NSString *)account; {
    return [self passwordForService:service account:account error:NULL];
}
+ (nullable NSString *)passwordForService:(nullable NSString *)service account:(nullable NSString *)account error:(NSError **)error; {
    return [self passwordForService:service account:account keychainSecurityClass:BBKeychainSecurityClassGenericPassword error:error];
}
+ (nullable NSString *)passwordForService:(nullable NSString *)service account:(nullable NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error; {
    NSParameterAssert(service || account);
    
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, account, keychainSecurityClass) mutableCopy];
    
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status != errSecSuccess) {
        if (error) {
            *error = BBKeychainErrorForOSStatus(status);
        }
        return nil;
    }
    
    NSData *data = (__bridge_transfer NSData *)result;
    NSString *retval = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return retval;
}

+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account; {
    return [self setPassword:password forService:service account:account error:NULL];
}
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account error:(NSError **)error; {
    return [self setPassword:password forService:service account:account keychainSecurityClass:BBKeychainSecurityClassGenericPassword error:error];
}
+ (BOOL)setPassword:(NSString *)password forService:(NSString *)service account:(NSString *)account keychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error; {
    NSParameterAssert(password);
    NSParameterAssert(service);
    NSParameterAssert(account);
    
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, account, keychainSecurityClass) mutableCopy];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    if (status == errSecSuccess) {
        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)@{(__bridge id)kSecValueData: [password dataUsingEncoding:NSUTF8StringEncoding]});
    }
    else if (status == errSecItemNotFound) {
        [query setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    
    BOOL retval = status == errSecSuccess;
    
    if (!retval && error) {
        *error = BBKeychainErrorForOSStatus(status);
    }
    
    return retval;
}

+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account; {
    return [self deletePasswordForService:service account:account error:NULL];
}
+ (BOOL)deletePasswordForService:(NSString *)service account:(NSString *)account error:(NSError **)error; {
    NSParameterAssert(service);
    NSParameterAssert(account);
    
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, account, BBKeychainSecurityClassGenericPassword) mutableCopy];
    OSStatus status;
    
#if (TARGET_OS_IPHONE)
    status = SecItemDelete((__bridge CFDictionaryRef)query);
#else
    [query setObject:@YES forKey:(__bridge id)kSecReturnRef];
    
    CFTypeRef result;
    
    status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status == errSecSuccess) {
        status = SecKeychainItemDelete((SecKeychainItemRef)result);
        
        CFRelease(result);
    }
#endif
    
    BOOL retval = status == errSecSuccess;
    
    if (!retval && error) {
        *error = BBKeychainErrorForOSStatus(status);
    }
    
    return retval;
}

#if (TARGET_OS_IPHONE)
+ (BOOL)deleteAllItemsForKeychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass; {
    return [self deleteAllItemsForKeychainSecurityClass:keychainSecurityClass error:NULL];
}
+ (BOOL)deleteAllItemsForKeychainSecurityClass:(BBKeychainSecurityClass)keychainSecurityClass error:(NSError **)error; {
    NSDictionary *query = @{(__bridge id)kSecClass: BBKeychainSecClassForKeychainSecurityClass(keychainSecurityClass)};
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    
    if (status != errSecSuccess) {
        if (error) {
            *error = BBKeychainErrorForOSStatus(status);
        }
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteAllItems; {
    return [self deleteAllItemsAndReturnError:NULL];
}
+ (BOOL)deleteAllItemsAndReturnError:(NSError * _Nullable __autoreleasing *)error {
    NSArray<NSNumber *> *keychainSecurityClasses = @[@(BBKeychainSecurityClassKey),
                                                     @(BBKeychainSecurityClassInternetPassword),
                                                     @(BBKeychainSecurityClassIdentity),
                                                     @(BBKeychainSecurityClassGenericPassword),
                                                     @(BBKeychainSecurityClassCertificate)];
    
    for (NSNumber *value in keychainSecurityClasses) {
        if (![self deleteAllItemsForKeychainSecurityClass:value.integerValue error:error]) {
            return NO;
        }
    }
    
    return YES;
}
#endif

@end
