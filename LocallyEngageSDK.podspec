Pod::Spec.new do |s|

  s.name          = "LocallyEngageSDK"
  s.version       = "0.4"
  s.summary       = "Engage SDK"
  s.homepage      = "http://locally.io"
  s.license       = "MIT"
  s.author        = {"Eduardo Dias" => "eduardo@locally.io" }
  s.swift_version = "4.2"

  s.ios.deployment_target = '11.2'
  s.source                = { :git => "https://github.com/locally-io/ios-engage-sdk.git", :tag => s.version }
  s.source_files          = "Source/**/*.swift"
  s.resources             = "Source/**/*.xib"

  s.requires_arc = true
  s.static_framework = true

  s.dependency 'Alamofire', '4.8.0'
  s.dependency 'AlamofireImage', '3.4.1'
  s.dependency 'KontaktSDK', '2.0.1'
  s.dependency 'PromiseKit', '6.5.3'
  s.dependency 'AWSSNS', '2.8.1'

  s.subspec 'Notifications' do |notifications|

	  notifications.dependency 'AlamofireImage', '3.4.1'

	  notifications.source_files = 'RemoteNotifications/*.swift',
								   'Source/Protocols/*.swift',
								   'Source/Network/Support/Log.swift',
								   'Source/Extensions/UNNotificationAttachmentExtension.swift'
								   
	  notifications.resources    = 'RemoteNotifications/*.xib'
  end

  s.default_subspec  = 'Notifications'

end
