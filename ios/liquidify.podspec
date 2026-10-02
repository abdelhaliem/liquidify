Pod::Spec.new do |s|
  s.name             = 'liquidify'
  s.version          = '0.1.0'
  s.summary          = 'Native Apple Liquid Glass effects for Flutter.'
  s.description      = <<-DESC
Liquidify provides seamless Apple-style Liquid Glass UI transformation
for Flutter widgets, using native UIGlassEffect on iOS 26+ with
graceful Flutter-based fallbacks on older versions.
                       DESC
  s.homepage         = 'https://github.com/Maharat-Alcode/liquidify'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Maharat-Alcode' => 'info@maharat-alcode.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '16.0'
  s.swift_version    = '5.9'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
end
