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
/**
 Did select block invoked when the user taps on a row.
 
 @param formField The form field represented by the row that was tapped
 @param indexPath The index path of the tapped row
 */
typedef void(^BBFormFieldDidSelectBlock)(BBFormField *formField, NSIndexPath *indexPath);
/**
 Key used to store the did select block that should be invoked once the row is tapped.
 */
extern NSString *const BBFormFieldKeyDidSelectBlock;
/**
 Will update block invoked before the form field's value changes.
 
 @param formField The form field whose value is about to change
 */
typedef void(^BBFormFieldWillUpdateBlock)(BBFormField *formField);
/**
 Key used to store the will update block.
 */
extern NSString *const BBFormFieldKeyWillUpdateBlock;
/**
 Did update block invoked after the form field's value changes.
 
 @param formField The form field whose value changed
 */
typedef void(^BBFormFieldDidUpdateBlock)(BBFormField *formField);
/**
 Key used to store the did update block.
 */
extern NSString *const BBFormFieldKeyDidUpdateBlock;
/**
 Key used to store the header title.
 */
extern NSString *const BBFormFieldKeyTitleHeader;
/**
 Key used to store the footer title.
 */
extern NSString *const BBFormFieldKeyTitleFooter;
/**
 Key used to store the NSNumberFormatter used to format the value when the type is stepper.
 */
extern NSString *const BBFormFieldKeyNumberFormatter;
/**
 Key used to store the minimum value and used when the type is stepper or slider.
 */
extern NSString *const BBFormFieldKeyMinimumValue;
/**
 Key used to store the maximum value and used when the type is stepper or slider.
 */
extern NSString *const BBFormFieldKeyMaximumValue;
/**
 Key used to store the step value and used when the type is stepper.
 */
extern NSString *const BBFormFieldKeyStepValue;
/**
 Key used to store the minimum value image and used when the type is slider.
 */
extern NSString *const BBFormFieldKeyMinimumValueImage;
/**
 Key used to store the maximum value image and used when the type is slider.
 */
extern NSString *const BBFormFieldKeyMaximumValueImage;
/**
 Key used to store the segmented items (either strings or images) and used when the type is stepper.
 */
extern NSString *const BBFormFieldKeySegmentedItems;
/**
 Key used to store the header view class.
 */
extern NSString *const BBFormFieldKeyTableViewHeaderViewClass;
/**
 Key used to store the footer view class.
 */
extern NSString *const BBFormFieldKeyTableViewFooterViewClass;
/**
 Key used to store the table view cell class.
 */
extern NSString *const BBFormFieldKeyTableViewCellClass;

/**
 BBFormField is an NSObject subclass that represents a single row within a BBFormTableViewController.
 */
@interface BBFormField : NSObject

/**
 Get the data source of the receiver's owning table view controller.
 */
@property (readonly,weak,nonatomic) id<BBFormTableViewControllerDataSource> dataSource;

/**
 Get the type of the receiver.
 
 @see BBFormFieldType
 */
@property (readonly,nonatomic) BBFormFieldType type;

/**
 Get whether the receiver is editable. This affects next/previous functionality of attached input accessory views.
 */
@property (readonly,nonatomic,getter=isEditable) BOOL editable;

/**
 Get the key of the receiver.
 */
@property (readonly,nonatomic) NSString *key;

/**
 Set and get the value of the receiver.
 */
@property (strong,nonatomic) id value;
/**
 Set and get the value of the receiver as a boolean.
 */
@property (assign,nonatomic) BOOL boolValue;
/**
 Set and get the value of the receiver as a float.
 */
@property (assign,nonatomic) float floatValue;
/**
 Set and get the value of the receiver as a double.
 */
@property (assign,nonatomic) double doubleValue;

/**
 Get the title of the receiver.
 */
@property (readonly,nonatomic) NSString *title;
/**
 Get the subtitle of the receiver.
 */
@property (readonly,nonatomic) NSString *subtitle;
/**
 Get the image of the receiver.
 */
@property (readonly,nonatomic) UIImage *image;
/**
 Get the placeholder of the receiver.
 */
