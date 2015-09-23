source "https://github.com/CocoaPods/Specs.git"

def common_pods
  pod "JRSwizzle"
  pod "ReactiveCocoa", "~> 2.5.0"
  pod "ReactiveViewModel", "~> 0.3.0"
end

target :iOSDemo do
  platform :ios, "8.0"
  
  common_pods
  pod "TUSafariActivity", "~> 1.0.0"
  pod "ARChromeActivity", "~> 1.0.0"
  
  link_with ["BBFrameworksiOSDemo", "BBFrameworksTestsiOS"]
end

target :OSXDemo do
  platform :osx, "10.10"
  
  common_pods
  
  link_with ["BBFrameworksOSXDemo", "BBFrameworksTestsOSX"]
end

workspace "BBFrameworks"