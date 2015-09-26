//
//  BBPickerButton.h
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

#import <UIKit/UIKit.h>
#import "BBPickerButtonDataSource.h"
#import "BBPickerButtonDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 BBPickerButton is a UIButton subclass that can become first responder and uses a UIPickerView as its input view. Tapping on a BBPickerButton will toggle its first responder status.
 */
@interface BBPickerButton : UIButton

/**
 Set and get the receiver's data source.
 
 @see BBPickerButtonDataSource
 */
@property (weak,nonatomic,nullable) id<BBPickerButtonDataSource> dataSource;
/**
 Set and get the receiver's delegate.
 
 @see BBPickerButtonDelegate
 */
@property (weak,nonatomic,nullable) id<BBPickerButtonDelegate> delegate;

/**
 Set and get the selected components join string of the receiver. This is used to join the title representing each selected row in the managed picker view together to set the title of the receiver.
 
 The default is @" ".
 */
@property (copy,nonatomic,nullable) NSString *selectedComponentsJoinString;

/**
 Reloads all components in the managed picker view.
 */
- (void)reloadData;

/**
 Returns the selected row for the give component.
 
 @param component The component
 @return The selected row
 */
- (NSInteger)selectedRowInComponent:(NSInteger)component;
/**
 Selects the row in the given component.
 
 @param row The row to select
 @param component The component
 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component;

/**
 Redefine input accessory view as readwrite.
 */
@property (nullable, nonatomic, readwrite, strong) __kindof UIView *inputAccessoryView;

@end

NS_ASSUME_NONNULL_END
