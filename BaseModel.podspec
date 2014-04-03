Pod::Spec.new do |s|
  s.name         = "BaseModel"
  s.version      = "0.0.1"
  s.summary      = "Class mapper"
  s.description  = "Simple class mapper"
  s.homepage     = "https://github.com/alekoleg/BaseModel"
  s.license      = 'MIT'
  s.author       = { "Oleg Alekseenko" => "alekoleg@gmail.com" }
  s.source       = { :git => "https://github.com/alekoleg/BaseModel", :tag => s.version.to_s}
  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.{h,m}'
  s.public_header_files = 'Classes/*.h'
  s.frameworks = 'Foundation', 
  
end
