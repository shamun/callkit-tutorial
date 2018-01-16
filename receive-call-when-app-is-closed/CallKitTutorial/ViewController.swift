import UIKit
import CallKit
import PushKit

//curl -v -d '{"aps":{"alert":"hello"}}' --http2 --cert /Users/sun/Desktop/voip.pem --key /Users/sun/Desktop/Certificates.pem https://api.development.push.apple.com/3/device/ba771295f4ccb8ab50dcc2b761555088d8ed7a587fd7885edf4115b7f7555211
class ViewController: UIViewController, CXProviderDelegate, PKPushRegistryDelegate {
    
    override func viewDidLoad() {
        let registry = PKPushRegistry(queue: nil)
        registry.delegate = self
        registry.desiredPushTypes = [PKPushType.voIP]
    }
    
    func providerDidReset(_ provider: CXProvider) {
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print(pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined())
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        let config = CXProviderConfiguration(localizedName: "My App")
        config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "pizza")!)
        config.ringtoneSound = "ringtone.caf"
        config.includesCallsInRecents = false;
        config.supportsVideo = true;
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: "Pete Za")
        update.hasVideo = true
        provider.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
    }

}
