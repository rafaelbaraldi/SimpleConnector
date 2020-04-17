#
# Be sure to run `pod lib lint SimpleConnector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SimpleConnector'
  s.version          = '1.0.0'
  s.summary          = 'A simple framework to perform HTTP request in Swift'

  s.description      = <<-DESC
A simple framework to perform HTTP request in Swift.
                       DESC

  s.homepage         = 'https://github.com/rafaelbaraldi/SimpleConnector'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rafaelbaraldi' => 'rafael_baraldi_13@hotmail.com' }
  s.source           = { :git => 'https://github.com/rafaelbaraldi/SimpleConnector.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rafaelbaraldi'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'SimpleConnector/Classes/**/*'
  
end
