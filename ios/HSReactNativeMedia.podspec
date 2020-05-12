require 'json'

package = JSON.parse(File.read(File.join(__dir__, '../package.json')))
version = package['version']

Pod::Spec.new do |s|
  s.name                   = 'HSReactNativeMedia'
  s.version                = version
  s.homepage               = 'https://github.com/jonbrennecke/react-native-media'
  s.author                 = 'Jon Brennecke'
  s.platforms              = { :ios => '11.0' }
  s.source                 = { :git => 'https://github.com/jonbrennecke/react-native-media.git', :tag => "v#{version}" }
  s.cocoapods_version      = '>= 1.2.0'
  s.license                = 'MIT'
  s.summary                = 'iOS react-native library of photo and video library utilities'
  s.source_files           = 'Source/**/*.{swift,h,m}'
  s.swift_versions          = '5'
  s.dependency 'React'
  s.static_framework = true
end
