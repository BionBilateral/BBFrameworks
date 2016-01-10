//
//  BBMediaEditorViewController.h
//  BBFrameworks
//
//  Created by Jason Anderson on 1/10/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBMediaEditorViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 BBMediaEditorViewController is a UIViewController subclass that takes a BBMediaPickerMedia object and provides controls for scaling and cropping.
 */
@interface BBMediaEditorViewController : UIViewController

/**
 Set and get the delegate of the media editor
 */
@property (weak,nonatomic,nullable) id<BBMediaEditorViewControllerDelegate> delegate;

- (instancetype)initWithCropSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius media:(id<BBMediaPickerMedia>)media NS_DESIGNATED_INITIALIZER;

- (instancetype)init __attribute__((unavailable("use initWithCropSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius media:(id<BBMediaPickerMedia>)media instead")));
- (instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("use initWithCropSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius media:(id<BBMediaPickerMedia>)media instead")));
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil __attribute__((unavailable("use initWithCropSize:(CGSize)size cornerRadius:(CGFloat)cornerRadius media:(id<BBMediaPickerMedia>)media instead")));
@end

NS_ASSUME_NONNULL_END
