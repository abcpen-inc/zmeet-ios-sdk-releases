platform :ios, '11.0'
workspace 'ZMeetDemo'

target 'ZMeetDemo' do
  pod 'AFNetworking'
  pod 'SVProgressHUD'
  pod 'Masonry'
  pod 'MyLayout'
  pod 'ZMeetSDK',:path=> './'
  project 'ZMeetDemo/ZMeetDemo.xcodeproj'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
