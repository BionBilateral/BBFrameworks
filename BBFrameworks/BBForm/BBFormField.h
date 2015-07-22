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

@class BBFormField;

/**
 Enum describing the type of the form field.
 */
typedef NS_ENUM(NSInteger, BBFormFieldType) {
    /**
     Text input, using a UITextField.
     */
    BBFormFieldTypeText,
    /**
     Label, using a UITextField with enabled set to NO.
     */
    BBFormFieldTypeLabel,
    /**
     Boolean, using a UISwitch.
     */
    BBFormFieldTypeBooleanSwitch,
    /**
     Boolean, using checkmark accessory view.
     */
    BBFormFieldTypeBooleanCheckmark,
    /**
     Option selection, using a UIPickerView.
     */
    BBFormFieldTypePicker,
    /**
     Date selection, using a UIDatePicker.
     */
    BBFormFieldTypeDatePicker,
    /**
     Number selection, using a UIStepper.
     */
    BBFormFieldTypeStepper,
    /**
     Number selection, using a UISlider.
     */
    BBFormFieldTypeSlider,
    /**
     Option selection, using a UISegmentedControl.
     */
    BBFormFieldTypeSegmented
};
/**
 Key used to store the form field type.
 */
extern NSString *const BBFormFieldKeyType;
/**
 Key used to store the key used to retrieve the receiver's value.
 */
extern NSString *const BBFormFieldKeyKey;
/**
 Key used to store the receiver's title.
 */
extern NSString *const BBFormFieldKeyTitle;
/**
 Key used to store the receiver's subtitle, optional.
 */
extern NSString *const BBFormFieldKeySubtitle;
/**
 Key used to store the receiver's image, optional.
 */
extern NSString *const BBFormFieldKeyImage;
/**
 Key used to store the receiver's placeholder, optional. Used if the type is text.
 */
extern NSString *const BBFormFieldKeyPlaceholder;
/**
 Key used to store the receiver's keyboard type. Used if the type is text.
 */
extern NSString *const BBFormFieldKeyKeyboardType;
/**
 Key used to store the rows for the cell's picker view. Use this if the picker view should only have a single column.
 */
extern NSString *const BBFormFieldKeyPickerRows;
/**
 Key used to store the columns and rows for the cell's picker view. Use this if the picker view should have multiple columns.
 */
extern NSString *const BBFormFieldKeyPickerColumnsAndRows;
/**
 Key used to store the date picker mode. Used if the type is date picker.
 */
extern NSString *const BBFormFieldKeyDatePickerMode;
/**
 Key used to store the date formatter. Used if the type is date picker.
 */
extern NSString *const BBFormFieldKeyDateFormatter;
/**
 Key used to store the table view cell accessory type.
 */
extern NSString *const BBFormFieldKeyTableViewCellAccessoryType;
/**
 Key used to store the view controller class that should be pushed once the row is tapped.
 */
extern NSString *const BBFormFieldKeyViewControllerClass;
typedef void(^BBFormFieldDidSelectBlock)(BBFormField *formField, NSIndexPath *indexPath);
extern NSString *const BBFormFieldKeyDidSelectBlock;
typedef void(^BBFormFieldDidUpdateBlock)(BBFormField *formField);
extern NSString *const BBFormFieldKeyDidUpdateBlock;
extern NSString *const BBFormFieldKeyTitleHeader;
extern NSString *const BBFormFieldKeyTitleFooter;
extern NSString *const BBFormFieldKeyNumberFormatter;
extern NSString *const BBFormFieldKeyMinimumValue;
extern NSString *const BBFormFieldKeyMaximumValue;
extern NSString *const BBFormFieldKeyStepValue;
extern NSString *const BBFormFieldKeyMinimumValueImage;
extern NSString *const BBFormFieldKeyMaximumValueImage;
extern NSString *const BBFormFieldKeySegmentedItems;
extern NSString *const BBFormFieldKeyTableViewHeaderViewClass;
extern NSString *const BBFormFieldKeyTableViewFooterViewClass;

@interface BBFormField : NSObject

@property (readonly,weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;

@property (readonly,nonatomic) BBFormFieldType type;

@property (readonly,nonatomic) NSString *key;

@property (strong,nonatomic) id value;
@property (assign,nonatomic) BOOL boolValue;
@property (assign,nonatomic) float floatValue;
@property (assign,nonatomic) double doubleValue;

@property (readonly,nonatomic) NSString *title;
@property (readonly,nonatomic) NSString *subtitle;
@property (readonly,nonatomic) UIImage *image;
@property (readonly,nonatomic) NSString *placeholder;
@property (readonly,nonatomic) UIKeyboardType keyboardType;
@property (readonly,nonatomic) NSArray *pickerRows;
@property (readonly,nonatomic) NSArray *pickerColumnsAndRows;
@property (readonly,nonatomic) UIDatePickerMode datePickerMode;
@property (readonly,nonatomic) NSDateFormatter *dateFormatter;
@property (readonly,nonatomic) UITableViewCellAccessoryType tableViewCellAccessoryType;
@property (readonly,nonatomic) Class viewControllerClass;
@property (readonly,nonatomic) BBFormFieldDidSelectBlock didSelectBlock;
@property (readonly,nonatomic) BBFormFieldDidUpdateBlock didUpdateBlock;
@property (readonly,nonatomic) NSString *titleHeader;
@property (readonly,nonatomic) NSString *titleFooter;
@property (readonly,nonatomic) NSNumberFormatter *numberFormatter;
@property (readonly,nonatomic) NSNumber *minimumValue;
@property (readonly,nonatomic) float minimumFloatValue;
@property (readonly,nonatomic) double minimumDoubleValue;
@property (readonly,nonatomic) NSNumber *maximumValue;
@property (readonly,nonatomic) float maximumFloatValue;
@property (readonly,nonatomic) double maximumDoubleValue;
@property (readonly,nonatomic) NSNumber *stepValue;
@property (readonly,nonatomic) double stepDoubleValue;
@property (readonly,nonatomic) UIImage *minimumValueImage;
@property (readonly,nonatomic) UIImage *maximumValueImage;
@property (readonly,nonatomic) NSArray *segmentedItems;
@property (readonly,nonatomic) Class tableViewHeaderViewClass;
@property (readonly,nonatomic) Class tableViewFooterViewClass;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary dataSource:(id<BBFormTableViewControllerDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

@end

@interface BBFormField (ObjectKeyedSubscripting)

- (id)objectForKeyedSubscript:(NSString *)key;

@end