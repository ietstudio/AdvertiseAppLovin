#
# Be sure to run `pod lib lint AdvertiseAppLovin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdvertiseAppLovin'
  s.version          = '0.1.2'
  s.summary          = 'AdvertiseAppLovin'
  s.description      = <<-DESC
AdvertiseAppLovin.
                       DESC

  s.homepage         = 'https://github.com/ietstudio/AdvertiseAppLovin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoyang' => 'gaoyang@joycastle.mobi' }
  s.source           = { :git => 'https://github.com/ietstudio/AdvertiseAppLovin.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.dependency 'GamePluginBase'
  s.frameworks = 'AdSupport', 'AVFoundation', 'CoreTelephony', 'CoreGraphics', 'CoreMedia', 'StoreKit', 'SystemConfiguration', 'UIKit'
  s.vendored_libraries = 'AdvertiseAppLovin/SDK/applovin-ios-sdk-3.3.1/libAppLovinSdk.a'
  s.source_files = 'AdvertiseAppLovin/Classes/**/*', 'AdvertiseAppLovin/SDK/applovin-ios-sdk-3.3.1/headers/*.h'
end
