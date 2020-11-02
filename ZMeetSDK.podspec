Pod::Spec.new do |s|
  s.name             = 'ZMeetSDK'
  s.version          = '1.0.0'
  s.summary          = 'ZMeet iOS SDK'
  s.description      = 'ZMeet 云会议'
  s.homepage         = 'https://www.abcpen.com'
  s.license          = 'MIT'
  s.authors          = 'bing@abcpen.com'
  s.source           = { :git => 'https://github.com/abcpen-inc/zmeet-ios-sdk-releases.git', :tag => s.version }

  s.platform         = :ios, '11.0'

  s.vendored_frameworks = 'Frameworks/ZmeetCoreKit.framework', 'Frameworks/WebRTC.framework'

  s.public_header_files = 'Frameworks/ZmeetCoreKit.framework/Headers/ZmeetCoreKit.h'
  s.source_files        = 'Frameworks/ZmeetCoreKit.framework/Headers/*.{h}'

  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
