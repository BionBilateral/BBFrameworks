//
//  NSData+BBFoundationExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 5/15/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSData+BBFoundationExtensions.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData (BBFoundationExtensions)

- (NSString *)BB_MD5String; {
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableString *retval = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (NSUInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [retval appendFormat:@"%02x",buffer[i]];
    }
    
    return retval;
}
- (NSString *)BB_SHA1String; {
    unsigned char buffer[CC_SHA1_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableString *retval = [[NSMutableString alloc] initWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (NSUInteger i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [retval appendFormat:@"%02x",buffer[i]];
    }
    
    return retval;
}
- (NSString *)BB_SHA256String; {
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableString *retval = [[NSMutableString alloc] initWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for (NSUInteger i=0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [retval appendFormat:@"%02x",buffer[i]];
    }
    
    return retval;
}
- (NSString *)BB_SHA512String; {
    unsigned char buffer[CC_SHA512_DIGEST_LENGTH];
    
    CC_MD5(self.bytes, (CC_LONG)self.length, buffer);
    
    NSMutableString *retval = [[NSMutableString alloc] initWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for (NSUInteger i=0; i<CC_SHA512_DIGEST_LENGTH; i++) {
        [retval appendFormat:@"%02x",buffer[i]];
    }
    
    return retval;
}

@end
