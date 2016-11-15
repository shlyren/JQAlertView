
Pod::Spec.new do |s|
  s.name         = "JQAlertView"
  s.version      = "1.0.1"
  s.summary      = "一个类似于微信的alertView"
  s.homepage     = "https://yuxiang.ren"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "shlyren" => "shlyren@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/shlyren/JQAlertView.git", :tag => "#{s.version}" }

  s.requires_arc =  true
  #s.public_header_files = 'JQAlertView/JQAlertView.h'
  s.source_files = "JQAlertView/*.{h,m}"
  
end
