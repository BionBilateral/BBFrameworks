//
//  BBMediaPickerAssetViewModel.m
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

#import "BBMediaPickerAssetViewModel.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBFoundationDebugging.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BBMediaPickerAssetViewModel ()
@property (readwrite,strong,nonatomic) ALAsset *asset;
@end

@implementation BBMediaPickerAssetViewModel
#pragma mark *** Subclass Overrides ***
#pragma mark BBMediaPickerMedia
- (NSURL *)mediaURL {
    return self.URL;
}
- (int64_t)mediaSize {
    return self.asset.defaultRepresentation.size;
}
- (NSData *)mediaData {
    uint8_t *buffer = malloc((size_t)self.mediaSize);
    NSError *outError;
    NSUInteger retval = [self.asset.defaultRepresentation getBytes:buffer fromOffset:0 length:(NSUInteger)self.mediaSize error:&outError];
    
    if (retval == 0) {
        BBLogObject(outError);
        free(buffer);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:buffer length:retval freeWhenDone:YES];
}
- (NSData *)mediaDataFromOffset:(int64_t)offset max:(NSUInteger)max; {
    int64_t size = self.mediaSize - offset;
    
    if (size > max) {
        size = max;
    }
    
    uint8_t *buffer = malloc((size_t)size);
    NSError *outError;
    NSUInteger retval = [self.asset.defaultRepresentation getBytes:buffer fromOffset:offset length:(NSUInteger)size error:&outError];
    
    if (retval == 0) {
        BBLogObject(outError);
        free(buffer);
        return nil;
    }
    
    return [NSData dataWithBytesNoCopy:buffer length:retval freeWhenDone:YES];
}
- (UIImage *)mediaThumbnailImage {
    return self.thumbnailImage;
}
- (UIImage *)mediaImage {
    return [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage];
}
#pragma mark *** Public Methods ***
- (instancetype)initWithAsset:(ALAsset *)asset; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(asset);
    
    [self setAsset:asset];
    
    return self;
}
#pragma mark Properties
- (NSURL *)URL {
    return [self.asset valueForProperty:ALAssetPropertyAssetURL];
}
- (BBMediaPickerAssetViewModelType)type {
    NSString *typeString = [self.asset valueForProperty:ALAssetPropertyType];
    
    if ([typeString isEqualToString:ALAssetTypePhoto]) {
        return BBMediaPickerAssetViewModelTypePhoto;
    }
    else if ([typeString isEqualToString:ALAssetTypeVideo]) {
        return BBMediaPickerAssetViewModelTypeVideo;
    }
    else {
        return BBMediaPickerAssetViewModelTypeUnknown;
    }
}
- (UIImage *)typeImage {
    return self.type == BBMediaPickerAssetViewModelTypeVideo ? [UIImage BB_imageInResourcesBundleNamed:@"media_picker_type_video"] : nil;
}
- (NSString *)durationString {
    if (self.type == BBMediaPickerAssetViewModelTypeVideo) {
        NSTimeInterval duration = [[self.asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:duration];
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date] toDate:[NSDate dateWithTimeIntervalSinceNow:duration] options:0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        if (comps.hour > 0) {
            [dateFormatter setDateFormat:@"H:mm:ss"];
        }
        else {
            [dateFormatter setDateFormat:@"m:ss"];
        }
        
        date = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        return [dateFormatter stringFromDate:date];
    }
    return nil;
}
- (UIImage *)thumbnailImage {
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

@end
