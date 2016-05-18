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

/**
 BBMediaPickerTheme is a NSObject allows the client to customize the appearance and behavior of the media picker classes without using the appearance proxy methods.
 */
@interface BBMediaPickerTheme : NSObject <NSCopying>

/**
 Set and get the name of the theme. Useful for debugging.
 */
@property (copy,nonatomic) NSString *name;
/**
 Set and get the title font, which is used to display the name of the selected asset collection in the navigation bar.
 
 The default is [UIFont boldSystemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *titleFont;
/**
 Set and get the title color.
 
 The default is [UIColor blackColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *titleColor;
/**
 Set and get the subtitle font, which is used to display descriptive text telling the user to tap in order to change the selected asset collection.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *subtitleFont;
/**
 Set and get the subtitle color.
 
 The default is [UIColor darkGrayColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *subtitleColor;
/**
 Set and get the title view class, which is instantiated and set as the navigation item's `titleView` property. A default class is provided, but if a custom class is set, instances must conform to the BBMediaPickerTitleView protocol.
 
 @see BBMediaPickerTitleView
 */
@property (strong,nonatomic,null_resettable) Class titleViewClass;
/**
 Set and get the cancel bar button item. In single selection selection mode, the bar button item is displayed on the right hand side. In multiple selection mode, the bar button item is displayed on the left hand side. If cancelBottomAccessoryControlClass is non-nil, the bar button item is not displayed.
 
 The default is the standard system cancel bar button item.
 
 @see cancelBottomAccessoryControlClass
 */
@property (strong,nonatomic,nullable) UIBarButtonItem *cancelBarButtonItem;
/**
 Set and get the done bar button item. In single selection mode, the item is not displayed. In multiple selection mode, the item is displayed on the right hand side. If doneBottomAccessoryControlClass is non-nil, the bar button item is not displayed.
 
 The default is the standard system done bar button item.
 
 @see doneBottomAccessoryControlClass
 */
@property (strong,nonatomic,nullable) UIBarButtonItem *doneBarButtonItem;
/**
 Set and get the cancel bottom accessory control class, which should be a subclass of UIControl. If non-nil, an instance of the class is displayed at the bottom of the asset grid view and the cancel bar button item is not displayed. The class should implement sizeThatFits: to provide an appropriate height.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class cancelBottomAccessoryControlClass;
/**
 Set and get the done bottom accessory control class, which should be a subclass of UIControl. If non-nil, an instance of the class is displayed at the bottom of the asset grid view and the done bar button item is not displayed. The class should implement sizeThatFits: to provide an appropriate height.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class doneBottomAccessoryControlClass;
/**
 Set and get the selection border width used to draw selection chrome for selected assets and asset collections.
 
 The default is 3.0;
 */
@property (assign,nonatomic) CGFloat selectionBorderWidth;

/**
 Set and get the asset collection background color, which is used to tint the content overlay when presenting the asset collection popover.
 
 The default is [[UIColor blackColor] colorWithAlphaComponent:0.5].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionBackgroundColor;
/**
 Set and get the asset collection cell background color, which is used to fill the background of each cell displaying an asset collection.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellBackgroundColor;
/**
 Set and get the asset collection scroll view indicator style. It might be useful to set this to ensure the scroll view indicator is still visible when other properties are customized.
 */
@property (assign,nonatomic) UIScrollViewIndicatorStyle assetCollectionScrollViewIndicatorStyle;
/**
 Set and get the asset collection cell title font, which is used to display the name of the asset collection.
 
 The default is [UIFont systemFontOfSize:17.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellTitleFont;
/**
 Set and get the asset collection cell title color.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellTitleColor;
/**
 Set and get the asset collection cell subtitle font, which is used to display the number of assets in the asset collection.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *assetCollectionCellSubtitleFont;
/**
 Set and get the asset collection cell subtitle color.
 
 The default is [UIColor lightGrayColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionCellSubtitleColor;
/**
 Set and get the asset collection cell checkmark color, which is displayed in the row representing the selected asset collection.
 
 The default is the default view tint color.
 */
@property (strong,nonatomic,nullable) UIColor *assetCollectionCellCheckmarkColor;
/**
 Set and get the asset collection cell accessory image, which, if non-nil, is displayed in the row representing the selected asset collection.
 
 The default is nil.
 */
