Pod::Spec.new do |s|
  s.name             = 'liquidify'
  s.version          = '0.1.0'
  s.summary          = 'Native Apple Liquid Glass effects for Flutter.'
  s.description      = <<-DESC
Liquidify provides seamless Apple-style Liquid Glass UI transformation
for Flutter widgets, using native glass effects on macOS with
graceful Flutter-based fallbacks on older versions.
                       DESC
  s.homepage         = 'https://github.com/Maharat-Alcode/liquidify'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Maharat-Alcode' => 'info@maharat-alcode.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform         = :osx, '10.15'
  s.swift_version    = '5.9'

  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
  }
end
