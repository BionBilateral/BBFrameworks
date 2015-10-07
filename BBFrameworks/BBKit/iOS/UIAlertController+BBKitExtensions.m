//
//  UIAlertController+BBExtensions.m
//  BBFrameworks
//
//  Created by Jason Anderson on 7/3/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIAlertController+BBKitExtensions.h"
#import "BBFoundationMacros.h"
#import "UIViewController+BBKitExtensions.h"
#import "NSError+BBFoundationExtensions.h"

NSInteger const BBKitUIAlertControllerCancelButtonIndex = -1;

@implementation UIAlertController (BBKitExtensions)

+ (void)BB_presentAlertControllerWithError:(nullable NSError *)error; {
    [self BB_presentAlertControllerWithError:error completion:nil];
}
+ (void)BB_presentAlertControllerWithError:(nullable NSError *)error completion:(nullable BBKitUIAlertControllerCompletionBlock)completion; {
    [self BB_presentAlertControllerWithTitle:[error BB_alertTitle] message:[error BB_alertMessage] cancelButtonTitle:nil otherButtonTitles:nil completion:completion];
}
+ (void)BB_presentAlertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles completion:(nullable BBKitUIAlertControllerCompletionBlock)completion; {
    UIAlertController *alertController = [self BB_alertControllerWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles completion:completion];
    
    [[UIViewController BB_viewControllerForPresenting] presentViewController:alertController animated:YES completion:nil];
}

+ (UIAlertController *)BB_alertControllerWithError:(nullable NSError *)error; {
    return [self BB_alertControllerWithError:error completion:nil];
}
+ (UIAlertController *)BB_alertControllerWithError:(nullable NSError *)error completion:(nullable BBKitUIAlertControllerCompletionBlock)completion
{
    return [self BB_alertControllerWithTitle:[error BB_alertTitle] message:[error BB_alertMessage] cancelButtonTitle:nil otherButtonTitles:nil completion:completion];
}
+ (UIAlertController *)BB_alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSArray *)otherButtonTitles completion:(nullable BBKitUIAlertControllerCompletionBlock)completion; {
    if (title.length == 0) {
        title = BBLocalizedStringErrorAlertDefaultTitle();
    }
    
    if (message.length == 0) {
        message = BBLocalizedStringErrorAlertDefaultMessage();
    }
    
    if (cancelButtonTitle.length == 0) {
        if (otherButtonTitles.count == 0) {
            cancelButtonTitle = BBLocalizedStringAlertDefaultSingleCancelButtonTitle();
        }
        else {
            cancelButtonTitle = BBLocalizedStringAlertDefaultMultipleCancelButtonTitle();
        }
    }
    
    UIAlertController *retval = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [retval addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(BBKitUIAlertControllerCancelButtonIndex);
        }
    }]];
    
    [otherButtonTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [retval addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(idx);
            }
        }]];
    }];
    
    return retval;
}

@end
