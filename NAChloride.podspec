Pod::Spec.new do |s|

  s.name         = "NAChloride"
  s.version      = "1.0.8"
  s.summary      = "Objective-C library for libsodium (NaCl)"
  s.homepage     = "https://github.com/gabriel/NAChloride"
  s.license      = { :type => "MIT" }
  s.author       = { "Gabriel Handford" => "gabrielh@gmail.com" }
  s.source       = { :git => "https://github.com/gabriel/NAChloride.git", :tag => "1.0.8" }
  s.dependency 'libsodium'
  s.source_files = 'NAChloride/**/*.{c,h,m,macros}'
  s.requires_arc = true

end
