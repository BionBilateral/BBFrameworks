##BBFrameworks

[![Build Status](https://travis-ci.org/BionBilateral/BBFrameworks.svg)](https://travis-ci.org/BionBilateral/BBFrameworks)
 [![Version](http://img.shields.io/cocoapods/v/BBFrameworks.svg)](http://cocoapods.org/?q=BBFrameworks)
 [![Platform](http://img.shields.io/cocoapods/p/BBFrameworks.svg)]()
 [![License](http://img.shields.io/cocoapods/l/BBFrameworks.svg)](https://github.com/BionBilateral/BBFrameworks/blob/master/license.txt)

Repository for common iOS/OSX categories, classes, and functions.

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