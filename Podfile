target :'CalendarTest' do
    use_frameworks!
    platform :ios, '8.0'
    pod 'Alamofire', '~> 3.1'
    pod 'BXProgressHUD'

end

post_install do | installer |
require 'fileutils'
FileUtils.cp_r('Pods/Target Support Files/Pods-CalendarTest/Pods-CalendarTest-acknowledgements.plist', 'CalendarTest/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end