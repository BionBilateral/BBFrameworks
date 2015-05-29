//
//  NSURL+BBFoundationExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 5/17/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSURL+BBFoundationExtensions.h"

@implementation NSURL (BBFoundationExtensions)

- (NSDictionary *)BB_queryDictionary; {
    NSMutableDictionary *retval = nil;
    
    if (self.query.length > 0) {
        retval = [[NSMutableDictionary alloc] init];
        
        for (NSString *pair in [self.query componentsSeparatedByString:@"&"]) {
            NSArray *pairComps = [pair componentsSeparatedByString:@"="];
            
            [retval setObject:pairComps[1] forKey:pairComps[0]];
        }
    }
    
    return retval;
}

+ (NSURL *)BB_URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters; {
    if (baseString) {
        NSMutableString *retval = [[NSMutableString alloc] initWithString:baseString];
        
        if (parameters.count > 0) {
            __block NSUInteger i = 0;
            
            [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                if ((i++) == 0) {
                    [retval appendFormat:@"?%@=%@",key,obj];
                }
                else {
                    [retval appendFormat:@"&%@=%@",key,obj];
                }
            }];
        }
        
        return [NSURL URLWithString:retval];
    }
    return nil;
}

@end
