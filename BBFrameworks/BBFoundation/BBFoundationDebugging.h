//
//  BBFoundationDebugging.h
//  BBFrameworks
//
//  Created by William Towe on 4/10/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_FOUNDATION_DEBUGGING__
#define __BB_FRAMEWORKS_FOUNDATION_DEBUGGING__

/**
 Simplified version of the flag/level system that CocoaLumberjack uses to control what statements get logged. See their documentation at https://github.com/CocoaLumberjack/CocoaLumberjack for more information.
 */

#import <Foundation/Foundation.h>

/**
 Options mask describing what log statements should show up.
 */
typedef NS_OPTIONS(NSInteger, BBLogFlag) {
    /**
     Only BBLogError() statements will show up.
     */
    BBLogFlagError = 1 << 0,
    /**
     BBLogWarning() and below statements will show up.
     */
    BBLogFlagWarning = 1 << 1,
    /**
     BBLogInfo() and below statements will show up.
     */
    BBLogFlagInfo = 1 << 2,
    /**
     BBLogDebug() and below statements will show up.
     */
    BBLogFlagDebug = 1 << 3,
    /**
     BBLogVerbose() and below statements will show up.
     */
    BBLogFlagVerbose = 1 << 4
};

/**
 Enum describing the current log level. This should be defined somewhere in your project as a static const variable named kBBLogLevel with the value equal to one of the below values.
 
 static NSInteger const kBBLogLevel = ...;
 */
typedef NS_ENUM(NSInteger, BBLogLevel) {
    /**
     Only error statements are logged.
     */
    BBLogLevelError = BBLogFlagError,
    /**
     Only warning and below statements are logged.
     */
    BBLogLevelWarning = BBLogLevelError | BBLogFlagWarning,
    /**
     Only info and below statements are logged.
     */
    BBLogLevelInfo = BBLogLevelWarning | BBLogFlagInfo,
    /**
     Only debug and below statements are logged.
     */
    BBLogLevelDebug = BBLogLevelInfo | BBLogFlagDebug,
    /**
     Only verbose and below statements are logged.
     */
    BBLogLevelVerbose = BBLogLevelDebug | BBLogFlagVerbose
};

#ifdef DEBUG

#define BBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

#ifdef BB_LOG_DISABLE_RELEASE_LOGGING
#define BBLog(...)
#else
#define BBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

#endif

#define BBLogObject(objectToLog) BBLog(@"%@",objectToLog)
#define BBLogCGRect(rectToLog) BBLogObject(NSStringFromCGRect(rectToLog))
#define BBLogCGSize(sizeToLog) BBLogObject(NSStringFromCGSize(sizeToLog))
#define BBLogCGPoint(pointToLog) BBLogObject(NSStringFromCGPoint(pointToLog))
#define BBLogCGFloat(floatToLog) BBLog(@"%f",floatToLog)

/**
 The variable name that should be used when defining the current log level.
 
 static NSInteger const kBBLogLevel = ...;
 */
#ifndef BB_LOG_LEVEL_DEF
#define BB_LOG_LEVEL_DEF kBBLogLevel
#endif

/**
 Macro used to check against the current log level and execute the log statement.
 
 This will throw an error if kBBLogLevel is not defined somewhere within your project.
 */
#define BBLogMaybe(lvl, flg, fmt, ...) \
    do {if (lvl & flg) {BBLog(fmt, ##__VA_ARGS__);}} while(0)

#define BBLogError(fmt, ...) BBLogMaybe(BB_LOG_LEVEL_DEF, BBLogFlagError, fmt, ##__VA_ARGS__)
#define BBLogWarning(fmt, ...) BBLogMaybe(BB_LOG_LEVEL_DEF, BBLogFlagWarning, fmt, ##__VA_ARGS__)
#define BBLogInfo(fmt, ...) BBLogMaybe(BB_LOG_LEVEL_DEF, BBLogFlagInfo, fmt, ##__VA_ARGS__)
#define BBLogDebug(fmt, ...) BBLogMaybe(BB_LOG_LEVEL_DEF, BBLogFlagDebug, fmt, ##__VA_ARGS__)
#define BBLogVerbose(fmt, ...) BBLogMaybe(BB_LOG_LEVEL_DEF, BBLogFlagVerbose, fmt, ##__VA_ARGS__)

/**
 Check to see if an environment variable is defined.
 
 if (BBIsEnvironmentVariableDefined(MY_ENVIRONMENT_VARIABLE)) {
    // do something
 }
 */
#define BBIsEnvironmentVariableDefined(environmentVariable) [NSProcessInfo processInfo].environment[[NSString stringWithUTF8String:(#environmentVariable)]]

#endif
