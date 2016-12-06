//
//  UIView+BBDynamicTypeExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 12/5/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol describing a dynamic type view that can be passed to BB_registerDynamicTypeView:forTextStyle: and BB_unregisterDynamicTypeView:.
 */
@protocol BBDynamicTypeView <NSObject>
@required
/**
 Sets the dynamic type font of the receiver. The receiver should then update itself and any dependent objects with the new value.
 
 @param dynamicTypeFont The new dynamic type font
 */
- (void)BB_setDynamicTypeFont:(UIFont *)dynamicTypeFont;
@end

/**
 Category on UILabel ensuring it conforms to the BBDynamicTypeView protocol.
 */
@interface UILabel (BBDynamicTypeExtensions) <BBDynamicTypeView>
@end

/**
 Category on UIButton ensuring it conforms to the BBDynamicTypeView protocol.
 */
@interface UIButton (BBDynamicTypeExtensions) <BBDynamicTypeView>
@end

/**
 Category on UITextField ensuring it conforms to the BBDynamicTypeView protocol.
 */
@interface UITextField (BBDynamicTypeExtensions) <BBDynamicTypeView>
@end

/**
 Category on UITextView ensuring it conforms to the BBDynamicTypeView protocol.
 */
@interface UITextView (BBDynamicTypeExtensions) <BBDynamicTypeView>
@end

/**
 Category on NSObject allowing objects conforming to the BBDynamicTypeView protocol to register and unregister for dynamic type notifications.
 */
@interface NSObject (BBDynamicTypeExtensions)

/**
 Register the dynamic type view for dynamic type notifications for the provided text style.
 
 @param dynamicTypeView The dynamic type view to register
 @param textStyle The text style to register for
 */
+ (void)BB_registerDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView forTextStyle:(UIFontTextStyle)textStyle;
/**
 Unregister the dynamic type view for dynamic type notifications.
 
 @param dynamicTypeView The dynamic type view to unregister
 */
+ (void)BB_unregisterDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView;

@end

NS_ASSUME_NONNULL_END
