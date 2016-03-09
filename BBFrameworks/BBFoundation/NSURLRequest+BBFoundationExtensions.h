//
//  NSURLRequest+BBFoundationExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 12/18/15.
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

/**
 Struct containing string constants for supported HTTP methods. See http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html for more information.
 */
extern const struct BBHTTPMethod {
    __unsafe_unretained NSString *OPTIONS;
    __unsafe_unretained NSString *GET;
    __unsafe_unretained NSString *HEAD;
    __unsafe_unretained NSString *POST;
    __unsafe_unretained NSString *PUT;
    __unsafe_unretained NSString *DELETE;
    __unsafe_unretained NSString *TRACE;
    __unsafe_unretained NSString *CONNECT;
} BBHTTPMethod;

/**
 Struct containing string constants for supported HTTP header fields. See https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html for more information.
 */
extern const struct BBHTTPHeaderField {
    __unsafe_unretained NSString *Accept;
    __unsafe_unretained NSString *Accept_Charset;
    __unsafe_unretained NSString *Accept_Encoding;
    __unsafe_unretained NSString *Accept_Language;
    __unsafe_unretained NSString *Accept_Ranges;
    __unsafe_unretained NSString *Age;
    __unsafe_unretained NSString *Allow;
    __unsafe_unretained NSString *Authorization;
    __unsafe_unretained NSString *Cache_Control;
    __unsafe_unretained NSString *Connection;
    __unsafe_unretained NSString *Content_Encoding;
    __unsafe_unretained NSString *Content_Language;
    __unsafe_unretained NSString *Content_Length;
    __unsafe_unretained NSString *Content_Location;
    __unsafe_unretained NSString *Content_MD5;
    __unsafe_unretained NSString *Content_Range;
    __unsafe_unretained NSString *Content_Type;
    __unsafe_unretained NSString *Date;
    __unsafe_unretained NSString *ETag;
    __unsafe_unretained NSString *Expect;
    __unsafe_unretained NSString *Expires;
    __unsafe_unretained NSString *From;
    __unsafe_unretained NSString *Host;
    __unsafe_unretained NSString *If_Match;
    __unsafe_unretained NSString *If_Modified_Since;
    __unsafe_unretained NSString *If_None_Match;
    __unsafe_unretained NSString *If_Range;
    __unsafe_unretained NSString *If_Unmodified_Since;
    __unsafe_unretained NSString *Last_Modified;
    __unsafe_unretained NSString *Location;
    __unsafe_unretained NSString *Max_Forwards;
    __unsafe_unretained NSString *Pragma;
    __unsafe_unretained NSString *Proxy_Authenticate;
    __unsafe_unretained NSString *Proxy_Authorization;
    __unsafe_unretained NSString *Range;
    __unsafe_unretained NSString *Referer;
    __unsafe_unretained NSString *Retry_After;
    __unsafe_unretained NSString *Server;
    __unsafe_unretained NSString *TE;
    __unsafe_unretained NSString *Trailer;
    __unsafe_unretained NSString *Transfer_Encoding;
    __unsafe_unretained NSString *Upgrade;
    __unsafe_unretained NSString *User_Agent;
    __unsafe_unretained NSString *Vary;
    __unsafe_unretained NSString *Via;
    __unsafe_unretained NSString *Warning;
    __unsafe_unretained NSString *WWW_Authenticate;
} BBHTTPHeaderField;

@interface NSURLRequest (BBFoundationExtensions)

@end
