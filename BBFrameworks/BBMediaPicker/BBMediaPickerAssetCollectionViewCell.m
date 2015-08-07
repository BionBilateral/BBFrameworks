//
//  BBMediaPickerAssetCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 7/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetViewModel.h"
#import "BBKitColorMacros.h"
#import "BBFoundationGeometryFunctions.h"
#import "UIImage+BBKitExtensions.h"
#import "BBGradientView.h"
#import "BBMediaPickerAssetCollectionViewCellSelectedOverlayView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static CGFloat const kSubviewMarginHalf = 4.0;

@interface BBMediaPickerAssetCollectionViewCell ()
@property (strong,nonatomic) UIImageView *thumbnailImageView;
@property (strong,nonatomic) BBGradientView *gradientView;
@property (strong,nonatomic) UIImageView *typeImageView;
@property (strong,nonatomic) UILabel *durationLabel;
@property (strong,nonatomic) UIView *selectedOverlayView;

+ (NSString *)_defaultSelectedOverlayViewClassName;
@end

@implementation BBMediaPickerAssetCollectionViewCell
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    _selectedOverlayViewClassName = [self.class _defaultSelectedOverlayViewClassName];
    
    [self setThumbnailImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.thumbnailImageView];
    
    [self setGradientView:[[BBGradientView alloc] initWithFrame:CGRectZero]];
    [self.gradientView setColors:@[BBColorWA(0.0, 0.0),BBColorWA(0.0, 1.0)]];
    [self.contentView addSubview:self.gradientView];
    
    [self setTypeImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.typeImageView];
    
    [self setDurationLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.durationLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.durationLabel setTextColor:[UIColor whiteColor]];
    [self.durationLabel setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.durationLabel];
    
    [self setSelectedOverlayView:[[NSClassFromString(_selectedOverlayViewClassName) alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.selectedOverlayView];
    
    @weakify(self);
    RAC(self.thumbnailImageView,image) = RACObserve(self, viewModel.thumbnailImage);
    RAC(self.gradientView,alpha) = [RACObserve(self, viewModel.typeImage)
                                    map:^id(id value) {
                                        return value ? @1.0 : @0.0;
                                    }];
    RAC(self.typeImageView,image) = [[RACObserve(self, viewModel.typeImage)
                                      map:^id(UIImage *value) {
                                          return [value BB_imageByRenderingWithColor:[UIColor whiteColor]];
                                      }]
                                     doNext:^(id _) {
                                         @strongify(self);
                                         [self setNeedsLayout];
                                     }];
    RAC(self.durationLabel,text) = RACObserve(self, viewModel.durationString);
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.thumbnailImageView setFrame:self.contentView.bounds];
    [self.typeImageView setFrame:CGRectMake(kSubviewMarginHalf, CGRectGetHeight(self.contentView.bounds) - self.typeImageView.image.size.height - kSubviewMarginHalf, self.typeImageView.image.size.width, self.typeImageView.image.size.height)];
    [self.durationLabel setFrame:CGRectMake(CGRectGetMaxX(self.typeImageView.frame), CGRectGetHeight(self.contentView.bounds) - ceil(self.durationLabel.font.lineHeight) - kSubviewMarginHalf, CGRectGetWidth(self.contentView.bounds) - CGRectGetMaxX(self.typeImageView.frame) - kSubviewMarginHalf, ceil(self.durationLabel.font.lineHeight))];
    [self.gradientView setFrame:CGRectMake(0, CGRectGetHeight(self.contentView.bounds) - self.typeImageView.image.size.height - kSubviewMarginHalf - kSubviewMarginHalf, CGRectGetWidth(self.contentView.bounds), self.typeImageView.image.size.height + kSubviewMarginHalf + kSubviewMarginHalf)];
    [self.selectedOverlayView setFrame:self.contentView.bounds];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.selectedOverlayView setAlpha:selected ? 1.0 : 0.0];
    
//    if ([self.selectedOverlayView respondsToSelector:@selector(setHighlighted:)]) {
//        [(id)self.selectedOverlayView setHighlighted:selected];
//    }
}
#pragma mark *** Public Methods ***
- (void)setSelectedOverlayViewClassName:(NSString *)selectedOverlayViewClassName {
    _selectedOverlayViewClassName = [selectedOverlayViewClassName ?: [self.class _defaultSelectedOverlayViewClassName] copy];
    
    if (![self.selectedOverlayView isKindOfClass:NSClassFromString(_selectedOverlayViewClassName)]) {
        [self.selectedOverlayView removeFromSuperview];
        
        [self setSelectedOverlayView:[[NSClassFromString(_selectedOverlayViewClassName) alloc] initWithFrame:CGRectZero]];
        [self.contentView addSubview:self.selectedOverlayView];
    }
}
#pragma mark *** Private Methods ***
+ (NSString *)_defaultSelectedOverlayViewClassName {
    return NSStringFromClass([BBMediaPickerAssetCollectionViewCellSelectedOverlayView class]);
}

@end
