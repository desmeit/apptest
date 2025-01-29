import UIKit
import Flutter
import WatchConnectivity

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    let flutterEngine = FlutterEngine(name: "apptest")
    
    private var session: WCSession?
    private var channel: FlutterMethodChannel?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
         flutterEngine.run()
        
        // Watch
        initWatchConnectivity()
        initFlutterChannel()
        
        // Used to connect plugins (only if you have plugins with iOS platform code).
         GeneratedPluginRegistrant.register(with: self.flutterEngine)
        
        // GeneratedPluginRegistrant.register(with: self)
        
        
//        DispatchQueue.main.async {
//                  let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                  let vc: SplashViewController = storyboard.instantiateViewController(withIdentifier: "splashViewController") as! SplashViewController
//                  controller.present(vc, animated: true, completion: nil)
//              }
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initWatchConnectivity() {
        guard WCSession.isSupported() else { return }
        session = WCSession.default
        session?.delegate = self
        session?.activate()
    }
    
    private func initFlutterChannel() {
        DispatchQueue.main.async {
           // guard let controller = self.window?.rootViewController as? FlutterViewController else { return }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let flutterEngine = appDelegate.flutterEngine
            let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
            
            let channel = FlutterMethodChannel(name: "com.example.apptest.watchkitapp", binaryMessenger: flutterViewController.binaryMessenger)
            channel.setMethodCallHandler { [weak self] call, result in
                let method = call.method
                let args = call.arguments
                
                guard method == "forwardToAppleWatch" else { return }
                guard let watchSession = self?.session, watchSession.isPaired, let messageData = args as? [String: Any] else {
                    print("watch not paired")
                    return
                }
                
                guard watchSession.isReachable else {
                    print("watch not reachable")
                    return
                }
                
                watchSession.sendMessage(messageData, replyHandler: nil, errorHandler: nil)
            }
            self.channel = channel
        }
    }
    
}

extension AppDelegate: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) { }
    func sessionDidDeactivate(_ session: WCSession) { }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            guard let methodName = message["method"] as? String else { return }
            let data: [String: Any]? = message["data"] as? [String: Any]
            self.channel?.invokeMethod(methodName, arguments: data)
        }
    }
}
