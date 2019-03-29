# EngageSDK

## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+
- Xcode 10.1+
- Swift 4.2+

## Installation

### CocoaPods
Cocoapods is a dependency management platform used to install, update and delete the libraries used on a project.  

You can  install Cocoapods using the following terminal command

```ruby
$ sudo gem install cocoapods
```

To initialize Cocoapods on your project, navigate through the terminal to your project directory and then run the following command:
```ruby
$ cocoapods init
```

This will create a `.podfile` on the root of your project. The `.podfile` is the configuration file that Cocoapods uses to declare the project dependencies. 

Next, add the EngageSDK as a dependency to your project:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'Your Target Name' do
pod 'EngageSDK'
end
```

On the root of your project where the `.podfile` was created, run the following command to install the Discovery SDK as a dependency:

```ruby
$ pod install
```


### Permissions

Engage SDK will need location and bluetooth permissions. Add the following keys to your App plist:  

- NSBluetoothPeripheralUsageDescription
- NSLocationAlwaysAndWhenInUseUsageDescription
- NSLocationWhenInUseUsageDescription

### Capabilities

On your App capabilities check:  

1. Location Updates
2. Uses Bluetooth LE accessory
3. Act as Bluetooth LE accessory
4. Remote notifications
  
![](https://raw.githubusercontent.com/locally-io/ios-engage-sdk/master/Screenshots/capabilities.png)
￼￼￼
With all of the above setup, now you're now ready to get Engage up and running!


## Initializing The Framework  

To initialize Engage, add your credentials to the Initialize Call on the didFinishLaunchingWithOptions of your AppDelegate.

```swift
import LocallyEngageSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		Engage.initialize(username: "YOUR USERNAME", password: "YOUR PASSWORD")

		return true
	}
}
```
  
  

## Monitoring Beacons Campaigns

After the SDK has been initialized, you can call Engage.startMonitoringBeacons from any place in your app. The initialized closure is used to guarantee that startMonitoringBeacons is called _only_ after the SDK has been initialized.

```swift
Engage.initialized = {
	Engage.startMonitoringBeacons()
}
```
  

## Monitoring Geofences Campaigns

You can monitor Geofences Campaigns in the same way you monitor Beacons. Just call Engage.startMonitoringGeofences:

```swift
Engage.initialized = {
	Engage.startMonitoringGeofences()
}
```

```swift
Engage.initialized = {
	Engage.stopMonitoringBeacons()
}
```

You can also monitor Beacons _and_ Geofences at the same time:

```swift
Engage.initialized = { Engage.startMonitoringBeacons()
	Engage.startMonitoringGeofences()
}
```


## Push Notifications Campaigns

### Registering for Push Notifications  
To register for Push Notifications, implement the delegate method "didRegisterForRemoteNotificationsWithDeviceToken" on your AppDelegate and then set the device token:

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
	Engage.deviceToken = deviceToken
}
```

### Displaying Push Notification Preview  
  
####  Creating a Notification Service Extension
To add Push Notifications campaigns to your app, you'll have to add a NotificationServiceExtension to your project:

![](https://raw.githubusercontent.com/locally-io/ios-engage-sdk/master/Screenshots/target.png) ![](https://raw.githubusercontent.com/locally-io/ios-engage-sdk/master/Screenshots/service_extension.png)


####  Configuring your Notification Service

Change your NotificationService to call RemoteNotificationPreviewDisplayer by adding the following:

```swift
import LocallyEngageSDK
import UserNotifications
import UserNotificationsUI

class NotificationService: UNNotificationServiceExtension {

	override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
		RemoteNotificationPreviewDisplayer.displayPreview(withNotificationRequest: request, andHandler: contentHandler)
	}
}

``` 

###  Configuring your plist file
Now open the plist file, remove the NSExtensionMainStoryboard key and then set the other keys as illustrated in the image below.
![](https://raw.githubusercontent.com/locally-io/ios-engage-sdk/master/Screenshots/content_keys.png)

####  Configuring the Notification View Controller

Remove your MainInterface.storyboard file and then change your NotificationViewController to call RemoteNotificationViewController on your viewDidLoad method:

```swift
import LocallyEngageSDK

class NotificationViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		_ = RemoteNotificationViewController()
	}
}
```
