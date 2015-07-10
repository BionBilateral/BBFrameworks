//
//  BBTextField.h
//  BBFrameworks
//
//  Created by William Towe on 7/9/15.
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

/**
 BBTextField is a UITextField subclass that adds edge insets related methods to control the placement of text. This eliminates the need to use padding views as the left and right views of the receiver.
 */
@interface BBTextField : UITextField

/**
 Set and get the text edge insets of the receiver. This value affects the return values of textRectForBounds: and editingRectForBounds:.
 
 The default is UIEdgeInsetsZero.
 */
@property (assign,nonatomic) UIEdgeInsets textEdgeInsets UI_APPEARANCE_SELECTOR;

/**
 Set and get the left view edge insets of the receiver. This value affects the return value of leftViewRectForBounds:.
 
 The default is UIEdgeInsetsZero.
 */
@property (assign,nonatomic) UIEdgeInsets leftViewEdgeInsets UI_APPEARANCE_SELECTOR;
/**
 Set and get the right view edge insets of the receiver. This value affects the return value of rightViewRectForBounds:.
 
 The default is UIEdgeInsetsZero.
 */
@property (assign,nonatomic) UIEdgeInsets rightViewEdgeInsets UI_APPEARANCE_SELECTOR;

@end
