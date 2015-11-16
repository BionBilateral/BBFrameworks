//
//  BBMediaPickerAssetCollectionTableViewCell.m
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

#import "BBMediaPickerAssetCollectionTableViewCell.h"
#import "BBMediaPickerAssetCollectionThumbnailView.h"
#import "BBFrameworksMacros.h"
#import "UIImage+BBKitExtensions.h"
#import "BBMediaPickerTheme.h"
#import "BBMediaPickerModel.h"
#import "BBKeyValueObserving.h"

@interface BBMediaPickerAssetCollectionTableViewCell ()
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView1;
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView2;
@property (weak,nonatomic) IBOutlet BBMediaPickerAssetCollectionThumbnailView *thumbnailView3;
@property (weak,nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet UILabel *subtitleLabel;
@end

@implementation BBMediaPickerAssetCollectionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self BB_addObserverForKeyPath:@BBKeypath(self,model.model.theme) options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        if (!self.model.model) {
            return;
        }
        
        [self setBackgroundColor:self.model.model.theme.assetCollectionCellBackgroundColor];
        
        [self.titleLabel setFont:self.model.model.theme.assetCollectionCellTitleFont];
        [self.titleLabel setTextColor:self.model.model.theme.assetCollectionCellTitleColor];
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_model cancelAllThumbnailRequests];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setAccessoryType:selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
}

- (void)setModel:(BBMediaPickerAssetCollectionModel *)model {
    _model = model;
    
    [self.titleLabel setText:_model.title];
    [self.subtitleLabel setText:_model.subtitle];
    [self.typeImageView setImage:[_model.typeImage BB_imageByRenderingWithColor:[UIColor whiteColor]]];
    
    BBWeakify(self);
    [_model requestFirstThumbnailImageOfSize:self.thumbnailView1.frame.size completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView1.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestSecondThumbnailImageOfSize:self.thumbnailView2.frame.size completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView2.thumbnailImageView setImage:thumbnailImage];
    }];
    
    [_model requestThirdThumbnailImageOfSize:self.thumbnailView3.frame.size completion:^(UIImage *thumbnailImage) {
        BBStrongify(self);
        [self.thumbnailView3.thumbnailImageView setImage:thumbnailImage];
    }];
}

+ (CGFloat)rowHeight; {
    return 60.0;
}

@end
