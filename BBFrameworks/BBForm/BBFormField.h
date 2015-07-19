//
//  BBFormField.h
//  BBFrameworks
//
//  Created by William Towe on 7/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
#import "BBFormTableViewControllerDataSource.h"

typedef NS_ENUM(NSInteger, BBFormFieldType) {
    BBFormFieldTypeText,
    BBFormFieldTypeLabel,
    BBFormFieldTypeBoolean,
    BBFormFieldTypePicker
};
extern NSString *const BBFormFieldKeyType;
extern NSString *const BBFormFieldKeyKey;
extern NSString *const BBFormFieldKeyTitle;
extern NSString *const BBFormFieldKeyPlaceholder;
extern NSString *const BBFormFieldKeyKeyboardType;
extern NSString *const BBFormFieldKeyPickerRows;
extern NSString *const BBFormFieldKeyPickerColumnsAndRows;

@interface BBFormField : NSObject

@property (readonly,nonatomic) BBFormFieldType type;

@property (readonly,nonatomic) NSString *key;
@property (strong,nonatomic) id value;
@property (assign,nonatomic) BOOL boolValue;

@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) NSString *placeholder;
@property (readonly,nonatomic) UIKeyboardType keyboardType;
@property (readonly,nonatomic) NSArray *pickerRows;
@property (readonly,nonatomic) NSArray *pickerColumnsAndRows;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary dataSource:(id<BBFormTableViewControllerDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

@end

@interface BBFormField (ObjectKeyedSubscripting)

- (id)objectForKeyedSubscript:(NSString *)key;

@end