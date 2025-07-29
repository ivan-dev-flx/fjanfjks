import UIKit
import Flutter
import AppsFlyerLib

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AppsFlyerLib.shared().appsFlyerDevKey = "VssG3LNA5NwZpCZ3Dd5YhQ"
        AppsFlyerLib.shared().appleAppID = "6746067890"
        // AppsFlyerLib.shared().delegate = self
        if #available(iOS 15.4, *) {
            AppsFlyerLib.shared().enableTCFDataCollection(true)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
}