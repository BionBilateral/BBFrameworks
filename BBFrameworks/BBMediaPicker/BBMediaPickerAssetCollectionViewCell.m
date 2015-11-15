//
//  BBMediaPickerAssetCollectionViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 11/13/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetCollectionViewCell.h"
#import "BBMediaPickerAssetModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerAssetDefaultSelectedOverlayView.h"
#import "UIImage+BBKitExtensions.h"

#import <Photos/Photos.h>

@interface BBMediaPickerAssetCollectionViewCell ()
@property (weak,nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak,nonatomic) IBOutlet UIImageView *typeImageView;

@property (readwrite,strong,nonatomic) UIView<BBMediaPickerAssetSelectedOverlayView> *selectedOverlayView;

+ (NSString *)_defaultSelectedOverlayViewClassName;
@end

@implementation BBMediaPickerAssetCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _selectedOverlayViewClassName = [self.class _defaultSelectedOverlayViewClassName];
    
    [self setSelectedOverlayView:[[NSClassFromString(_selectedOverlayViewClassName) alloc] initWithFrame:CGRectZero]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_model cancelAllThumbnailRequests];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.selectedOverlayView setAlpha:selected ? 1.0 : 0.0];
}

- (void)reloadSelectedOverlayView; {
    if ([self.selectedOverlayView respondsToSelector:@selector(setSelectedIndex:)]) {
        [self.selectedOverlayView setSelectedIndex:_model.selectedIndex];
    }
}

- (void)setModel:(BBMediaPickerAssetModel *)model {
    _model = model;
    
    [self.typeImageView setImage:[_model.typeImage BB_imageByRenderingWithColor:[UIColor whiteColor]]];
    
    if ([self.selectedOverlayView respondsToSelector:@selector(setSelectedIndex:)]) {
        [self.selectedOverlayView setSelectedIndex:_model.selectedIndex];
    }
    
    BBWeakify(self);
    [_model requestThumbnailImageOfSize:self.thumbnailImageView.frame.size completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailImageView setImage:thumbnailImage];
    }];
}

- (void)setSelectedOverlayViewClassName:(NSString *)selectedOverlayViewClassName {
    _selectedOverlayViewClassName = selectedOverlayViewClassName ?: [self.class _defaultSelectedOverlayViewClassName];
    
    [self setSelectedOverlayView:[[NSClassFromString(_selectedOverlayViewClassName) alloc] initWithFrame:CGRectZero]];
}

- (void)setSelectedOverlayView:(UIView<BBMediaPickerAssetSelectedOverlayView> *)selectedOverlayView {
    [_selectedOverlayView removeFromSuperview];
    
    _selectedOverlayView = selectedOverlayView;
    
    [_selectedOverlayView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_selectedOverlayView setAlpha:self.isSelected ? 1.0 : 0.0];
    [self.contentView addSubview:_selectedOverlayView];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view": _selectedOverlayView}]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view": _selectedOverlayView}]];
}

+ (NSString *)_defaultSelectedOverlayViewClassName {
    return NSStringFromClass([BBMediaPickerAssetDefaultSelectedOverlayView class]);
}

@end
