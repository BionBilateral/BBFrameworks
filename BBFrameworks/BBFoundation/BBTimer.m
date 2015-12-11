//
//  BBTimer.m
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

#import "BBTimer.h"
#import "BBFrameworksMacros.h"

#import <libkern/OSAtomic.h>

@interface BBTimer ()
@property (assign,nonatomic) NSTimeInterval timeInterval;
@property (weak,nonatomic) id target;
@property (assign,nonatomic) SEL selector;
@property (copy,nonatomic) BBTimerCompletionBlock block;
@property (readwrite,strong,nonatomic,nullable) id userInfo;
@property (assign,nonatomic) BOOL repeats;
@property (strong,nonatomic) dispatch_queue_t queue;
@property (strong,nonatomic) dispatch_source_t timer;

- (void)_createQueueWithQueue:(dispatch_queue_t)queue;
- (void)_resetTimerProperties;
@end

@implementation BBTimer {
    uint32_t hasBeenInvalidated;
}

- (void)dealloc {
    [self invalidate];
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue; {
    BBTimer *retval = [[BBTimer alloc] initWithTimeInterval:timeInterval target:target selector:selector userInfo:userInfo repeats:repeats queue:queue];
    
    [retval schedule];
    
    return retval;
}
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(BBTimerCompletionBlock)block userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue; {
    BBTimer *retval = [[BBTimer alloc] initWithTimeInterval:timeInterval block:block userInfo:userInfo repeats:repeats queue:queue];
    
    [retval schedule];
    
    return retval;
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(target);
    NSParameterAssert(selector);
    
    if (!queue) {
        queue = dispatch_get_main_queue();
    }
    
    [self setTimeInterval:timeInterval];
    [self setTarget:target];
    [self setSelector:selector];
    [self setUserInfo:userInfo];
    [self setRepeats:repeats];
    
    [self _createQueueWithQueue:queue];
    
    return self;
}
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval block:(BBTimerCompletionBlock)block userInfo:(id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(block);
    
    if (!queue) {
        queue = dispatch_get_main_queue();
    }
    
    [self setTimeInterval:timeInterval];
    [self setBlock:block];
    [self setUserInfo:userInfo];
    [self setRepeats:repeats];
    
    [self _createQueueWithQueue:queue];
    
    return self;
}

- (void)schedule; {
    [self _resetTimerProperties];
    
    BBWeakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        BBStrongify(self);
        [self fire];
    });
    
    dispatch_resume(self.timer);
}
- (void)fire; {
    if (OSAtomicAnd32OrigBarrier(1, &hasBeenInvalidated) != 0) {
        return;
    }
    
    if (self.block) {
        self.block(self);
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    }
    
    if (!self.repeats) {
        [self invalidate];
    }
}
- (void)invalidate; {
    if (!OSAtomicTestAndSetBarrier(7, &hasBeenInvalidated)) {
        dispatch_source_t timer = self.timer;
        dispatch_async(self.queue, ^{
            dispatch_source_cancel(timer);
        });
    }
}

@synthesize tolerance=_tolerance;
- (NSTimeInterval)tolerance {
    @synchronized(self) {
        return _tolerance;
    }
}
- (void)setTolerance:(NSTimeInterval)tolerance {
    @synchronized(self) {
        if (_tolerance != tolerance) {
            _tolerance = tolerance;
            
            [self _resetTimerProperties];
        }
    }
}

- (void)_createQueueWithQueue:(dispatch_queue_t)queue; {
    [self setQueue:dispatch_queue_create([NSString stringWithFormat:@"%@.%p",NSStringFromClass(self.class),self].UTF8String, DISPATCH_QUEUE_SERIAL)];
    
    dispatch_set_target_queue(self.queue, queue);
    
    [self setTimer:dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue)];
}
- (void)_resetTimerProperties; {
    int64_t intervalNanos = (int64_t)(self.timeInterval * NSEC_PER_SEC);
    int64_t toleranceNanos = (int64_t)(self.tolerance * NSEC_PER_SEC);
    
    dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, intervalNanos), intervalNanos, toleranceNanos);
}

@end
