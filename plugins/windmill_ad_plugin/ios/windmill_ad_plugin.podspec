#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint windmill_ad_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'windmill_ad_plugin'
  s.version          = '1.12.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://sigmob.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sigmob' => 'codi.zhao@sigmob.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.dependency 'ToBid-iOS', '1.12.1'
  s.dependency 'ToBid-iOS/TouTiaoAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/AdmobAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/AppLovinAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/MintegralAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/GDTAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/IronSourceAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/VungleAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/UnityAdsAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/KSAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/BaiduAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/KlevinAdapter', '1.12.1'
  s.dependency 'ToBid-iOS/AdScopeAdapter', '1.12.1'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
