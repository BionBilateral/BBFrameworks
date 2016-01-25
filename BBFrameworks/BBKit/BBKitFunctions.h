//
//  BBKitFunctions.h
//  BBFrameworks
//
//  Created by William Towe on 1/24/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <TargetConditionals.h>
#if (TARGET_OS_IPHONE)
#import <UIKit/UIScreen.h>
#else
#import <AppKit/NSScreen.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Returns a new size after multiplying the width and height by the main screen scale.
 
 @param The size to adjust
 @return The new size
 */
extern CGSize BBCGSizeAdjustedForMainScreenScale(CGSize size);
/**
 Returns a new size after multiplying the width and height by the screen scale.
 
 @param The size to adjust
 @param screen The screen to adjust for, passing nil will use [UIScreen mainScreen]
 @return The new size
 */
#if (TARGET_OS_IPHONE)
extern CGSize BBCGSizeAdjustedForScreenScale(CGSize size, UIScreen * _Nullable screen);
#else
extern CGSize BBCGSizeAdjustedForScreenScale(CGSize size, NSScreen * _Nullable screen);
#endif

NS_ASSUME_NONNULL_END
