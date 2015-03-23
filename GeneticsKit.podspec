Pod::Spec.new do |s|
s.name         = "GeneticsKit"
s.version      = "0.2.0"
s.summary      = "Simple and flexible mapping for any object."
s.homepage     = "https://github.com/zradke/GeneticsKit"
s.license      = 'MIT'
s.author       = { "Zach Radke" => "zach.radke@gmail.com" }
s.source       = { :git => "https://github.com/zradke/GeneticsKit.git", :tag => s.version.to_s }
s.platform     = :ios, '7.0'
s.requires_arc = true
s.source_files = 'Pod/Classes/**/*'
end
