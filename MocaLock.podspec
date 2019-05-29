Pod::Spec.new do |spec|
  spec.name         = "EasyPassword"
  spec.version      = "0.0.1"
  spec.summary      = ""
  spec.description  = <<-DESC
                   DESC
  spec.homepage     = "https://github.com/ekusuy-osas/EasyPassword"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { "yusuke.sasou" => "s2ysk.dev@gmail.com" }
  spec.source       = { :git => "https://github.com/ekusuy-osas/EasyPassword.git", :tag => "#{spec.version}" }
  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"
end
