//
//  BBPickerButtonDataSource.h
//  BBFrameworks
//
//  Created by William Towe on 7/10/15.
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

NS_ASSUME_NONNULL_BEGIN

@class BBPickerButton;

/**
 Protocol for BBPickerButton data source.
 */
@protocol BBPickerButtonDataSource <NSObject>
@required
/**
 Return the number of rows in the provided component.
 
 @param pickerButton The picker button that sent the message
 @param component The component
 @return The number of rows
 */
- (NSInteger)pickerButton:(BBPickerButton *)pickerButton numberOfRowsInComponent:(NSInteger)component;
@optional
/**
 Return the number of components in the picker button.
 
 The default is 1.
 
 @param pickerButton The picker button that sent the message
 @return The number of components
 */
- (NSInteger)numberOfComponentsInPickerButton:(BBPickerButton *)pickerButton;

/**
 Return the title for the provided row and component.
 
 The default is @"".
 
 @param pickerButton The picker button that sent the message
 @param row The row
 @param component The component
 @return The title for row and component
 */
- (nullable NSString *)pickerButton:(BBPickerButton *)pickerButton titleForRow:(NSInteger)row forComponent:(NSInteger)component;
/**
 Return the attributed title for the provided row and component.
 
 If this method is implemented, it is preferred over `pickerButton:titleForRow:forComponent`.
 
 @param pickerButton The picker button that sent the message
 @param row The row
 @param component The component
 @return The attributed title for row and component
 */
- (nullable NSAttributedString *)pickerButton:(BBPickerButton *)pickerButton attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
@end

NS_ASSUME_NONNULL_END
