//
//  BBReachability.h
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

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>

/**
 Flags mask describing the status of the network connection.
 */
typedef NS_OPTIONS(NSInteger, BBReachabilityFlags) {
    /**
     The flags could not be determined.
     */
    BBReachabilityFlagsNone = 0,
    /**
     The network can be reached via a transient connection (e.g. PPP).
     */
    BBReachabilityFlagsTransientConnection = kSCNetworkReachabilityFlagsTransientConnection,
    /**
     The network can be reached using the current network configuration.
     */
    BBReachabilityFlagsReachable = kSCNetworkReachabilityFlagsReachable,
    /**
     The network can be reached using the current network configuration, but a connection must be established first.
     */
    BBReachabilityFlagsConnectionRequired = kSCNetworkReachabilityFlagsConnectionRequired,
    /**
     The network can be reached using the current network configuration. Any attempt to connect will establish the connection.
     */
    BBReachabilityFlagsConnectionOnTraffic = kSCNetworkReachabilityFlagsConnectionOnTraffic,
    /**
     The network can be reached using the current network configuration. Any attempt to connect will require additional intervention on behalf of the user (e.g. entering a password).
     */
    BBReachabilityFlagsInterventionRequired = kSCNetworkReachabilityFlagsInterventionRequired,
    /**
     The network can be reached using the current network configuration. The connection will be established automatically when needed.
     */
    BBReachabilityFlagsConnectionOnDemand = kSCNetworkReachabilityFlagsConnectionOnDemand,
    /**
     The network connection represents a local connection.
     */
    BBReachabilityFlagsIsLocalAddress = kSCNetworkReachabilityFlagsIsLocalAddress,
    /**
     The network connection will not be routed through a gateway.
     */
    BBReachabilityFlagsIsDirect = kSCNetworkReachabilityFlagsIsDirect,
    /**
     The network can be reached via a cellular connection (e.g. EDGE, LTE).
     */
#if (TARGET_OS_IPHONE)
    BBReachabilityFlagsIsWWAN = kSCNetworkReachabilityFlagsIsWWAN,
#endif
    /**
     Identical to BBReachabilityFlagsConnectionOnTraffic.
     */
    BBReachabilityFlagsConnectionAutomatic = kSCNetworkReachabilityFlagsConnectionAutomatic
};

/**
 Notification that is posted when the flags of the receiver change. The object of the notification is self.
 */
extern NSString *const BBReachabilityNotificationFlagsDidChange;

/**
 BBReachability is an NSObject subclass that wraps the network reachability interface provided by the SystemConfiguration framework.
 */
@interface BBReachability : NSObject

/**
 The current flags of the receiver. This property is KVO compliant.
 
 @see BBReachabilityFlags
 */
@property (readonly,nonatomic) BBReachabilityFlags flags;

/**
 Get whether the receiver is reachable.
 
 @see BBReachabilityFlagsReachable
 */
@property (readonly,nonatomic,getter=isReachable) BOOL reachable;
/**
 Get whether the receiver is reachable via WiFi.
 */
@property (readonly,nonatomic,getter=isReachableViaWiFi) BOOL reachableViaWiFi;
/**
 Get whether the receiver is reachable via a cellular connection.
 */
#if (TARGET_OS_IPHONE)
@property (readonly,nonatomic,getter=isReachableViaWWAN) BOOL reachableViaWWAN;
#endif

/**
 Returns an instance of the receiver to test for a valid internet connection.
 
 @return An initialized instance of the receiver
 */
+ (instancetype)reachabilityForInternetConnection;
/**
 Returns an instance of the receiver to test for a connection to the provided host name.
 
 @param hostName The host name to test (e.g. @"www.google.com")
 @return An initialized instance of the receiver
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/**
 Designated initializer.
 
 @param networkReachability The network reachability instance that should be used to check for a connection
 @return An initialized instance of the receiver
 */
- (instancetype)initWithNetworkReachability:(SCNetworkReachabilityRef)networkReachability NS_DESIGNATED_INITIALIZER;

@end
