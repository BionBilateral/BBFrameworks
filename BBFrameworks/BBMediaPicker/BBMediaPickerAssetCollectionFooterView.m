//
//  BBMediaPickerAssetCollectionFooterView.m
//  BBFrameworks
//
//  Created by William Towe on 7/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionFooterView.h"
#import "BBMediaPickerAssetsGroupViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetCollectionFooterView ()
@property (strong,nonatomic) UILabel *titleLabel;
@end

@implementation BBMediaPickerAssetCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
    
    RAC(self.titleLabel,text) = RACObserve(self, viewModel.detailCountString);
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel setFrame:self.bounds];
}

+ (CGFloat)rowHeight {
    return 60.0;
}

@end
