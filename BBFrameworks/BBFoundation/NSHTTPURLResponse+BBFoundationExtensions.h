//
//  NSHTTPURLResponse+BBFoundationExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 12/17/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BBHTTPStatusCode) {
    BBHTTPStatusCodeContinue = 100,
    BBHTTPStatusCodeSwitchingProtocols = 101,
    
    BBHTTPStatusCodeOK = 200,
    BBHTTPStatusCodeCreated = 201,
    BBHTTPStatusCodeAccepted = 202,
    BBHTTPStatusCodeNonAuthoritativeInformation = 203,
    BBHTTPStatusCodeNoContent = 204,
    BBHTTPStatusCodeResetContent = 205,
    BBHTTPStatusCodePartialContent = 206,
    
    BBHTTPStatusCodeMultipleChoices = 300,
    BBHTTPStatusCodeMovedPermanently = 301,
    BBHTTPStatusCodeFound = 302,
    BBHTTPStatusCodeSeeOther = 303,
    BBHTTPStatusCodeNotModified = 304,
    BBHTTPStatusCodeUseProxy = 305,
    BBHTTPStatusCodeTemporaryRedirect = 307,
    
    BBHTTPStatusCodeBadRequest = 400,
    BBHTTPStatusCodeUnauthorized = 401,
    BBHTTPStatusCodePaymentRequired = 402,
    BBHTTPStatusCodeForbidden = 403,
    BBHTTPStatusCodeNotFound = 404,
    BBHTTPStatusCodeMethoNotAllowed = 405,
    BBHTTPStatusCodeNotAcceptable = 406,
    BBHTTPStatusCodeProxyAuthenticationRequired = 407,
    BBHTTPStatusCodeRequestTimeout = 408,
    BBHTTPStatusCodeConflict = 409,
    BBHTTPStatusCodeGone = 410,
    BBHTTPStatusCodeLengthRequired = 411,
    BBHTTPStatusCodePreconditionFailed = 412,
    BBHTTPStatusCodeRequestEntityTooLarge = 413,
    BBHTTPStatusCodeRequestURITooLarge = 414,
    BBHTTPStatusCodeUnsupportedMediaType = 415,
    BBHTTPStatusCodeRequestedRangeNotSatisfiable = 416,
    BBHTTPStatusCodeExpectationFailed = 417,
    
    BBHTTPStatusCodeInternalServerError = 500,
    BBHTTPStatusCodeNotImplemented = 501,
    BBHTTPStatusCodeBadGateway = 502,
    BBHTTPStatusCodeServiceUnavailable = 503,
    BBHTTPStatusCodeGatewayTimeout = 504,
    BBHTTPStatusCodeHTTPVersionNotSupported = 505
};

@interface NSHTTPURLResponse (BBFoundationExtensions)

- (NSString *)XFS_localizedStatusCodeString;

@end
