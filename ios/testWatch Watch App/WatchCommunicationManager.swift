import Foundation
import WatchConnectivity

final class WatchCommunicationManager: NSObject, ObservableObject {
    @Published var text: String?
    
    private let session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func updateText(_ fromWatch: String) {
        session.sendMessage(["method": "updateTextFromWatch", "data": ["fromWatch": fromWatch]], replyHandler: nil, errorHandler: nil)
        self.text = text
    }
}

extension WatchCommunicationManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
#if os(iOS)
    public func sessionDidBecomeInactive(_ session: WCSession) { }
    public func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
#endif
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        
        guard let method = message["method"] as? String, let data = message["data"] as? [String: Any] else { return }
        
        guard method == "updateTextFromFlutter", let text = data["text"] as? String else { return }
        

        Task { @MainActor in
            self.text = text

        }
    }
}
