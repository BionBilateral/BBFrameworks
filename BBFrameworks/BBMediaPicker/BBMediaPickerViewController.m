//
//  BBMediaPickerViewController.m
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

#import "BBMediaPickerViewController.h"
#import "BBMediaPickerModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaPickerDefaultTitleView.h"
#import "BBKeyValueObserving.h"
#import "BBMediaPickerAssetCollectionsViewController.h"

@interface BBMediaPickerViewController ()
@property (strong,nonatomic) BBMediaPickerModel *model;

@property (assign,nonatomic) BOOL hasRequestedPhotosAccess;
@end

@implementation BBMediaPickerViewController

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setModel:[[BBMediaPickerModel alloc] init]];
    BBWeakify(self);
    [self.model setCancelBarButtonItemActionBlock:^{
        BBStrongify(self);
        if (self.presentingViewController) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            [self.navigationController popToViewController:self.navigationController.viewControllers[[self.navigationController.viewControllers indexOfObject:self] - 1] animated:YES];
        }
    }];
    
    [self setTitleView:[[BBMediaPickerDefaultTitleView alloc] initWithFrame:CGRectZero]];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setRightBarButtonItems:@[self.model.cancelBarButtonItem]];
    
    BBWeakify(self);
    [self BB_addObserverForKeyPath:@"titleView" options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.navigationItem setTitleView:self.titleView];
    }];
    
    [self.model BB_addObserverForKeyPath:@"title" options:NSKeyValueObservingOptionInitial block:^(NSString * _Nonnull key, id  _Nonnull object, NSDictionary * _Nonnull change) {
        BBStrongify(self);
        [self.titleView setTitle:self.model.title];
        [self.titleView setSubtitle:@"Tap to change album"];
        [self.titleView sizeToFit];
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.class authorizationStatus] != BBMediaPickerAuthorizationStatusAuthorized &&
        !self.hasRequestedPhotosAccess) {
        
        [self setHasRequestedPhotosAccess:YES];
        
        [self.class requestAuthorizationWithCompletion:nil];
    }
}

- (void)setTitleView:(__kindof UIView<BBMediaPickerTitleView> *)titleView {
    _titleView = titleView ?: [[BBMediaPickerDefaultTitleView alloc] initWithFrame:CGRectZero];
    
    if (_titleView) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureRecognizerAction:)];
        
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [tapGestureRecognizer setNumberOfTouchesRequired:1];
        
        [_titleView addGestureRecognizer:tapGestureRecognizer];
    }
}

+ (BBMediaPickerAuthorizationStatus)authorizationStatus; {
    return [BBMediaPickerModel authorizationStatus];
}
+ (void)requestAuthorizationWithCompletion:(nullable void(^)(BBMediaPickerAuthorizationStatus status))completion; {
    [BBMediaPickerModel requestAuthorizationWithCompletion:completion];
}

- (IBAction)_tapGestureRecognizerAction:(id)sender {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[BBMediaPickerAssetCollectionsViewController alloc] initWithModel:self.model]] animated:YES completion:nil];
}

@end
