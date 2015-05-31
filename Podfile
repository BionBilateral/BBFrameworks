source "https://github.com/CocoaPods/Specs.git"

use_frameworks!

def common_pods
  pod "Archimedes", "~> 1.1.0"
  pod "BlocksKit/Core", "~> 2.2.0"
  pod "ReactiveCocoa", "~> 2.5.0"
  pod "ReactiveViewModel", "~> 0.3.0"
end

target :iOSDemo do
  platform :ios, "8.3"
  
  common_pods
  
  link_with ["BBFrameworksiOS"]
end

target :OSXDemo do
  platform :osx, "10.10"
  
  common_pods
  
  link_with ["BBFrameworksOSX"]
end

workspace "BBFrameworks"