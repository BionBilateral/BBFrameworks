Pod::Spec.new do |spec|
  spec.name = "BBFrameworks"
  spec.version = "1.3.7"
  spec.authors = {"William Towe" => "will@bionbilateral.com", "Jason Anderson" => "jason@bionbilateral.com"}
  spec.license = {:type => "BSD", :file => "license.txt"}
  spec.homepage = "https://github.com/BionBilateral/BBFrameworks"
  spec.source = {:git => "https://github.com/BionBilateral/BBFrameworks.git", :tag => spec.version.to_s}
  spec.summary = "Repository for common iOS/OSX categories, classes, and functions."
  
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  
  spec.requires_arc = true
  
  spec.default_subspecs = "BBCore", "BBFoundation", "BBBlocks", "BBKit"
  
  spec.subspec "BBCore" do |subspec|
    subspec.source_files = "BBFrameworks"
    
    subspec.frameworks = "Foundation"
    
    subspec.ios.resource_bundles = {
      "BBFrameworksResources" => ["BBFrameworksResources/*.xib", "BBFrameworksResources/*.png", "BBFrameworksResources/*.lproj"]
    }
  end
  
  spec.subspec "BBFoundation" do |subspec|
    subspec.dependency "BBFrameworks/BBCore"
    
    subspec.source_files = "BBFrameworks/BBFoundation"
  end
  
  spec.subspec "BBBlocks" do |subspec|
    subspec.dependency "BBFrameworks/BBCore"
    
    subspec.source_files = "BBFrameworks/BBBlocks"
  end
  
  spec.subspec "BBKeyValueObserving" do |subspec|
    subspec.dependency "BBFrameworks/BBCore"
    
    subspec.source_files = "BBFrameworks/BBKeyValueObserving", "BBFrameworks/BBKeyValueObserving/Private"
    
    subspec.private_header_files = "BBFrameworks/BBKeyValueObserving/Private/*.h"
  end
  
  spec.subspec "BBCoreData" do |subspec|
    subspec.dependency "BBFrameworks/BBFoundation"
    
    subspec.source_files = "BBFrameworks/BBCoreData"
    
    subspec.ios.frameworks = "CoreData", "UIKit"
    subspec.osx.frameworks = "CoreData", "AppKit"
  end
  
  spec.subspec "BBKit" do |subspec|
    subspec.dependency "BBFrameworks/BBFoundation"
    
    subspec.source_files = "BBFrameworks/BBKit"
    subspec.ios.source_files = "BBFrameworks/BBKit/iOS", "BBFrameworks/BBKit/iOS/Private"
    subspec.osx.source_files = "BBFrameworks/BBKit/OSX"
    
    subspec.ios.private_header_files = "BBFrameworks/BBKit/iOS/Private/*.h"
    
    subspec.ios.frameworks = "UIKit", "Accelerate", "AVFoundation", "CoreImage"
    subspec.osx.frameworks = "AppKit", "Accelerate", "AVFoundation"
  end
  
  spec.subspec "BBReactiveKit" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBReactiveKit"
    subspec.ios.source_files = "BBFrameworks/BBReactiveKit/iOS"
    subspec.osx.source_files = "BBFrameworks/BBReactiveKit/OSX"
  end
  
  spec.subspec "BBAddressBook" do |subspec|
    subspec.dependency "BBFrameworks/BBBlocks"
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBAddressBook"
    subspec.osx.source_files = "BBFrameworks/BBAddressBook/BBAddressBook.h"
    
    subspec.ios.frameworks = "AddressBook"
  end
  
  spec.subspec "BBAddressBookUI" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.dependency "BBFrameworks/BBAddressBook"
    
    subspec.ios.source_files = "BBFrameworks/BBAddressBookUI"
    subspec.osx.source_files = "BBFrameworks/BBAddressBookUI/BBAddressBookUI.h"
  end
  
  spec.subspec "BBThumbnail" do |subspec|
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBThumbnail", "BBFrameworks/BBThumbnail/Private"
    subspec.ios.source_files = "BBFrameworks/BBThumbnail/iOS", "BBFrameworks/BBThumbnail/iOS/Private"
    subspec.osx.source_files = "BBFrameworks/BBThumbnail/OSX", "BBFrameworks/BBThumbnail/OSX/Private"
    
    subspec.private_header_files = "BBFrameworks/BBThumbnail/Private/*.h"
    subspec.ios.private_header_files = "BBFrameworks/BBThumbnail/iOS/Private/*.h"
    subspec.osx.private_header_files = "BBFrameworks/BBThumbnail/OSX/Private/*.h"
    
    subspec.frameworks = "WebKit"
    subspec.ios.frameworks = "MobileCoreServices"
    subspec.osx.frameworks = "QuickLook"
  end
  
  spec.subspec "BBReactiveThumbnail" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.dependency "BBFrameworks/BBThumbnail"
    
    subspec.source_files = "BBFrameworks/BBReactiveThumbnail"
  end
  
  spec.subspec "BBMediaPicker" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    subspec.ios.dependency "BBFrameworks/BBBlocks"
    
    subspec.ios.source_files = "BBFrameworks/BBMediaPicker"
    subspec.osx.source_files = "BBFrameworks/BBMediaPicker/BBMediaPicker.h"
    
    subspec.ios.frameworks = "AssetsLibrary"
  end
  
  spec.subspec "BBMediaPlayer" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.ios.dependency "BBFrameworks/BBBlocks"
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBMediaPlayer"
    subspec.osx.source_files = "BBFrameworks/BBMediaPlayer/BBMediaPlayer.h"
    
    subspec.ios.frameworks = "AVFoundation"
  end
  
  spec.subspec "BBWebKit" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "TUSafariActivity", "~> 1.0.0"
    subspec.ios.dependency "ARChromeActivity", "~> 1.0.0"
    
    subspec.ios.dependency "BBFrameworks/BBReactiveKit"
    
    subspec.ios.source_files = "BBFrameworks/BBWebKit"
    subspec.osx.source_files = "BBFrameworks/BBWebKit/BBWebKit.h"
    
    subspec.ios.frameworks = "WebKit"
  end
  
  spec.subspec "BBTooltip" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBTooltip"
    subspec.osx.source_files = "BBFrameworks/BBTooltip/BBTooltip.h"
  end
  
  spec.subspec "BBValidation" do |subspec|
    subspec.ios.dependency "BBFrameworks/BBTooltip"
    
    subspec.ios.source_files = "BBFrameworks/BBValidation"
    subspec.osx.source_files = "BBFrameworks/BBValidation/BBValidation.h"
  end
  
  spec.subspec "BBToken" do |subspec|
    subspec.ios.source_files = "BBFrameworks/BBToken"
    subspec.osx.source_files = "BBFrameworks/BBToken/BBToken.h"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.frameworks = "MobileCoreServices"
  end
  
  spec.subspec "BBForm" do |subspec|
    subspec.ios.dependency "BBFrameworks/BBFoundation"
    subspec.ios.dependency "BBFrameworks/BBKit"
    subspec.ios.dependency "BBFrameworks/BBBlocks"
    
    subspec.ios.source_files = "BBFrameworks/BBForm"
    subspec.osx.source_files = "BBFrameworks/BBForm/BBForm.h"
  end
  
  spec.subspec "BBReachability" do |subspec|
    subspec.dependency "BBFrameworks/BBFoundation"
    
    subspec.source_files = "BBFrameworks/BBReachability"
    
    subspec.frameworks = "SystemConfiguration"
  end
end