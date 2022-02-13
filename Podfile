# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FoodFox' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FoodFox
# Pods for FoodFox
pod 'SwiftLint', '~> 0.27.0'               #Required
pod 'IQKeyboardManagerSwift', '~> 6.5.0'   #Required http://fabfile.org
#pod 'Fabric' , '~> 1.10.2'                  #Required
#pod 'Crashlytics', '~> 3.14.0'              #Required
pod 'Alamofire', '~> 4.5.1'                #Required
pod 'MBProgressHUD', '~> 1.1.0'            #Required
pod 'KeychainAccess', '~> 3.1.0'           #Required
pod 'R.swift', '~> 5.0.0.alpha.2'               #Required
pod 'GoogleMaps'#, '~> 3.1.0'
pod 'GooglePlaces'#, '~> 3.1.0'
pod 'GoogleSignIn'#, '~> 5.0.0'
pod 'Kingfisher', '4.10.0’
#pod 'Hippo', '2.1.22'
pod 'FRHyperLabel', '~> 1.0.4'
pod 'FBSDKCoreKit', '~> 12.3'
pod 'FBSDKLoginKit', '~> 12.3'
#pod 'FBSDKShareKit'
pod "MBCircularProgressBar"
pod 'Firebase/Auth'
pod 'SwiftyJSON'
pod 'razorpay-pod'


end
post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '4.2'
end
end
end
