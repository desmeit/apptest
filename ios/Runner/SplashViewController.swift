import UIKit
import Lottie
import Flutter

public class SplashViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    public override func viewDidAppear(_ animated: Bool) {
        animationView = .init(name: "loader")
        animationView!.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView!.center = self.view.center
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.00
        view.addSubview(animationView!)
        animationView!.play{ (finished) in
            self.startFlutterApp()
        }
    }
    
    func startFlutterApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterEngine = appDelegate.flutterEngine
        let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)

        appDelegate.window?.rootViewController = flutterViewController // maybe there is a better option? I see a short black blinking between the switch from splashview to flutterview. present is working better but then there is another problem if I open a mail with flutter_email_sender for example:
        
        // ".Attempt to present <MFMailComposeViewController: 0x1508ed800> on <Runner.SplashViewController: 0x147f131c0> (from <Runner.SplashViewController: 0x147f131c0>) which is already presenting <FlutterViewController: 0x14a25f800>."
        
    
    }
}
