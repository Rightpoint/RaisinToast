#
# Be sure to run `pod lib lint RaisinToast.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RaisinToast"
  s.version          = "0.1.0"
  s.summary          = "A UIWindow subclass used to message information to the users of your app."
  s.description      = <<-DESC
                       An optional longer description of RaisinToast

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/Raizlabs/RaisinToast"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "adamhrz" => "adam.howitt@raizlabs.com" }
  s.source           = { :git => "https://github.com/Raizlabs/RaisinToast.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/earnshavian'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.[hm]'
  s.resource_bundles = {
    'RaisinToast' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
