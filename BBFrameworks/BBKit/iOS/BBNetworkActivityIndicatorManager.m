//
//  BBNetworkActivityIndicatorManager.m
//  BBFrameworks
//
//  Created by William Towe on 12/4/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBNetworkActivityIndicatorManager.h"
#import "BBTimer.h"
#import "BBFrameworksMacros.h"
#import "BBFoundationFunctions.h"

#import <UIKit/UIKit.h>

@interface BBNetworkActivityIndicatorManager ()
@property (assign,nonatomic) NSInteger activityCount;
@property (strong,nonatomic) BBTimer *timer;

- (void)_updateNetworkActivityIndicatorManager;
@end

@implementation BBNetworkActivityIndicatorManager

+ (instancetype)sharedManager; {
    static id kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[BBNetworkActivityIndicatorManager alloc] init];
    });
    return kRetval;
}

- (void)incrementActivityCount; {
    [self setActivityCount:self.activityCount + 1];
    
    [self _updateNetworkActivityIndicatorManager];
}
- (void)decrementActivityCount; {
    [self setActivityCount:MAX(self.activityCount - 1, 0)];
    
    [self _updateNetworkActivityIndicatorManager];
}
- (void)resetActivityCount; {
    [self setActivityCount:0];
    
    [self _updateNetworkActivityIndicatorManager];
}

- (BOOL)isNetworkActivityIndicatorVisible {
    return self.activityCount > 0;
}

- (void)_updateNetworkActivityIndicatorManager; {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
        return;
    }
    
    if (!self.isEnabled) {
        return;
    }
    
    if (self.isNetworkActivityIndicatorVisible) {
#if (!TARGET_OS_WATCH)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self.isNetworkActivityIndicatorVisible];
#endif
    }
    else {
        [self.timer invalidate];
        [self setTimer:[BBTimer scheduledTimerWithTimeInterval:0.17 block:^(BBTimer *timer){
#if (!TARGET_OS_WATCH)
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self.isNetworkActivityIndicatorVisible];
#endif
        } userInfo:nil repeats:NO queue:nil]];
    }
}

@synthesize activityCount=_activityCount;
- (NSInteger)activityCount {
    @synchronized(self) {
        return _activityCount;
    }
}
- (void)setActivityCount:(NSInteger)activityCount {
    [self willChangeValueForKey:@BBKeypath(self,isNetworkActivityIndicatorVisible)];
    
    @synchronized(self) {
        _activityCount = activityCount;
    }
    
    [self didChangeValueForKey:@BBKeypath(self,isNetworkActivityIndicatorVisible)];
}

@end
