Pod::Spec.new do |s|

  s.name         = "VIMNetworking"
  s.version      = "6.0.4"
  s.summary      = "The Vimeo iOS SDK"
  s.description  = <<-DESC
                   VIMNetworking is an Objective-C library that enables interaction with the Vimeo API. It handles authentication, request submission and cancellation, and video upload. Advanced features include caching and powerful model object parsing.
                   DESC

  s.homepage     = "https://github.com/vimeo/VIMNetworking"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }

  s.authors            = { "Alfie Hanssen" => "alfie@vimeo.com",
                            "Rob Huebner" => "robh@vimeo.com",
                            "Gavin King" => "gavin@vimeo.com",
                            "Kashif Muhammad" => "support@vimeo.com",
                            "Andrew Whitcomb" => "support@vimeo.com",
                            "Stephen Fredieu" => "support@vimeo.com",
                            "Rahul Kumar" => "support@vimeo.com" }

  s.social_media_url   = "http://twitter.com/vimeoapi"

  s.platform     = :ios, "8.0"

  s.requires_arc = true
  s.source = { :git => "https://github.com/vimeo/VIMNetworking.git", :tag => s.version.to_s }

  s.source_files = 'VIMNetworking/Networking/**/*.{h,m}'
  s.frameworks = "Foundation", "UIKit", "Security", "CoreGraphics", "AVFoundation"
  s.dependency	'AFNetworking/NSURLSession', '2.6.3'
  s.dependency	'AFNetworking/NSURLConnection', '2.6.3'

  s.subspec 'Cache' do |ss|
    ss.source_files = 'VIMNetworking/Cache/*.{h,m}'
    ss.frameworks = 'Foundation', 'UIKit'
  end

  s.subspec 'Keychain' do |ss|
    ss.source_files = 'VIMNetworking/Keychain/*.{h,m}'
    ss.frameworks = 'Foundation', 'Security'
  end

  s.subspec 'ObjectMapper' do |ss|
    ss.source_files = 'VIMNetworking/ObjectMapper/**/*.{h,m}'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'Model' do |ss|
    ss.source_files = 'VIMNetworking/Model/**/*.{h,m}'
    ss.frameworks = 'Foundation', 'CoreGraphics', 'AVFoundation'
    ss.dependency	'VIMNetworking/ObjectMapper'
  end

  s.subspec 'Private' do |ss|
    ss.source_files = 'VIMNetworking/Private/**/*.{h,m}'
    ss.frameworks = 'Foundation', 'UIKit'
    ss.dependency 'VIMNetworking/Model'
  end

end
