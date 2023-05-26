#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ymchat_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ymchat_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to integrate with yellow.ai chatbot'
  s.description      = <<-DESC
Flutter plugin to integrate with yellow.ai chatbot
                       DESC
  s.homepage         = 'https://yellow.ai/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Purushottam' => 'purushottam.yadav@yellow.ai' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'YMChat', '~> 1.11'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
