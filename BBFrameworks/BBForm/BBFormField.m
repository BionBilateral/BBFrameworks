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
NSString *const BBFormFieldKeySubtitle = @"BBFormFieldKeySubtitle";
NSString *const BBFormFieldKeyImage = @"BBFormFieldKeyImage";
NSString *const BBFormFieldKeyPlaceholder = @"BBFormFieldKeyPlaceholder";
NSString *const BBFormFieldKeyKeyboardType = @"BBFormFieldKeyKeyboardType";
NSString *const BBFormFieldKeyPickerRows = @"BBFormFieldKeyPickerRows";
NSString *const BBFormFieldKeyPickerColumnsAndRows = @"BBFormFieldKeyPickerColumnsAndRows";
NSString *const BBFormFieldKeyDatePickerMode = @"BBFormFieldKeyDatePickerMode";
NSString *const BBFormFieldKeyDateFormatter = @"BBFormFieldKeyDateFormatter";
NSString *const BBFormFieldKeyTableViewCellAccessoryType = @"BBFormFieldKeyTableViewCellAccessoryType";
NSString *const BBFormFieldKeyViewControllerClass = @"BBFormFieldKeyViewControllerClass";
NSString *const BBFormFieldKeyDidSelectBlock = @"BBFormFieldKeyDidSelectBlock";
NSString *const BBFormFieldKeyWillUpdateBlock = @"BBFormFieldKeyWillUpdateBlock";
NSString *const BBFormFieldKeyDidUpdateBlock = @"BBFormFieldKeyDidUpdateBlock";
NSString *const BBFormFieldKeyTitleHeader = @"BBFormFieldKeyTitleHeader";
NSString *const BBFormFieldKeyTitleFooter = @"BBFormFieldKeyTitleFooter";
NSString *const BBFormFieldKeyNumberFormatter = @"BBFormFieldKeyNumberFormatter";
NSString *const BBFormFieldKeyMinimumValue = @"BBFormFieldKeyMinimumValue";
NSString *const BBFormFieldKeyMaximumValue = @"BBFormFieldKeyMaximumValue";
NSString *const BBFormFieldKeyStepValue = @"BBFormFieldKeyStepValue";
NSString *const BBFormFieldKeyMinimumValueImage = @"BBFormFieldKeyMinimumValueImage";
NSString *const BBFormFieldKeyMaximumValueImage = @"BBFormFieldKeyMaximumValueImage";
NSString *const BBFormFieldKeySegmentedItems = @"BBFormFieldKeySegmentedItems";
NSString *const BBFormFieldKeyTableViewHeaderViewClass = @"BBFormFieldKeyTableViewHeaderViewClass";
NSString *const BBFormFieldKeyTableViewFooterViewClass = @"BBFormFieldKeyTableViewFooterViewClass";
NSString *const BBFormFieldKeyTableViewCellClass = @"BBFormFieldKeyTableViewCellClass";

@interface BBFormField ()
@property (copy,nonatomic) NSDictionary *dictionary;
@property (readwrite,weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;
@end

@implementation BBFormField

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> key: %@ value: %@",NSStringFromClass(self.class),self,self.key,self.value];
}

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
- (NSString *)subtitle {
    return self[BBFormFieldKeySubtitle];
}
- (UIImage *)image {
    return self[BBFormFieldKeyImage];
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
- (UIDatePickerMode)datePickerMode {
    return [self[BBFormFieldKeyDatePickerMode] integerValue];
}
- (NSDateFormatter *)dateFormatter {
    return self[BBFormFieldKeyDateFormatter];
}
- (UITableViewCellAccessoryType)tableViewCellAccessoryType {
    return [self[BBFormFieldKeyTableViewCellAccessoryType] integerValue];
}
- (Class)viewControllerClass {
    return self[BBFormFieldKeyViewControllerClass];
}
- (BBFormFieldDidSelectBlock)didSelectBlock {
    return self[BBFormFieldKeyDidSelectBlock];
}
- (BBFormFieldWillUpdateBlock)willUpdateBlock {
    return self[BBFormFieldKeyWillUpdateBlock];
}
- (BBFormFieldDidUpdateBlock)didUpdateBlock {
    return self[BBFormFieldKeyDidUpdateBlock];
}
- (NSString *)titleHeader {
    return self[BBFormFieldKeyTitleHeader];
}
- (NSString *)titleFooter {
    return self[BBFormFieldKeyTitleFooter];
}
- (NSNumberFormatter *)numberFormatter {
    return self[BBFormFieldKeyNumberFormatter];
}
- (NSNumber *)minimumValue {
    return self[BBFormFieldKeyMinimumValue];
}
- (float)minimumFloatValue {
    return [self.minimumValue floatValue];
}
- (double)minimumDoubleValue {
    return [self.minimumValue doubleValue];
}
- (NSNumber *)maximumValue {
    return self[BBFormFieldKeyMaximumValue];
}
- (float)maximumFloatValue {
    return [self.maximumValue floatValue];
}
- (double)maximumDoubleValue {
    return [self.maximumValue doubleValue];
}
- (NSNumber *)stepValue {
    return self[BBFormFieldKeyStepValue];
}
- (double)stepDoubleValue {
    return [self.stepValue doubleValue];
}
- (UIImage *)minimumValueImage {
    return self[BBFormFieldKeyMinimumValueImage];
}
- (UIImage *)maximumValueImage {
    return self[BBFormFieldKeyMaximumValueImage];
}
- (NSArray *)segmentedItems {
    return self[BBFormFieldKeySegmentedItems];
}
- (Class)tableViewHeaderViewClass {
    return self[BBFormFieldKeyTableViewHeaderViewClass];
}
- (Class)tableViewFooterViewClass {
    return self[BBFormFieldKeyTableViewFooterViewClass];
}
- (Class)tableViewCellClass {
    return self[BBFormFieldKeyTableViewCellClass];
}

- (BOOL)isEditable {
    switch (self.type) {
        case BBFormFieldTypeDatePicker:
        case BBFormFieldTypePicker:
        case BBFormFieldTypeText:
            return YES;
        default:
            return NO;
    }
}

@dynamic value;
- (id)value {
    return self.key ? [(id)self.dataSource valueForKey:self.key] : nil;
}
- (void)setValue:(id)value {
    if (self.key) {
        if (self.willUpdateBlock) {
            self.willUpdateBlock(self);
        }
        
        [(id)self.dataSource setValue:value forKey:self.key];
        
        if (self.didUpdateBlock) {
            self.didUpdateBlock(self);
        }
    }
}
@dynamic boolValue;
- (BOOL)boolValue {
    return [self.value boolValue];
}
- (void)setBoolValue:(BOOL)boolValue {
    [self setValue:@(boolValue)];
}
@dynamic floatValue;
- (float)floatValue {
    return [self.value floatValue];
}
- (void)setFloatValue:(float)floatValue {
    [self setValue:@(floatValue)];
}
@dynamic doubleValue;
- (double)doubleValue {
    return [self.value doubleValue];
}
- (void)setDoubleValue:(double)doubleValue {
    [self setValue:@(doubleValue)];
}

@end

@implementation BBFormField (ObjectKeyedSubscripting)

- (id)objectForKeyedSubscript:(NSString *)key; {
    return self.dictionary[key];
}

@end