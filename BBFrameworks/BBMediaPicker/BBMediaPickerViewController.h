//
//  BBMediaPickerViewController.h
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

#import <UIKit/UIKit.h>
#import "BBMediaPickerDefines.h"
#import "BBMediaPickerViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class BBMediaPickerTheme;

/**
 BBMediaPickerViewController is a UIViewController subclass that provides an interface for browsing and selecting the user's media.
 */
@interface BBMediaPickerViewController : UIViewController

/**
 Set and get the delegate of the media picker.
 
 @see BBMediaPickerViewControllerDelegate
 */
@property (weak,nonatomic,nullable) id<BBMediaPickerViewControllerDelegate> delegate;

/**
 Set and get the theme of the media picker.
 
 The default is [BBMediaPickerTheme defaultTheme].
 */
@property (strong,nonatomic,null_resettable) BBMediaPickerTheme *theme;

/**
 Set and get whether the media picker allows the user to select multiple assets.
 
 The default is NO.
 */
@property (assign,nonatomic) BOOL allowsMultipleSelection;
/**
 Set and get whether the media picker hides asset collections that are empty (i.e. they contain 0 assets).
 
 The default is YES.
 */
@property (assign,nonatomic) BOOL hidesEmptyAssetCollections;

/**
 Set and get the media types the media picker should display. For example, if set to BBMediaPickerMediaTypesImage, the user would only see available photos.
 
 The default is BBMediaPickerMediaTypesAll.
 */
@property (assign,nonatomic) BBMediaPickerMediaTypes mediaTypes;

/**
 Set and get the initially selected asset collection subtype. If found, this asset collection will be selected when presenting the media picker.
 
 The default is BBMediaPickerAssetCollectionSubtypeSmartAlbumUserLibrary when using the Photos framework and BBMediaPickerAssetCollectionSubtypeSavedPhotos when using the AssetsLibrary framework.
 */
@property (assign,nonatomic) BBMediaPickerAssetCollectionSubtype initiallySelectedAssetCollectionSubtype;
/**
 Set and get the allowed asset collection subtypes. If non-nil, the displayed asset collections will be constrained to this set.
 
 The default is nil.
 */
@property (copy,nonatomic,nullable) NSSet<NSNumber *> *allowedAssetCollectionSubtypes;

/**
 Get the current authorization status.
 
 @see BBMediaPickerAuthorizationStatus
 */
+ (BBMediaPickerAuthorizationStatus)authorizationStatus;
/**
 Request authorization to access the user's media and invoke the provided completion block once the authorization status is determined. The completion block is always invoked on the main thread.
 
 @param completion The completion block to invoke when the operation is complete
 */
+ (void)requestAuthorizationWithCompletion:(nullable void(^)(BBMediaPickerAuthorizationStatus status))completion;

/**
 Get the count of media for the selected asset collection.
 
 @return The count of media
 */
- (NSUInteger)countOfMedia;
/**
 Get the index of the provided media within the selected asset collection. If the media cannot be found, returns NSNotFound.
 
 @param media The media for which to return the index of
 @return The index of the provided media or NSNotFound
 */
- (NSUInteger)indexOfMedia:(id<BBMediaPickerMedia>)media;
/**
 Get the media at the provided index within the selected asset collection. If the index is out of bounds, nil is returned.
 
 @param index The index of the media to return
 @return The media or nil
 */
- (nullable id<BBMediaPickerMedia>)mediaAtIndex:(NSUInteger)index;
/**
 Scrolls the provided media so it is visible within the asset collection view.
 
 @param media The media to scroll to visible
 */
- (void)scrollMediaToVisible:(id<BBMediaPickerMedia>)media;

@end

NS_ASSUME_NONNULL_END
