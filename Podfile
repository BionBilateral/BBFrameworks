source "https://github.com/CocoaPods/Specs.git"

def common_pods
  pod "Archimedes", "~> 1.1.0"
  pod "BlocksKit/Core", "~> 2.2.0"
end

target :iOSDemo do
  platform :ios, "8.3"
  
  common_pods
  
  pod "ReactiveCocoa", "~> 2.4.0"
  pod "ReactiveViewModel", "~> 0.3.0"
  
  link_with ["BBFrameworksiOSDemo"]
end

target :OSXDemo do
  platform :osx, "10.10"
  
  common_pods
  
  pod "ReactiveCocoa", "~> 2.4.0"
  pod "ReactiveViewModel", "~> 0.3.0"
  
  link_with ["BBFrameworksOSXDemo"]
end

workspace "BBFrameworks"