//
//  BBReachability.m
//  BBFrameworks
//
//  Created by William Towe on 8/3/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBReachability.h"
#import "BBFoundationDebugging.h"
#import "BBFrameworksMacros.h"
#import "BBFoundationFunctions.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>

NSString *const BBReachabilityNotificationFlagsDidChange = @"BBReachabilityNotificationFlagsDidChange";

@interface BBReachability ()
@property (assign,nonatomic) SCNetworkReachabilityRef networkReachability;
@property (strong,nonatomic) dispatch_queue_t serialQueue;

- (void)_networkReachabilityFlagsChanged;
@end

static void kBBReachabilityCallback(SCNetworkReachabilityRef networkReachability, SCNetworkReachabilityFlags flags, void *info) {
    [(__bridge BBReachability *)info _networkReachabilityFlagsChanged];
}

@implementation BBReachability

- (void)dealloc {
    if (_networkReachability) {
        SCNetworkReachabilitySetCallback(_networkReachability, NULL, NULL);
        SCNetworkReachabilitySetDispatchQueue(_networkReachability, NULL);
        
        CFRelease(_networkReachability);
    }
}

+ (instancetype)reachabilityForInternetConnection; {
    struct sockaddr address;
    
    bzero(&address, sizeof(address));
    
    address.sa_len = sizeof(address);
    address.sa_family = AF_INET;
    
    return [[self alloc] initWithNetworkReachability:SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, &address)];
}
+ (instancetype)reachabilityWithHostName:(NSString *)hostName; {
    NSParameterAssert(hostName);
    
    return [[self alloc] initWithNetworkReachability:SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, hostName.UTF8String)];
}

- (instancetype)initWithNetworkReachability:(SCNetworkReachabilityRef)networkReachability {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(networkReachability);
    
    [self setNetworkReachability:networkReachability];
    
    [self setSerialQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.%p",NSStringFromClass(self.class),self].UTF8String, DISPATCH_QUEUE_SERIAL)];
    
    SCNetworkReachabilityContext context = {0,(__bridge void *)self,NULL,NULL,NULL};
    
    SCNetworkReachabilitySetCallback(self.networkReachability, &kBBReachabilityCallback, &context);
    SCNetworkReachabilitySetDispatchQueue(self.networkReachability, self.serialQueue);
    
    return self;
}

- (BBReachabilityFlags)flags {
    SCNetworkConnectionFlags retval = 0;
    
    if (!SCNetworkReachabilityGetFlags(self.networkReachability, &retval)) {
        BBLog(@"Unable to determine network flags for %@",self);
    }
    
    return retval;
}

- (BOOL)isReachable {
    return (self.flags & BBReachabilityFlagsReachable) != 0;
}
- (BOOL)isReachableViaWiFi {
#if (TARGET_OS_IPHONE)
    return self.isReachable && !self.isReachableViaWWAN;
#else
    return self.isReachable;
#endif
}
#if (TARGET_OS_IPHONE)
- (BOOL)isReachableViaWWAN {
    return self.isReachable && ((self.flags & BBReachabilityFlagsIsWWAN) != 0);
}
#endif

- (void)_networkReachabilityFlagsChanged; {
    BBWeakify(self);
    BBDispatchMainSyncSafe(^{
        BBStrongify(self);
        [self willChangeValueForKey:@"flags"];
        [self didChangeValueForKey:@"flags"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BBReachabilityNotificationFlagsDidChange object:self];
    });
}

@end
