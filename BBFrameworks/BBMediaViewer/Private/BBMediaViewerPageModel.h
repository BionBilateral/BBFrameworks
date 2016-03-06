//
//  BBMediaViewerPageModel.h
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>
#import "BBMediaViewerMedia.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BBMediaViewerPageModelType) {
    BBMediaViewerPageModelTypeUnknown = 0,
    BBMediaViewerPageModelTypeImage,
    BBMediaViewerPageModelTypeImageAnimated,
    BBMediaViewerPageModelTypeMovie,
    BBMediaViewerPageModelTypePDF,
    BBMediaViewerPageModelTypeHTML,
    BBMediaViewerPageModelTypePlainText,
    BBMediaViewerPageModelTypeRTF,
    BBMediaViewerPageModelTypeRTFD,
    BBMediaViewerPageModelTypeDocument
};

@class BBMediaViewerModel;

@interface BBMediaViewerPageModel : NSObject

@property (readonly,strong,nonatomic) id<BBMediaViewerMedia> media;
@property (readonly,assign,nonatomic) BBMediaViewerPageModelType type;
@property (readonly,nonatomic) NSURL *URL;
@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) NSString *UTI;
@property (readonly,nonatomic) id activityItem;
@property (readonly,weak,nonatomic) BBMediaViewerModel *parentModel;

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel;

+ (BBMediaViewerPageModelType)typeForMedia:(id<BBMediaViewerMedia>)media;

@end

NS_ASSUME_NONNULL_END
