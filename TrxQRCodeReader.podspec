Pod::Spec.new do |s|
  s.name             = 'TrxQRCodeReader'
  s.version          = '0.1.0'
  s.summary          = 'Reads QR codes'

  s.description      = <<-DESC
Reading of QR codes made easy
                       DESC

  s.homepage         = 'https://github.com/yaro812/TrxQRCodeReader'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yaroslav' => 'thorax@me.com' }
  s.source           = { :git => 'https://github.com/yaro812/TrxQRCodeReader.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.swift_version = '4.2'
  s.source_files = 'TrxQRCodeReader/Classes/**/*.{swift}'
end
