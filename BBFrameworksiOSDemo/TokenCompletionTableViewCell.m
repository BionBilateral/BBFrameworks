//
//  TokenCompletionTableViewCell.m
//  BBFrameworks
//
//  Created by William Towe on 7/13/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TokenCompletionTableViewCell.h"

@interface TokenCompletionTableViewCell ()
@property (strong,nonatomic) UILabel *titleLabel;
@end

@implementation TokenCompletionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setBackgroundColor:[UIColor blackColor]];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.contentView addSubview:self.titleLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel setFrame:CGRectMake(8.0, 0, CGRectGetWidth(self.contentView.bounds) - 16.0, CGRectGetHeight(self.contentView.bounds))];
}

@synthesize completion=_completion;
- (void)setCompletion:(id<BBTokenCompletion>)completion {
    _completion = completion;
    
    NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:[completion tokenCompletionTitle] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    if ([completion respondsToSelector:@selector(tokenCompletionRange)]) {
        [retval addAttributes:@{NSBackgroundColorAttributeName: self.tintColor} range:[completion tokenCompletionRange]];
    }
    
    [self.titleLabel setAttributedText:retval];
}

+ (CGFloat)rowHeight {
    return 32.0;
}

@end
