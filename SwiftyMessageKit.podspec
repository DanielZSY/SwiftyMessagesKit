#
# Be sure to run `pod lib lint SwiftyMessageKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
# 1. new code update github, Release new version
# 2. local not code : pod repo add SwiftyMessageKit  https://github.com/cdzhangshuangyu/SwiftyMessageKit.git
#    local uodate code: cd ~/.cocoapods/repos/SwiftyMessageKit. Then execute: pod repo update SwiftyMessageKit
# 3. pod repo push SwiftyMessageKit SwiftyMessageKit.podspec --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
# 4. pod trunk push SwiftyMessageKit.podspec --allow-warnings
# 5. pod install or pod update on you project execute


Pod::Spec.new do |s|
  s.name             = 'SwiftyMessageKit'
  s.version          = '1.0.0'
  s.summary          = 'SwiftyMessageKit'
  s.module_name      = 'SwiftyMessageKit'
  s.description      = <<-DESC
  Common SwiftyMessageKit
  DESC
  
  s.homepage         = 'https://github.com/cdzhangshuangyu'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cdzhangshuangyu' => 'cdzhangshuangyu@163.com' }
  s.source           = { :git => 'https://github.com/cdzhangshuangyu/SwiftyMessageKit.git', :tag => s.version.to_s }
  
  s.swift_versions   = "5"
  s.ios.deployment_target = '10.0'
  s.platform     = :ios, '10.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
  
  s.static_framework = true
  s.source_files     = 'SwiftyMessageKit/Classes/**/*.{h,m,swift}'
  s.resources = ['SwiftyMessageKit/Assets/**/*.strings']
  s.ios.resource_bundle = {
    'SwiftyMessageKit' => 'SwiftyMessageKit/Assets/Media.xcassets',
    'SwiftyMessageCallKit' => 'SwiftyMessageKit/Assets/Call.bundle',
    'KKMuteSwitchListener' => 'SwiftyMessageKit/Assets/KKMuteSwitchListener.bundle'
  }
  
  s.frameworks   = 'UIKit', 'Foundation', 'CoreLocation', 'SystemConfiguration', 'CoreTelephony', 'Security', 'AVKit', 'MapKit'
  s.libraries    = 'z', 'sqlite3', 'c++'
  
  s.dependency 'AgoraRtm_iOS'
  s.dependency 'AgoraRtcEngine_iOS'
  
  s.dependency 'OneSignal', '>= 2.11.2', '< 3.0'
  
  s.dependency 'SVGAPlayer'
  s.dependency 'Starscream'
  s.dependency 'SwiftBasicKit'
  s.dependency 'AlamofireNetworkActivityIndicator'
end
