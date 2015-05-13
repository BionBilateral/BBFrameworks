source "https://github.com/CocoaPods/Specs.git"

def common_pods
  pod "Archimedes", "~> 1.1.0"
  pod "BlocksKit/Core", "~> 2.2.0"
  pod "ReactiveViewModel", "~> 0.3.0"
  pod "ReactiveCocoa", "~> 2.4.0"
end

target :iOSDemo do
  common_pods
  
  link_with ["BBFrameworksiOSDemo"]
end

target :OSXDemo do
  common_pods
  
  link_with ["BBFrameworksOSXDemo"]
end

workspace "BBFrameworks"