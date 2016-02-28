//
//  BBWebKitTheme.m
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

#import "BBWebKitTheme.h"
#import "UIImage+BBKitExtensionsPrivate.h"

@interface BBWebKitTheme ()
+ (UIImage *)_defaultGoBackImage;
+ (UIImage *)_defaultGoForwardImage;
@end

@implementation BBWebKitTheme

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> name=\"%@\"",NSStringFromClass(self.class),self,self.name];
}

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    _goBackImage = [self.class _defaultGoBackImage];
    _goForwardImage = [self.class _defaultGoForwardImage];
    
    return self;
}

+ (instancetype)defaultTheme; {
    static BBWebKitTheme *kRetval;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRetval = [[self alloc] init];
        
        [kRetval setName:@"com.bionbilateral.bbwebkit.theme.default"];
    });
    return kRetval;
}

- (void)setGoBackImage:(UIImage *)goBackImage {
    _goBackImage = goBackImage ?: [self.class _defaultGoBackImage];
}
- (void)setGoForwardImage:(UIImage *)goForwardImage {
    _goForwardImage = goForwardImage ?: [self.class _defaultGoForwardImage];
}

+ (UIImage *)_defaultGoBackImage; {
    return [UIImage BB_imageInResourcesBundleNamed:@"web_kit_go_back"];
}
+ (UIImage *)_defaultGoForwardImage; {
    return [UIImage BB_imageInResourcesBundleNamed:@"web_kit_go_forward"];
}

@end
