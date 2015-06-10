Pod::Spec.new do |spec|
  spec.name = "BBFrameworks"
  spec.version = "0.0.1"
  spec.authors = {"William Towe" => "will@bionbilateral.com", "Jason Anderson" => "jason@bionbilateral.com"}
  spec.license = {:type => "BSD", :file => "license.txt"}
  spec.homepage = "https://github.com/BionBilateral/BBFrameworks"
  spec.source = {:git => "git@github.com:BionBilateral/BBFrameworks.git", :tag => spec.version.to_s}
  spec.summary = "Repository for common iOS/OSX categories, classes, and functions."
  
  spec.ios.deployment_target = "8.3"
  spec.osx.deployment_target = "10.10"
  
  spec.requires_arc = true
  
  spec.dependency "BlocksKit/Core", "~> 2.2.0"
  
  spec.subspec "BBFoundation" do |subspec|
    subspec.source_files = "BBFrameworks/BBFoundation"
    
    subspec.frameworks = "Foundation"
  end
  
  spec.subspec "BBCoreData" do |subspec|
    subspec.dependency "BBFrameworks/BBFoundation"
    
    subspec.source_files = "BBFrameworks/BBCoreData"
    
    subspec.ios.frameworks = "CoreData", "UIKit"
    subspec.osx.frameworks = "CoreData", "AppKit"
  end
  
  spec.subspec "BBKit" do |subspec|
    subspec.dependency "Archimedes", "~> 1.1.0"
    
    subspec.dependency "BBFrameworks/BBFoundation"
    
    subspec.source_files = "BBFrameworks/BBKit"
    
    subspec.ios.exclude_files = "BBFrameworks/BBKit/NSColor+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/NSImage+BBKitExtensions.{h,m}"
    subspec.osx.exclude_files = "BBFrameworks/BBKit/UIColor+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/UIImage+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/UIView+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/UIViewController+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/UIFont+BBKitExtensions.{h,m}", "BBFrameworks/BBKit/UIBarButtonItem+BBKitExtensions.{h,m}"
    
    subspec.ios.frameworks = "UIKit", "Accelerate", "AVFoundation"
    subspec.osx.frameworks = "AppKit", "Accelerate", "AVFoundation"
  end
  
  spec.subspec "BBReactiveKit" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.ios.dependency "TUSafariActivity", "~> 1.0.0"
    subspec.ios.dependency "ARChromeActivity", "~> 1.0.0"
    
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBReactiveKit"
    
    subspec.osx.exclude_files = "BBFrameworks/BBReactiveKit/BBProgressNavigationBar.{h,m}", "BBFrameworks/BBReactiveKit/BBWebKitViewController.{h,m}", "BBFrameworks/BBReactiveKit/BBWebKitViewControllerDelegate.h", "BBFrameworks/BBReactiveKit/BBWebKitTitleView.{h,m}"
  end
  
  spec.subspec "BBThumbnail" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBThumbnail"
    
    subspec.ios.frameworks = "MobileCoreServices"
    subspec.osx.frameworks = "QuickLook"
  end
  
  spec.subspec "BBReactiveThumbnail" do |subspec|
    subspec.dependency "BBFrameworks/BBThumbnail"
    
    subspec.source_files = "BBFrameworks/BBReactiveThumbnail"
  end
end