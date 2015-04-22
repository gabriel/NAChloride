Pod::Spec.new do |s|

  s.name         = "NAChloride"
  s.version      = "1.2.12"
  s.summary      = "Objective-C library for libsodium (NaCl)"
  s.homepage     = "https://github.com/gabriel/NAChloride"
  s.license      = { :type => "MIT" }
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/NAChloride.git", :tag => s.version.to_s }
  s.dependency 'libsodium-gabriel', >= "10.0.2"
  s.source_files = 'NAChloride/**/*.{c,h,m}'
  s.requires_arc = true

  s.ios.platform = :ios, "7.0"
  s.ios.deployment_target = "7.0"

  s.osx.platform = :osx, "10.8"
  s.osx.deployment_target = "10.8"

end
