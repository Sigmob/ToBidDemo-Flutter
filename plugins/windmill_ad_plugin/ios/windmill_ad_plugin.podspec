#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint windmill_ad_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'windmill_ad_plugin'
  s.version          = '3.7.5'
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
  # s.static_framework = true
  s.dependency 'ToBid-iOS', '3.7.5'
  s.dependency 'ToBid-iOS/TouTiaoAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/CSJMediationAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/AdmobAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/MintegralAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/GDTAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/VungleAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/UnityAdsAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/KSAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/BaiduAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/KlevinAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/AdScopeAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/IronSourceAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/AppLovinAdapter', '3.7.5'
  s.dependency 'ToBid-iOS/MSAdAdapter', '3.7.5'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
