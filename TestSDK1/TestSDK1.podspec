Pod::Spec.new do |s|
  s.name         = "TestSDK1"
  s.version      = "0.0.1"
  s.summary      = "A short description of TestSDK1."

  s.description  = <<-DESC
                    TestSDK1
                   DESC

  s.homepage     = "https://github.com/hssdx/TestSDK1"
  # s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "hssdx" => "hssdx@qq.com" }
  s.platform     = :ios, '8.0'
  s.source       = { :git => 'https://github.com/hssdx/TestSDK1.git', :tag => s.version }

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
