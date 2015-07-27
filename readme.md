##BBFrameworks

[![Build Status](https://travis-ci.org/BionBilateral/BBFrameworks.svg)](https://travis-ci.org/BionBilateral/BBFrameworks)
 [![Version](http://img.shields.io/cocoapods/v/BBFrameworks.svg)](http://cocoapods.org/?q=BBFrameworks)
 [![Platform](http://img.shields.io/cocoapods/p/BBFrameworks.svg)]()
 [![License](http://img.shields.io/cocoapods/l/BBFrameworks.svg)](https://github.com/BionBilateral/BBFrameworks/blob/master/license.txt)

Repository for common iOS/OSX categories, classes, and functions.

###BBKit

Classes, categories, and functions extending the UIKit and AppKit frameworks.

- Headers
	- BBKitCGImageFunctions.h, functions to test an image for alpha component and resize images using the Accelerate framework
	- BBKitColorMacros.h, macros wrapping the functionality available in UIColor+BBKitExtensions and NSColor+BBKitExtensions
- Classes
	- BBBadgeView, ios/osx class providing badging functionality similar to Mail app unread count
	- BBGradientView, ios/osx class wrapping CAGradientLayer functionality
	- BBView, ios/osx class that can draw borders; the osx version provides the backgroundColor property to match UIView
- Categories
	- NSColor+BBKitExtensions, methods to create random RGB color with an optional alpha value and create colors from hex strings
	- NSImage+BBKitExtensions, methods to resize, blur, tint, and render template images
	- NSURL+BBKitExtensions, methods to access various NSURL resource values
	- UIBarButtonItem+BBKitExtensions, methods to create fixed width and flexible width bar button items
	- UIColor+BBKitExtensions, identical methods to NSColor+BBKitExtensions
	- UIFont+BBKitExtensions, method to fetch a custom font but match its point size to passed in text style
	- UIImage+BBKitExtensions, identical methods to NSImage+BBKitExtensions
	- UIView+BBKitExtensions, method to fetch all subviews recursively
	- UIViewController+BBKitExtensions, method to fetch the correct view controller for presentation
	
###BBReactiveKit

Classes extending the UIKit framework, built on top of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa).

- Classes
	- BBProgressNavigationBar, UINavigationBar subclass that manages a UIProgressView instance and provides methods to show/hide and change its associated progress
	- BBTextView, UITextView subclass that provides placeholder functionality similar to UITextField
	
###BBAddressBook

A library that wraps the AddressBook framework. The principal classes are BBAddressBookManager, BBAddressBookPerson, and BBAddressBookGroup.

###BBThumbnail

A thumbnail generation library for local and remote URLs. The principal class is BBThumbnailGenerator. This library is available on iOS and OSX.

Supported local UTIs and file extensions:

- kUTTypeImage
- kUTTypeMovie
- kUTTypePDF
- kUTTypeRTF
- kUTTypeRTFD
- kUTTypePlainText
- kUTTypeCommaSeparatedText
- kUTTypeHTML
- doc, docx, xls, xlsx, ppt, pptx

Supported remote URL schemes and domains:

- http and https
- youtube (requires API key)
- vimeo

###BBReactiveThumbnail

Categories that add signal generating methods to BBThumbnail.

###BBMediaPicker

A library to acts as a replacement for the UIImagePickerController media selection functionality. The principal class is BBMediaPickerViewController.

###BBMediaPlayer

A library that acts as a replacement for the MPMoviePlayerController and its associated classes. The principal classes are BBMoviePlayerController and BBMoviePlayerViewController.

###BBWebKit

A library that wraps a WKWebView for convenient in app display. The principal classes are BBWebKitViewController and BBWebKitTitleView.

###BBTooltip

A library that facilitates the display of tooltips within an app. Similar to the Facebook app. The principal classes are BBTooltipViewController and BBTooltipView.

###BBForm

A library that facilitates the creation and display of settings style views.

###BBToken

A collection of classes that mirror the functionality provided by NSTextField on OSX. The principal class is BBTokenTextView.