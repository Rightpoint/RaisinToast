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
  s.version          = "1.0.5"
  s.summary          = "A UIWindow subclass used to message information to the users of your app."
  s.description      = <<-DESC
RaisinToast provides a messaging window layer and a default "toast" view controller, ideal for presenting errors, warnings and feedback throughout your app. Think of it as bringing the really useful messaging concept of Android Toast to iOS.

RaisinToast is simple to configure and minimizes the amount of notification code you have to add to your app to get consistent app-wide messaging.
                       DESC
  s.homepage         = "https://github.com/Raizlabs/RaisinToast"
  s.license          = 'MIT'
  s.author           = { "adamhrz" => "adam.howitt@raizlabs.com","arrouse" => "alex@raizlabs.com" }
  s.source           = { :git => "https://github.com/Raizlabs/RaisinToast.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/earnshavian'

  s.platform     = :ios, '7.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.[hm]'
  s.resources = "Pod/Assets/*.{xib}"

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
