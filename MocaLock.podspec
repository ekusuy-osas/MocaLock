Pod::Spec.new do |spec|
  spec.name         = "MocaLock"
  spec.version      = "0.0.1"
  spec.summary      = "It is a library for displaying the password lock screen in the iOS application."
  spec.description  = <<-DESC
                   DESC
  spec.homepage     = "https://github.com/ekusuy-osas/MocaLock"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "yusuke.sasou" => "s2ysk.dev@gmail.com" }
  spec.source       = { :git => "https://github.com/ekusuy-osas/MocaLock.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
end
