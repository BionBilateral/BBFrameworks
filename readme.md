##BBFrameworks

[![Build Status](https://travis-ci.org/BionBilateral/BBFrameworks.svg)](https://travis-ci.org/BionBilateral/BBFrameworks)
 [![Version](http://img.shields.io/cocoapods/v/BBFrameworks.svg)](http://cocoapods.org/?q=BBFrameworks)
 [![Platform](http://img.shields.io/cocoapods/p/BBFrameworks.svg)]()
 [![License](http://img.shields.io/cocoapods/l/BBFrameworks.svg)](https://github.com/BionBilateral/BBFrameworks/blob/master/license.txt)

Repository for common iOS/OSX categories, classes, and functions.

###Subspecs

See the wiki for more detailed information on each subspec. This is an extra sentence.

- `BBFrameworks/BBCore`, subspec that everything else depends upon, including shared resource files
- `BBFrameworks/BBFoundation`, contains functions, classes, and categories extending the `Foundation` framework
- `BBFrameworks/BBKeychain`, a wrapper around keychain related functions in the `Security` framework
- `BBFrameworks/BBBlocks`, adds block extension to the `Foundation` collection classes; modeled after Haskell list functions
- `BBFrameworks/BBKeyValueObserving`, block based wrapper around KVO supporting automatic deregistration upon deallocation of observers; modeled after [MAKVONotificationCenter](https://github.com/mikeash/MAKVONotificationCenter)
- `BBFrameworks/BBReachability`, modern wrapper around the `SystemConfiguration` framework reachability functionality
- `BBFrameworks/BBCoreData`, classes and categories extending the `CoreData` framework
- `BBFrameworks/BBKit`, functions, classes, and categories extending the `UIKit` and `AppKit` frameworks
- `BBFrameworks/BBAddressBook`, wrapper around the `AddressBook` framework
- `BBFrameworks/BBThumbnail`, classes for generating thumbnails from various URLs, both local and remote
- `BBFrameworks/BBReactiveThumbnail`, adds [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) extensions to `BBFrameworks/BBThumbnail`
- `BBFrameworks/BBMediaPicker`, replacement for asset selection portion of `UIImagePickerController`, modeled after the interface found in the Facebook iOS application
- `BBFrameworks/BBMediaViewer`, replacement for the functionality provided by the `QuickLook` framework on iOS
- `BBFrameworks/BBMediaPlayer`, replacement for the functionality provided by `MPMoviePlayerController` and related classes that are part of the `MediaPlayer` framework
- `BBFrameworks/BBWebKit`, provides an embeddable browser based on `WKWebView`, modeled after similar browsers fround in the Facebook and Twitter iOS applications
- `BBFrameworks/BBTooltip`, classes to create and display informational tooltips similar to the tooltip functionality available in the Facebook iOS SDK
- `BBFrameworks/BBValidation`, provides validation functionality that can be attached to `UITextField` and `UITextView` instances, providing feedback to the user
- `BBFrameworks/BBToken`, a `UITextView` subclass intended to replicate the functionality of `NSTokenField` in the `AppKit` framework on iOS; modeled after the functionality of the "To:" field in the Mail iOS application
- `BBFrameworks/BBForm`, functions, classes, and categories for creating Settings iOS application like form entry views

###Installation

Use cocoapods to install.
