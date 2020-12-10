import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    #if QA
    private let k_FIREBASE_OPTIONS = "GoogleService-Info-qa.plist"
    #endif
    #if Production
    private let k_FIREBASE_OPTIONS = "GoogleService-Info-production.plist"
    #endif
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        // Init Firebase
        if let path = Bundle.main.path(forResource: k_FIREBASE_OPTIONS, ofType: nil),
            let options = FirebaseOptions(contentsOfFile: path) {
          FirebaseApp.configure(options: options)
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
