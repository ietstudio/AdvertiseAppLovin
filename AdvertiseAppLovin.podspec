#
# Be sure to run `pod lib lint AdvertiseAppLovin.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdvertiseAppLovin'
  s.version          = '0.1.4'
  s.summary          = 'AdvertiseAppLovin'
  s.description      = <<-DESC
AdvertiseAppLovin.
                       DESC

  s.homepage         = 'https://github.com/ietstudio/AdvertiseAppLovin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gaoyang' => 'gaoyang@joycastle.mobi' }
  s.source           = { :git => 'https://github.com/ietstudio/AdvertiseAppLovin.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'

  s.source_files = 'AdvertiseAppLovin/Classes/**/*'

  s.dependency 'GamePluginBase'
  s.dependency 'AppLovin-SDK'

end
