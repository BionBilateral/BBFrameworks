source "https://github.com/CocoaPods/Specs.git"

use_frameworks!

def common_pods
  pod "Archimedes", "~> 1.1.0"
  pod "BlocksKit/Core", "~> 2.2.0"
  pod "ReactiveCocoa", "~> 2.5.0"
  pod "ReactiveViewModel", "~> 0.3.0"
end

target :iOSFrameworks do
  platform :ios, "8.3"
  
  common_pods
  
  link_with ["BBFrameworksiOS"]
end

target :OSXFrameworks do
  platform :osx, "10.10"
  
  common_pods
  
  link_with ["BBFrameworksOSX"]
end

target :iOSDemo do
  platform :ios, "8.3"
  
  pod "BBFrameworks", :path => "BBFrameworks.podspec"
  
  link_with ["BBFrameworksiOSDemo"]
end

target :OSXDemo do
  platform :osx, "10.10"
  
  pod "BBFrameworks", :path => "BBFrameworks.podspec"
  
  link_with ["BBFrameworksOSXDemo"]
end

workspace "BBFrameworks"