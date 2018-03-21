Pod::Spec.new do |s|

  s.name         = "RedAlert"
  s.version      = "1.0.2"
  s.summary      = "Small iOS library for presenting UIAlertController in a UIAlertView fashion."
  s.homepage     = "https://github.com/vlas-voloshin/RedAlert"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "Vlas Voloshin"
  s.social_media_url = "http://twitter.com/argentumko"

  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/vlas-voloshin/RedAlert.git", :tag => "#{s.version}" }
  s.source_files = "RedAlert", "Classes/**/*.{h,m,swift}"
  s.framework    = "UIKit"
  s.requires_arc = true

end
