Pod::Spec.new do |spec|

  spec.name         = "trrabyte"
  spec.version      = "0.0.1"
  spec.summary      = "Framework created to develop in an easy way, getting implementation of components faster"

  spec.description  = Framework created to develop in an easy way, getting implementation of components faster. It includes Alert, Connections, Dropdown, Utils.

  spec.homepage     = "https://github.com/YaelLG/FrameworkSwift"
 
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "YaelLuna" => "yael@trrabyte.com" }
  
  spec.platform     = :ios, "11.0"
  
  spec.source       = { :git => "https://github.com/YaelLG/FrameworkSwift", :tag => "0.0.1" }

  spec.source_files  = "trrabyte/trrabyte/**/*{.swift}"
  spec.exclude_files = "Classes/Exclude"

end
