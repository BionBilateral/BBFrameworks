source "https://github.com/CocoaPods/Specs.git"

abstract_target "CommonPods" do
    pod "ReactiveCocoa", "~> 2.5"
    pod "ReactiveViewModel", "~> 0.3"
    
    abstract_target "iOSTargets" do
        platform :ios, "8.0"
        
        pod "TUSafariActivity", "~> 1.0.0"
        pod "ARChromeActivity", "~> 1.0.0"
        pod "FLAnimatedImage", "~> 1.0"
        
        target "BBFrameworksiOSDemo" do
        end
        
        target "BBFrameworksTestsiOS" do
        end
    end
    
    abstract_target "OSXTargets" do
        platform :osx, "10.10"
        
        target "BBFrameworksOSXDemo" do
        end
        
        target "BBFrameworksTestsOSX" do
        end
    end
end

workspace "BBFrameworks"
