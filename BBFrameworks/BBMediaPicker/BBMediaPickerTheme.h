//
//  BBMediaPickerTheme.h
//  BBFrameworks
//
//  Created by William Towe on 11/16/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
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

@interface BBMediaPickerTheme : NSObject

@property (strong,nonatomic,null_resettable) UIFont *titleFont;
@property (strong,nonatomic,null_resettable) UIColor *titleColor;
@property (strong,nonatomic,null_resettable) UIFont *subtitleFont;
@property (strong,nonatomic,null_resettable) UIColor *subtitleColor;

@property (strong,nonatomic,null_resettable) UIColor *assetCollectionBackgroundColor;
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellBackgroundColor;
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellTitleFont;
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellTitleColor;
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellSubtitleFont;
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellSubtitleColor;
@property (strong,nonatomic,nullable) UIColor *assetCollectionCellCheckmarkColor;

@property (strong,nonatomic,null_resettable) UIColor *assetBackgroundColor;
@property (strong,nonatomic,null_resettable) Class assetSelectedOverlayViewClass;

+ (instancetype)defaultTheme;

@end

NS_ASSUME_NONNULL_END
