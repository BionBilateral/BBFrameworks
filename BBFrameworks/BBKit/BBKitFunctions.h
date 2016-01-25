//
//  BBKitFunctions.h
//  BBFrameworks
//
//  Created by William Towe on 1/24/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <UIKit/UIScreen.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Returns a new size after multiplying the width and height by the screen scale.
 
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
extern CGSize BBCGSizeAdjustedForScreenScale(CGSize size, UIScreen * _Nullable screen);

NS_ASSUME_NONNULL_END
