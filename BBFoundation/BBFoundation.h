//
//  BBFoundation.h
//  BBFoundation
//
//  Created by William Towe on 11/12/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for BBFoundation.
FOUNDATION_EXPORT double BBFoundationVersionNumber;

//! Project version string for BBFoundation.
FOUNDATION_EXPORT const unsigned char BBFoundationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <BBFoundation/PublicHeader.h>

#import "BBFoundationDebugging.h"
#import "BBFoundationMacros.h"
#import "BBFoundationFunctions.h"
#import "BBFoundationGeometryFunctions.h"

#import "NSFileManager+BBFoundationExtensions.h"
#import "NSArray+BBFoundationExtensions.h"
#import "NSMutableArray+BBFoundationExtensions.h"
#import "NSData+BBFoundationExtensions.h"
#import "NSDate+BBFoundationExtensions.h"
#import "NSString+BBFoundationExtensions.h"
#import "NSBundle+BBFoundationExtensions.h"
#import "NSURL+BBFoundationExtensions.h"
#import "NSError+BBFoundationExtensions.h"
#import "NSObject+BBFoundationExtensions.h"
#import "NSSet+BBFoundationExtensions.h"
#import "NSDictionary+BBFoundationExtensions.h"
#import "NSHTTPURLResponse+BBFoundationExtensions.h"
#import "NSURLRequest+BBFoundationExtensions.h"

#import "BBSnakeCaseToLlamaCaseValueTransformer.h"
#import "BBTimer.h"
