//
//  BBKit.h
//  BBFrameworks
//
//  Created by William Towe on 5/13/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_KIT__
#define __BB_FRAMEWORKS_KIT__

#import <TargetConditionals.h>

#import "BBKitColorMacros.h"

#import "BBKitFunctions.h"
#import "BBKitCGImageFunctions.h"

#import "NSURL+BBKitExtensions.h"
#import "CIImage+BBKitExtensions.h"
#import "NSString+BBKitExtensions.h"
#import "NSData+BBKitExtensions.h"
#import "NSParagraphStyle+BBKitExtensions.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#import "UINavigationController+BBKitExtensions.h"
#import "UIView+BBKitExtensions.h"
#import "UIViewController+BBKitExtensions.h"
#import "UIFont+BBKitExtensions.h"
#import "UIBarButtonItem+BBKitExtensions.h"
#import "UIAlertController+BBKitExtensions.h"
#import "UIDevice+BBKitExtensions.h"
#import "UIBezierPath+BBKitExtensions.h"
#import "NSObject+BBDynamicTypeExtensions.h"

#import "BBLabel.h"
#import "BBButton.h"
#import "BBTextField.h"
#import "BBPickerButton.h"
#import "BBDatePickerButton.h"
#import "BBNextPreviousInputAccessoryView.h"
#import "BBTextView.h"
#import "BBAnythingGestureRecognizer.h"
#import "BBProgressSlider.h"
#import "BBProgressNavigationBar.h"
#import "BBProgressToolbar.h"
#import "BBNetworkActivityIndicatorManager.h"
#else
#import "NSImage+BBKitExtensions.h"
#import "NSAlert+BBKitExtensions.h"
#import "NSView+BBKitExtensions.h"
#import "NSViewController+BBKitExtensions.h"
#import "NSWindow+BBKitExtensions.h"
#import "NSBezierPath+BBKitExtensions.h"
#endif

#import "BBBadgeView.h"
#import "BBGradientView.h"
#import "BBView.h"
#endif
