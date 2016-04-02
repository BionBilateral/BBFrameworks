//
//  BBMediaViewerMedia.h
//  BBFrameworks
//
//  Created by William Towe on 2/28/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol defining media objects that are provided by the media viewer data source.
 */
@protocol BBMediaViewerMedia <NSObject>
@required
/**
 Get the URL representing the media object. Local and remote URLs are supported. If a remote URL is returned, relevant delegate methods will be called to locate a local copy of the file and download it if necessary.
 */
@property (readonly,nonatomic) NSURL *mediaViewerMediaURL;
@optional
/**
 Get the title for the media object. This title is displayed in the navigation bar for the selected media object. If the media object does not implement this method, `mediaViewerMediaURL.lastPathComponent` is used.
 */
@property (readonly,nonatomic) NSString *mediaViewerMediaTitle;
/**
 Get the MIME type for the media object. If the receiver responds to this method, it will be used to determine the media type for display rather than inspecting the media URL itself.
 */
@property (readonly,nonatomic) NSString *mediaViewerMIMEType;
@end

NS_ASSUME_NONNULL_END