@property (strong,nonatomic,nullable) UIImage *assetCollectionCellAccessoryImage;
/**
 Set and get the asset collection foreground color, which is used to render the various type images (e.g. image, video).
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionForegroundColor;
/**
 Set and get the asset collection separator color, which is used as the separator color for the asset collection table view.
 
 The default is [UIColor lightGrayColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionSeparatorColor;
/**
 Set and get the asset collection separator edge insets, which are used as the separator insets for the asset collection table view.
 
 The default is UIEdgeInsetsMake(0, 8.0, 0, 0).
 */
@property (assign,nonatomic) UIEdgeInsets assetCollectionSeparatorEdgeInsets;
/**
 Set and get the asset collection popover background, which is used to fill the popover view that contains the asset collection table view.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetCollectionPopoverBackgroundColor;
/**
 Set and get the asset collection popover background edge insets, which are used when laying out the popover relative to the title view in the navigation bar.
 
 The default is UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0);
 */
@property (assign,nonatomic) UIEdgeInsets assetCollectionPopoverBackgroundEdgeInsets;
/**
 Set and get the asset collection popover arrow width, which is used when drawing the popover arrow attached to the asset collection popover view.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat assetCollectionPopoverArrowWidth;
/**
 Set and get the asset collection popover arrow height.
 
 The default is 8.0.
 */
@property (assign,nonatomic) CGFloat assetCollectionPopoverArrowHeight;
/**
 Set and get the asset collection popover corner radius, which determines the roundness of the popover background view.
 
 The default is 5.0.
 */
@property (assign,nonatomic) CGFloat assetCollectionPopoverCornerRadius;

/**
 Set and get the asset background color, which is used as the background color of the asset collection view.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetBackgroundColor;
/**
 Set and get the asset scroll view indicator style. It might be useful to set this to ensure the scroll view indicator is still visible when other properties are customized.
 */
@property (assign,nonatomic) UIScrollViewIndicatorStyle assetScrollViewIndicatorStyle;
/**
 Set and get the asset background view class, which is used as the `backgroundView` of the asset collection view and is only visible when the user has no assets in the selected asset collection. The Class should be a subclass of UIView.
 
 The default is Nil.
 */
@property (strong,nonatomic,nullable) Class assetBackgroundViewClass;
/**
 Set and get the asset minimum interitem spacing, which is used to set the minimumInteritemSpacing on the collection view layout of the collection view that displays assets.
 
 The default is 1.0.
 */
@property (assign,nonatomic) CGFloat assetMinimumInteritemSpacing;
/**
 Set and get the asset minimum line spacing, which is used to set the minimumLineSpacing on the collection view layout of the collection view that displays assets.
 
 The default is 1.0.
 */
@property (assign,nonatomic) CGFloat assetMinimumLineSpacing;

/**
 Set and get the asset selected overlay view class, which is responsible for drawing the relevant chrome for selected assets. A default class is provided, but if a custom class is set, instances must conform to the BBMediaPickerAssetSelectedOverlayView protocol.
 
 @see BBMediaPickerAssetSelectedOverlayView
 */
@property (strong,nonatomic,null_resettable) Class assetSelectedOverlayViewClass;
/**
 Set and get the assets selected overlay view tint color, which the default class uses to draw the selection chrome.
 
 The default is the view tint color.
 */
@property (strong,nonatomic,null_resettable) UIColor *assetSelectedOverlayViewTintColor;
/**
 Set and get the assets selected overlay selected index font used to draw the index number in the top right corner of the view.
 
 The default is [UIFont boldSystemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *assetSelectedOverlayViewSelectedIndexFont;
/**
 Set and get the colors used to draw the bottom gradient view that is visible when a video asset is being displayed. The colors are drawn from top to bottom.
 
 The default is @[BBColorWA(0.0, 0.5),BBColorWA(0.0, 0.75)].
 */
@property (copy,nonatomic,null_resettable) NSArray<UIColor *> *assetBottomGradientColors;
/**
 Set and get the asset type video image, which is used to badge video assets in the collection view.
 
 The default is [UIImage BB_imageInResourcesBundleNamed:@"media_picker_type_video"].
 */
@property (strong,nonatomic,null_resettable) UIImage *assetTypeVideoImage;
/**
 Set and get the asset foreground color, which is used to render the various type images.
 
 The default is [UIColor whiteColor].
 */
@property (strong,nonatomic,null_resettable) UIColor *assetForegroundColor;
/**
 Set and get the asset duration font, which is used when displaying the duration of a video assets in the bottom right corner of the collection view cell.
 
 The default is [UIFont systemFontOfSize:12.0].
 */
@property (strong,nonatomic,null_resettable) UIFont *assetDurationFont;

/**
 Get the default theme, which is initialized with the default values described above.
 */
+ (instancetype)defaultTheme;

@end

NS_ASSUME_NONNULL_END
