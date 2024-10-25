Pod::Spec.new do |s|
  s.name = "KSUAdDebugTool"
  s.version = "3.3.49"
  s.summary = "\u5FEB\u624B\u8054\u76DFSDK iOS\u7AEF KSUAdDebugTool \u7EC4\u4EF6"
  s.authors = {"lishuyi"=>"lishuyi@kuaishou.com"}
  s.homepage = "https://git.corp.kuaishou.com/AdUnion/KSAdSDK"
  s.description = "\u5FEB\u624B\u8054\u76DFSDK iOS\u7AEF KSUAdDebugTool \u7EC4\u4EF6\uFF0C\u81EA\u52A8\u751F\u6210\u7684podspec"
  s.requires_arc = true
  s.source = { :path => '.' }

  sources = ['KSUAdDebugTool']
  s.ios.deployment_target    = '11.0'
  s.ios.source_files = sources.map { |path| path + '/**/*.h' }
  s.ios.vendored_libraries   = sources.map { |path| path + '/**/*.a' }
  s.ios.resource = sources.map { |path| path + '/**/*.bundle' }
end