@property (readonly,nonatomic) NSString *placeholder;
/**
 Get the keyboard type of the receiver.
 */
@property (readonly,nonatomic) UIKeyboardType keyboardType;
/**
 Get the picker rows of the receiver.
 */
@property (readonly,nonatomic) NSArray *pickerRows;
/**
 Get the picker columns and rows of the receiver.
 */
@property (readonly,nonatomic) NSArray *pickerColumnsAndRows;
/**
 Get the date picker mode of the receiver.
 */
@property (readonly,nonatomic) UIDatePickerMode datePickerMode;
/**
 Get the date formatter of the receiver.
 */
@property (readonly,nonatomic) NSDateFormatter *dateFormatter;
/**
 Get the table view cell accessory type of the receiver.
 */
@property (readonly,nonatomic) UITableViewCellAccessoryType tableViewCellAccessoryType;
/**
 Get the view controller class of the receiver.
 */
@property (readonly,nonatomic) Class viewControllerClass;
/**
 Get the did select block of the receiver.
 */
@property (readonly,nonatomic) BBFormFieldDidSelectBlock didSelectBlock;
/**
 Get the will update block of the receiver.
 */
@property (readonly,nonatomic) BBFormFieldWillUpdateBlock willUpdateBlock;
/**
 Get the did update block of the receiver.
 */
@property (readonly,nonatomic) BBFormFieldDidUpdateBlock didUpdateBlock;
/**
 Get the header title of the receiver.
 */
@property (readonly,nonatomic) NSString *titleHeader;
/**
 Get the footer title of the receiver.
 */
@property (readonly,nonatomic) NSString *titleFooter;
/**
 Get the number formatter of the receiver.
 */
@property (readonly,nonatomic) NSNumberFormatter *numberFormatter;
/**
 Get the minimum value of the receiver.
 */
@property (readonly,nonatomic) NSNumber *minimumValue;
/**
 Get the minimum value of the receiver as a float.
 */
@property (readonly,nonatomic) float minimumFloatValue;
/**
 Get the minimum value of the receiver as a double.
 */
@property (readonly,nonatomic) double minimumDoubleValue;
/**
 Get the maximum value of the receiver.
 */
@property (readonly,nonatomic) NSNumber *maximumValue;
/**
 Get the maximum value of the receiver as a float.
 */
@property (readonly,nonatomic) float maximumFloatValue;
/**
 Get the maximum value of the receiver as a double.
 */
@property (readonly,nonatomic) double maximumDoubleValue;
/**
 Get the step value of the receiver.
 */
@property (readonly,nonatomic) NSNumber *stepValue;
/**
 Get the step value of the receiver as a double.
 */
@property (readonly,nonatomic) double stepDoubleValue;
/**
 Get the minimum value image of the receiver.
 */
@property (readonly,nonatomic) UIImage *minimumValueImage;
/**
 Get the maximum value image of the receiver.
 */
@property (readonly,nonatomic) UIImage *maximumValueImage;
/**
 Get the segmented items of the receiver.
 */
@property (readonly,nonatomic) NSArray *segmentedItems;
/**
 Get the header view class of the receiver.
 */
@property (readonly,nonatomic) Class tableViewHeaderViewClass;
/**
 Get the footer view class of the receiver.
 */
@property (readonly,nonatomic) Class tableViewFooterViewClass;
/**
 Get the cell class of the receiver.
 */
@property (readonly,nonatomic) Class tableViewCellClass;

/**
 Creates and returns an initialized instance of the receiver.
 
 @param dictionary The dictionary of attributes to use for configuration
 @param dataSource The owning table view controller's data source
 @return An initialized instance of the receiver
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary dataSource:(id<BBFormTableViewControllerDataSource>)dataSource NS_DESIGNATED_INITIALIZER;

@end

/**
 Category on BBFormField adding support for keyed subscripting.
 */
@interface BBFormField (ObjectKeyedSubscripting)

/**
 Return the object for provided key.
 
 @param key The key to return object for
 @return The object or nil
 */
- (id)objectForKeyedSubscript:(NSString *)key;

@end