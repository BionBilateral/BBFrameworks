//
//  BBTextCustomValidator.h
//  BBFrameworks
//
//  Created by William Towe on 7/26/15.
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
#import "BBTextValidator.h"

@class BBTextCustomValidator;

/**
 Block that is invoked to validate the text whenever it changes.
 
 @param The validator invoking the block
 @param text The text to validate
 @param error A pointer to an NSError object, return an error by reference if returning NO
 @return YES if the text validates, otherwise NO
 */
typedef BOOL(^BBTextCustomValidatorBlock)(BBTextCustomValidator *validator, NSString *text, NSError **error);

/**
 BBTextCustomValidator is a NSObject subclass that provides custom validation via its validatorBlock.
 */
@interface BBTextCustomValidator : NSObject <BBTextValidator>

/**
 Set and get the text validator right view of the receiver. Set this before returning from validatorBlock to have the current view displayed if returning NO from validatorBlock.
 */
@property (strong,nonatomic) UIView *textValidatorRightView;

/**
 Designated Initializer.
 
 @param validatorBlock The validator block that will be invoked whenever the text to validate changes
 @return An initialized instance of the receiver
 */
- (instancetype)initWithValidatorBlock:(BBTextCustomValidatorBlock)validatorBlock NS_DESIGNATED_INITIALIZER;

@end