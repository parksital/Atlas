# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Atlas' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # ignore all warnings for all pods
  inhibit_all_warnings!

  # Pods for Atlas
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'AWSCore'
  pod 'AWSAppSync'
  pod 'AWSMobileClient'

  target 'AtlasTests' do
    
    # Pods for testing
    pod 'SnapshotTesting'
  end

  target 'AtlasUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
