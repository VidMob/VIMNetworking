Pod::Spec.new do |s|

  s.name         = "VIMNetworking"
  s.version      = "6.0.1"
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

  s.source_files = 'VIMNetworking/**/*.{h,m}'
  s.frameworks = "Foundation", "UIKit", "Security"

  s.subspec 'Model' do |ss|
    ss.source_files = 'VIMNetworking/Model/*.{h,m}'
    ss.frameworks = 'Foundation', 'CoreGraphics', 'AVFoundation'
    ss.dependency	'VIMObjectMapper', '6.0.1'
  end

  s.dependency	'AFNetworking', '2.6.3'
  s.dependency	'VIMObjectMapper', '6.0.1'

end
