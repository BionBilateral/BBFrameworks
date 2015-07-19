//
//  BBFormField.m
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

#import "BBFormField.h"

NSString *const BBFormFieldKeyType = @"BBFormFieldKeyType";
NSString *const BBFormFieldKeyKey = @"BBFormFieldKeyKey";
NSString *const BBFormFieldKeyTitle = @"BBFormFieldKeyTitle";
NSString *const BBFormFieldKeyPlaceholder = @"BBFormFieldKeyPlaceholder";
NSString *const BBFormFieldKeyKeyboardType = @"BBFormFieldKeyKeyboardType";
NSString *const BBFormFieldKeyPickerRows = @"BBFormFieldKeyPickerRows";
NSString *const BBFormFieldKeyPickerColumnsAndRows = @"BBFormFieldKeyPickerColumnsAndRows";

@interface BBFormField ()
@property (copy,nonatomic) NSDictionary *dictionary;
@property (weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;
@end

@implementation BBFormField

- (instancetype)initWithDictionary:(NSDictionary *)dictionary dataSource:(id<BBFormTableViewControllerDataSource>)dataSource {
    if (!(self = [super init]))
        return nil;
    
    [self setDictionary:dictionary];
    [self setDataSource:dataSource];
    
    return self;
}

- (BBFormFieldType)type {
    return [self[BBFormFieldKeyType] integerValue];
}
- (NSString *)key {
    return self[BBFormFieldKeyKey];
}
- (NSString *)title {
    return self[BBFormFieldKeyTitle];
}
- (NSString *)placeholder {
    return self[BBFormFieldKeyPlaceholder];
}
- (UIKeyboardType)keyboardType {
    return [self[BBFormFieldKeyKeyboardType] integerValue];
}
- (NSArray *)pickerRows {
    return self[BBFormFieldKeyPickerRows];
}
- (NSArray *)pickerColumnsAndRows {
    return self[BBFormFieldKeyPickerColumnsAndRows];
}

@dynamic value;
- (id)value {
    return [(id)self.dataSource valueForKey:self.key];
}
- (void)setValue:(id)value {
    [(id)self.dataSource setValue:value forKey:self.key];
}
@dynamic boolValue;
- (BOOL)boolValue {
    return [self.value boolValue];
}
- (void)setBoolValue:(BOOL)boolValue {
    [self setValue:@(boolValue)];
}

@end

@implementation BBFormField (ObjectKeyedSubscripting)

- (id)objectForKeyedSubscript:(NSString *)key; {
    return self.dictionary[key];
}

@end