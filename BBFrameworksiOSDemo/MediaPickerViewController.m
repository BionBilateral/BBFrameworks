//
//  AssetsPickerViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "MediaPickerViewController.h"
#import "BBFoundationDebugging.h"

#import <BBFrameworks/BBMediaPicker.h>
#import <BBFrameworks/UIViewController+BBKitExtensions.h>
#import <BBFrameworks/BBKitColorMacros.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <objc/runtime.h>

@interface MediaPickerDoneButton : UIButton

@end

@implementation MediaPickerDoneButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor blackColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateDisabled];
    [self setTitle:@"Next" forState:UIControlStateNormal];
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(UIViewNoIntrinsicMetric, 44.0);
}

@end

@interface MediaPickerNavigationController : UINavigationController

@end

@implementation MediaPickerNavigationController

+ (void)initialize {
    if (self == [MediaPickerNavigationController class]) {
        
    }
}

@end

@interface AssetBackgroundView : UIView
@property (strong,nonatomic) UILabel *label;
@end

@implementation AssetBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [self.label setText:@"You don't have any media. Go add some!"];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.label];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:self.bounds];
}

@end

@interface MediaPickerViewController () <BBMediaPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *systemButton;
@property (weak,nonatomic) IBOutlet UIButton *customButton;
@property (weak,nonatomic) IBOutlet UIButton *customPushButton;
@end

@implementation MediaPickerViewController
#pragma mark *** Subclass Overrides ***
+ (void)initialize {
    if (self == [MediaPickerViewController class]) {
        
    }
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

+ (NSString *)rowClassTitle {
    return @"Media Picker";
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    BBLogObject(info);
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark BBMediaPickerViewControllerDelegate
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didSelectMedia:(id<BBMediaPickerMedia>)media {
    BBLogObject(media);
}
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didDeselectMedia:(id<BBMediaPickerMedia>)media {
    BBLogObject(media);
}
- (void)mediaPickerViewController:(BBMediaPickerViewController *)viewController didFinishPickingMedia:(NSArray<id<BBMediaPickerMedia>> *)media {
    BBLogObject(media);
    
    [self.class setSelectedMediaPickerMedia:media];
    
    if (viewController.presentingViewController) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [viewController.navigationController popToViewController:self animated:YES];
    }
}
- (void)mediaPickerViewControllerDidCancel:(BBMediaPickerViewController *)viewController {
    BBLog();
    
    if (viewController.presentingViewController) {
        [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [viewController.navigationController popToViewController:self animated:YES];
    }
}
#pragma mark *** Public Methods ***
static void *selectedMediaPickerMediaKey = &selectedMediaPickerMediaKey;

+ (NSArray<id<BBMediaPickerMedia>> *)selectedMediaPickerMedia; {
    return objc_getAssociatedObject(self, selectedMediaPickerMediaKey);
}
+ (void)setSelectedMediaPickerMedia:(NSArray<id<BBMediaPickerMedia>> *)selectedMediaPickerMedia; {
    objc_setAssociatedObject(self, selectedMediaPickerMediaKey, selectedMediaPickerMedia, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#pragma mark *** Private Methods ***
#pragma mark Actions
- (IBAction)_systemButtonAction:(id)sender {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [pickerController setAllowsEditing:NO];
    [pickerController setMediaTypes:@[(__bridge id)kUTTypeImage,(__bridge id)kUTTypeMovie]];
    [pickerController setDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}
- (IBAction)_customButtonAction:(id)sender {
    BBMediaPickerViewController *viewController = [[BBMediaPickerViewController alloc] init];
    
    [viewController setDelegate:self];
    [viewController setAllowsMultipleSelection:YES];
    
    BBMediaPickerTheme *theme = [[BBMediaPickerTheme alloc] init];
    
    [theme setAssetCollectionCellSubtitleColor:[UIColor orangeColor]];
    [theme setAssetBackgroundViewClass:[AssetBackgroundView class]];
    
    [viewController setTheme:theme];
    
    [self presentViewController:[[MediaPickerNavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
}
- (IBAction)_customPushButtonAction:(id)sender {
    BBMediaPickerViewController *viewController = [[BBMediaPickerViewController alloc] init];
    
    [viewController setDelegate:self];
    [viewController setAllowsMultipleSelection:YES];
    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL]];
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
