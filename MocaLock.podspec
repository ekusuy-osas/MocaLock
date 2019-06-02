Pod::Spec.new do |spec|
  spec.name         = "MocaLock"
  spec.version      = "0.1.1"
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '11.0'
  spec.summary      = "It is a library for displaying the password lock screen in the iOS application."
  spec.homepage     = "https://github.com/ekusuy-osas/MocaLock"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "yusuke.sasou" => "s2ysk.dev@gmail.com" }
  spec.source       = { :git => "https://github.com/ekusuy-osas/MocaLock.git", :tag => "#{spec.version}" }
  spec.source_files  = 'MocaLock/**/*.{swift}'
  spec.exclude_files = 'MocaLock/**/*.{xib,png}'
end
