//
//  BBTimer.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BBTimer;

/**
 Completion block that is invoked whenever the timer fires. The timer itself is passed into the completion block.
 
 @param timer The timer that was fired
 */
typedef void(^BBTimerCompletionBlock)(BBTimer *timer);

/**
 BBTimer is a NSObject subclass that serves the same function as NSTimer, but does so using GCD. The main advantage of this approach is that BBTimer does create a retain cycle between the target and the timer as NSTimer does.
 */
@interface BBTimer : NSObject

/**
 Get the userInfo object passed in during creation.
 */
@property (readonly,strong,nonatomic,nullable) id userInfo;
/**
 Get and set the tolerance of the receiver, which allows the system to aggresively schedule timers to save power and increase responsiveness. See tolerance in NSTimer.h for more information.
 
 The default is 0.0;
 */
@property (assign) NSTimeInterval tolerance;

/**
 Creates a new timer using `initWithTimeInterval:target:selector:userInfo:repeats:queue:`, calls `schedule` on it and returns it.
 
 @param timeInterval The time interval at which to fire the timer
 @param target The target of the timer
 @param selector The selector that should be invoked on the target when the timer fires
 @param userInfo Optional user info to associate with the timer
 @param repeats Whether the timer should repeat itself, if NO the timer will fire a single time and invalidate itself
 @param queue The queue on which to send target selector, if nil, the main queue is used
 @return The initialized timer instance
 */
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue;
/**
 Creates a new timer using `initWithTimeInterval:block:userInfo:repeats:queue:`, calls `schedule` on it and returns it.
 
 @param timeInterval The time interval at which to fire the timer
 @param block The block that should be invoked when the timer fires
 @param userInfo Optional user info to associate with the timer
 @param repeats Whether the timer should repeat itself, if NO the timer will fire a single time and invalidate itself
 @param queue The queue on which to send target selector, if nil, the main queue is used
 @return The initialized timer instance
 */
+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(BBTimerCompletionBlock)block userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue;

/**
 Creates and returns a timer instance, but does not schedule itself. You must call `schedule` on the returned instance before it will fire.
 
 @param timeInterval The time interval at which to fire the timer
 @param target The target of the timer
 @param selector The selector that should be invoked on the target when the timer fires
 @param userInfo Optional user info to associate with the timer
 @param repeats Whether the timer should repeat itself, if NO the timer will fire a single time and invalidate itself
 @param queue The queue on which to send target selector, if nil, the main queue is used
 @return The initialized timer instance
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval target:(id)target selector:(SEL)selector userInfo:(nullable id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue;
/**
 Creates and returns a timer instance, but not schedule itself. You must call `schedule` on the returned instance before it will fire.
 
 @param timeInterval The time interval at which to fire the timer
 @param block The block that should be invoked when the timer fires
 @param userInfo Optional user info to associate with the timer
 @param repeats Whether the timer should repeat itself, if NO the timer will fire a single time and invalidate itself
 @param queue The queue on which to send target selector, if nil, the main queue is used
 @return The initialized timer instance
 */
- (instancetype)initWithTimeInterval:(NSTimeInterval)timeInterval block:(BBTimerCompletionBlock)block userInfo:(id)userInfo repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue;

- (instancetype)init __attribute__((unavailable("use initWithTimeInterval:target:selector:userInfo:repeats:queue: or initWithTimeInterval:block:userInfo:repeats:queue: instead")));

/**
 Schedules the receiver to fire. Calling this on a timer that has already been scheduled is undefined.
 */
- (void)schedule;
/**
 Fires the timer synchronously on the calling queue. If called on a repeating timer, its regular schedule will not be interrupted. If called on a non-repeating timer, it will invalidate itself and firing.
 */
- (void)fire;
/**
 Cancels a scheduled timer and prevents it from firing again. This method can be called from any thread.
 */
- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
