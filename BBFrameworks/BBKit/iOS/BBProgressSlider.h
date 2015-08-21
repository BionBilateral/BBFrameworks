//
//  BBProgressSlider.h
//  BBFrameworks
//
//  Created by William Towe on 8/21/15.
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
 BBProgressSlider is a UISlider subclass that displays a loading progress in addition to minimum and maximum track.
 */
@interface BBProgressSlider : UISlider

/**
 Set and get the progress of the receiver.
 */
@property (assign,nonatomic) float progress;

/**
 Set and get the minimum track fill color.
 
 The default is self.tintColor.
 */
@property (strong,nonatomic) UIColor *minimumTrackFillColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the maximum track fill color.
 
 The default is [UIColor lightGrayColor];
 */
@property (strong,nonatomic) UIColor *maximumTrackFillColor UI_APPEARANCE_SELECTOR;
/**
 Set and get the progress fill color.
 
 The default is [UIColor whiteColor];
 */
@property (strong,nonatomic) UIColor *progressFillColor UI_APPEARANCE_SELECTOR;

@end
