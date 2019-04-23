Pod::Spec.new do |s|
  s.name         = "TestSDK2"
  s.version      = "0.0.1"
  s.summary      = "A short description of TestSDK2."

  s.description  = <<-DESC
  TestSDK2
                   DESC

  s.homepage     = "https://github.com/hssdx/TestSDK2"
  # s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "hssdx" => "hssdx@qq.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/hssdx/TestSDK2.git', :tag => s.version }

  s.source_files = [
    "FuncAddr/**/*.{h,m}",
    "src/**/*.{h,m}",
  ]

  s.public_header_files = ["FuncAddr/**/*.h", "src/**/*.h"]

#  s.vendored_frameworks = "WeChatSDK/libWeChatSDK.a"

  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true

  # s.dependency 'Masonry'

end
