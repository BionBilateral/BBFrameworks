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
    subspec.ios.source_files = "BBFrameworks/BBKit/iOS"
    subspec.osx.source_files = "BBFrameworks/BBKit/OSX"
    
    subspec.ios.frameworks = "UIKit", "Accelerate", "AVFoundation"
    subspec.osx.frameworks = "AppKit", "Accelerate", "AVFoundation"
  end
  
  spec.subspec "BBReactiveKit" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBReactiveKit"
    subspec.ios.source_files = "BBFrameworks/BBReactiveKit/iOS"
    subspec.osx.source_files = "BBFrameworks/BBReactiveKit/OSX"
    
    subspec.resources = "BBFrameworks/BBReactiveKit/*.xib"
  end
  
  spec.subspec "BBThumbnail" do |subspec|
    subspec.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.dependency "BBFrameworks/BBKit"
    
    subspec.source_files = "BBFrameworks/BBThumbnail"
    
    subspec.frameworks = "WebKit"
    subspec.ios.frameworks = "MobileCoreServices"
    subspec.osx.frameworks = "QuickLook"
  end
  
  spec.subspec "BBReactiveThumbnail" do |subspec|
    subspec.dependency "BBFrameworks/BBThumbnail"
    
    subspec.source_files = "BBFrameworks/BBReactiveThumbnail"
  end
  
  spec.subspec "BBMediaPicker" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBMediaPicker"
    subspec.osx.source_files = "BBFrameworks/BBMediaPicker/BBMediaPicker.h"
    
    subspec.ios.resources = "BBFrameworks/BBMediaPicker/*.xib"
    
    subspec.ios.frameworks = "Photos"
  end
  
  spec.subspec "BBMediaPlayer" do |subspec|
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "ReactiveViewModel", "~> 0.3.0"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBMediaPlayer"
    subspec.osx.source_files = "BBFrameworks/BBMediaPlayer/BBMediaPlayer.h"
    
    subspec.ios.resources = "BBFrameworks/BBMediaPlayer/*.xib", "BBFrameworks/*.lproj/MediaPlayer.strings"
    
    subspec.ios.frameworks = "AVFoundation"
  end
  
  spec.subspec "BBWebKit" do |subspec|
    subspec.ios.dependency "Archimedes", "~> 1.1.0"
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    subspec.ios.dependency "TUSafariActivity", "~> 1.0.0"
    subspec.ios.dependency "ARChromeActivity", "~> 1.0.0"
    
    subspec.ios.dependency "BBFrameworks/BBReactiveKit"
    
    subspec.ios.source_files = "BBFrameworks/BBWebKit"
    subspec.osx.source_files = "BBFrameworks/BBWebKit/BBWebKit.h"
    
    subspec.ios.frameworks = "WebKit"
  end
  
  spec.subspec "BBTooltip" do |subspec|
    subspec.ios.dependency "Archimedes", "~> 1.1.0"
    subspec.ios.dependency "ReactiveCocoa", "~> 2.5.0"
    
    subspec.ios.dependency "BBFrameworks/BBKit"
    
    subspec.ios.source_files = "BBFrameworks/BBTooltip"
    subspec.osx.source_files = "BBFrameworks/BBTooltip/BBTooltip.h"
  end
end