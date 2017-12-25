#
#  Be sure to run `pod spec lint YWNewCycleScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "YWNewCycleScrollView"
  s.version      = "1.0.0"
  s.summary      = " a scrollview  to 3D  scrollviw  and  present someThings"

  s.description  = <<-DESC "test somme  thongs  's definitely to your advantage. The "
                   DESC

  s.homepage     = "https://github.com/shanlaing/YWNewCycleScrollView"
  s.license      = "MIT"
  s.author             = { "yishanliang" => "yishanliang@zillionfortune.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/shanlaing/YWNewCycleScrollView.git", :tag => "#{s.version}" }
  s.source_files  = "newSub/**/*.{h,m}"
  s.framework    = "UIKit"
  s.requires_arc = true

  

end
