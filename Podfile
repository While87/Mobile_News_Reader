platform :ios, '10.0'

target 'Mobile News Reader' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'RealmSwift'

  # Pods for Mobile News Reader

  target 'Mobile News ReaderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Mobile News ReaderUITests' do
    # Pods for testing
  end

end

deployment_target = '10.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
            end
        end
        project.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = deployment_target
        end
    end
end
