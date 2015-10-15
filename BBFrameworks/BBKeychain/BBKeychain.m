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

#import <Security/Security.h>

static NSDictionary *BBKeychainQueryDictionaryForServiceAndAccount(NSString *service, NSString *account) {
    NSMutableDictionary *query = [[NSMutableDictionary alloc] init];
    
    [query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    if (service) {
        [query setObject:service forKey:(__bridge id)kSecAttrService];
    }
    if (account) {
        [query setObject:account forKey:(__bridge id)kSecAttrAccount];
    }
    
    return [query copy];
}

@implementation BBKeychain

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
    NSParameterAssert(service || account);
    
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, account) mutableCopy];
    
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFTypeRef result;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    
    if (status != errSecSuccess) {
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
    NSParameterAssert(password);
    NSParameterAssert(service);
    NSParameterAssert(account);
    
    NSMutableDictionary *query = [BBKeychainQueryDictionaryForServiceAndAccount(service, account) mutableCopy];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
    
    if (status == errSecSuccess) {
        status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)@{(__bridge id)kSecValueData: [password dataUsingEncoding:NSUTF8StringEncoding]});
    }
    else if (status == errSecItemNotFound) {
        [query setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }
    
    BOOL retval = status == errSecSuccess;
    
    return retval;
}

@end
