#
#  Be sure to run `pod spec lint AntennaSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "AntennaSDK"
  s.version      = "0.0.1.9"
  s.summary      = "iOS 事件统计组件"
  s.description  = <<-DESC
  iOS 事件统计组件
                   DESC

  s.homepage     = "https://gitlab.renrenche.com/ios/AntennaSDK"
  s.license      = "MIT"
  s.author             = { "wangjianyu" => "wangjianyu@renrenche.com" }
  s.platform     = :ios, "8.0"

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://gitlab.renrenche.com/ios/AntennaSDK.git", :tag => s.version }

  #s.source_files  = "AntennaSDK", "AntennaSDK/*.{h,m}","AntennaSDK/Anchor/*.{h,m}","AntennaSDK/Antenna/*.{h,m}","AntennaSDK/EventInterceptor/*.{h,m}","AntennaSDK/Constans/*.{h,m}"

  #s.public_header_files = "AntennaSDK/*.h","AntennaSDK/Anchor/*.h","AntennaSDK/Antenna/*.h","AntennaSDK/EventInterceptor/*.h","AntennaSDK/Constans/*.h"

  s.subspec 'Constans' do |ss|
    ss.public_header_files = 'AntennaSDK/Constans/*.h'
    ss.source_files = 'AntennaSDK/Constans/*.{h,m}'
  end

  s.subspec 'Anchor' do |ss|
    ss.public_header_files = 'AntennaSDK/Anchor/*.h'
    ss.source_files = 'AntennaSDK/Anchor/*.{h,m}'
  end

  s.subspec 'Antenna' do |ss|
    ss.public_header_files = 'AntennaSDK/Antenna/*.h'
    ss.source_files = 'AntennaSDK/Antenna/*.{h,m}'
    ss.dependency 'AntennaSDK/Constans'
  end

  s.subspec 'EventInterceptor' do |ss|
    ss.public_header_files = 'AntennaSDK/EventInterceptor/*.h'
    ss.source_files = 'AntennaSDK/EventInterceptor/*.{h,m}'
    ss.dependency 'AntennaSDK/Anchor'
    ss.dependency 'AntennaSDK/Constans'
    ss.dependency 'AntennaSDK/Antenna'
  end

  s.subspec 'AntennaSDK' do |ss|
    ss.public_header_files = 'AntennaSDK/*.h'
    ss.source_files = 'AntennaSDK/*.{h,m}'
    ss.dependency 'AntennaSDK/Constans'
    ss.dependency 'AntennaSDK/Anchor'
    ss.dependency 'AntennaSDK/Antenna'
    ss.dependency 'AntennaSDK/EventInterceptor'
  end



  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  
  s.dependency "AFNetworking", "~>3.1.0"
  s.dependency "Aspects", "~>1.4.1"
  s.dependency "Base64", "~>1.1.2"
  s.dependency "GZIP", "~>1.1.1"
  s.dependency "LKArchiver", "~>1.3.1"
  s.dependency "MD5Digest", "~>1.1.0"
  s.dependency "NSURL+QueryDictionary", "~>1.2.0"
  s.dependency "SDVersion", "~>4.3.1"
  s.dependency "UMengAnalytics-NO-IDFA", "~>4.2.5"


end
