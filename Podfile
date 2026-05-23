platform :ios, '16.0'

install! 'cocoapods',
  warn_for_unused_master_specs_repo: false

use_frameworks!
inhibit_all_warnings!

target 'Mira' do
  # Networking
  pod 'Alamofire', '~> 5.10'

  # SwiftUI-friendly remote image loading and caching
  pod 'Kingfisher', '~> 8.0'

  # Animation assets, usable from SwiftUI through lightweight wrappers
  pod 'lottie-ios', '~> 4.5'

  # Secure token and credential storage
  pod 'KeychainAccess', '~> 4.2'

  # Type-safe UserDefaults helpers for lightweight app preferences
  pod 'SwiftyUserDefaults', '~> 5.3'

  # SwiftUI toast and transient feedback views
  pod 'AlertToast', '~> 1.3'

  # Structured local logging during development
  pod 'SwiftyBeaver', '~> 2.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
    end
  end

  Dir.glob(File.join(installer.sandbox.root, 'Target Support Files', '**', '*.xcconfig')).each do |xcconfig_path|
    text = File.read(xcconfig_path)
    cleaned = text
      .gsub(' "${TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}"', '')
      .gsub('"${TOOLCHAIN_DIR}/usr/lib/swift/${PLATFORM_NAME}" ', '')
      .gsub('"$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)" ', '')
      .gsub(' "$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)"', '')

    File.write(xcconfig_path, cleaned) if cleaned != text
  end
end
