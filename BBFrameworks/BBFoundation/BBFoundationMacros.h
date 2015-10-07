//
//  BBFoundationMacros.h
//  BBFrameworks
//
//  Created by William Towe on 5/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_FOUNDATION_MACROS__
#define __BB_FRAMEWORKS_FOUNDATION_MACROS__

#import "BBFrameworksFunctions.h"

#define BBBoundedValue(value, min, max) MAX(MIN((value), (max)), (min))

#define BBLocalizedStringErrorAlertDefaultTitle() NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_DEFAULT_TITLE", @"Foundation", BBFrameworksResourcesBundle(), @"Error", @"default error alert title")
#define BBLocalizedStringErrorAlertDefaultMessage() NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_DEFAULT_MESSAGE", @"Foundation", BBFrameworksResourcesBundle(), @"The operation could not be completed.", @"default error alert message")
#define BBLocalizedStringAlertDefaultSingleCancelButtonTitle() NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_DEFAULT_SINGLE_CANCEL_BUTTON_TITLE", @"Foundation", BBFrameworksResourcesBundle(), @"Ok", @"default error alert single cancel button title")
#define BBLocalizedStringAlertDefaultMultipleCancelButtonTitle() NSLocalizedStringWithDefaultValue(@"ERROR_ALERT_DEFAULT_MULTIPLE_CANCEL_BUTTON_TITLE", @"Foundation", BBFrameworksResourcesBundle(), @"Cancel", @"default error alert multiple cancel button title")

#endif
