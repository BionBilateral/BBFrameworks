//
//  ALAssetsGroup+BBMediaPickerExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 12/1/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ALAssetsGroup+BBMediaPickerExtensions.h"
#import "ALAsset+BBMediaPickerExtensions.h"

@implementation ALAssetsGroup (BBMediaPickerExtensions)

- (NSString *)BB_identifier; {
    return [(NSURL *)[self valueForProperty:ALAssetsGroupPropertyURL] absoluteString];
}
- (nullable ALAsset *)BB_assetAtIndex:(NSUInteger)index; {
    if ([self numberOfAssets] <= index) {
        return nil;
    }
    
    __block ALAsset *retval = nil;
    
    [self enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:index] options:0 usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            retval = result;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSUInteger)BB_indexOfAsset:(ALAsset *)asset; {
    __block NSInteger retval = NSNotFound;
    
    [self enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if ([[result BB_identifier] isEqualToString:[asset BB_identifier]]) {
            retval = index;
            *stop = YES;
        }
    }];
    
    return retval;
}

@end
