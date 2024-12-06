#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint windmill_ad_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'windmill_ad_plugin'
  s.version          = '4.2.1'
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
  s.dependency 'ToBid-iOS', '4.2.1'
  s.dependency 'ToBid-iOS/TouTiaoAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/CSJMediationAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/AdmobAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/MintegralAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/GDTAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/VungleAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/UnityAdsAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/KSAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/BaiduAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/KlevinAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/AdScopeAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/IronSourceAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/AppLovinAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/MSAdAdapter', '4.2.1'
  s.dependency 'ToBid-iOS/QuMengAdapter', '4.2.1'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
