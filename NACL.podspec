Pod::Spec.new do |s|

  s.name         = "NACL"
  s.version      = "1.0.0"
  s.summary      = "Objective-C library for NaCl crypto library"
  s.homepage     = "https://github.com/gabriel/NACL"
  s.license      = { :type => "MIT" }
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/NACL.git", :tag => "1.0.0" }
  s.platform     = :ios, '7.0'
  s.dependency 'libsodium-ios'
  s.source_files = 'NACL/**/*.{c,h,m}'
  s.requires_arc = true

end
