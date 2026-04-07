import Flutter
import UIKit
import EdfaPgSdk
import PassKit

fileprivate let events:EdfaPaySdkEventChannels = EdfaPaySdkEventChannels()
fileprivate let methods:EdfapaySdkMethodChannels = EdfapaySdkMethodChannels()

fileprivate let PAYMENT_URL = "https://api.edfapay.com/payment/post"
public class EdfaPgSdkPlugin: NSObject, FlutterPlugin, PKPaymentAuthorizationViewControllerDelegate{
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
    }
    
    
    private var registrar:FlutterPluginRegistrar? = nil
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = EdfaPgSdkPlugin()
        instance.registrar = registrar
        
        events.initiate(with: registrar.messenger())
        methods.initiate(with: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: methods.edfaPaySdk!)

    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == methods.methodGetPlatformVersion{
            getPlatformVersion(call, result: result)
        }else if call.method == methods.methodConfig{
            config(call, result: result)
        }else if call.method == methods.methodSetAnimationDelay{
            setAnimationDelay(call, result: result)
        }else if call.method == methods.methodSetFailureAnimation{
            setFailureAnimation(call, result: result)
        }else if call.method == methods.methodSetSuccessAnimation{
            setSuccessAnimation(call, result: result)
        }
    }
    
    func apple(viewController:UIViewController){
        let request = PKPaymentRequest()
        request.countryCode = "SA"
        request.currencyCode = "SAR"
        request.merchantIdentifier = ""
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.supportedNetworks = [.visa]
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Test", amount: 1.0)]
        if let payvc = PKPaymentAuthorizationViewController(paymentRequest: request){
            payvc.delegate = self
            viewController.present(payvc, animated: true)
        }
    }
}


extension EdfaPgSdkPlugin{
    private func getPlatformVersion(_ call: FlutterMethodCall, result: @escaping FlutterResult){
      result("iOS " + UIDevice.current.systemVersion)
    }
    
}



extension EdfaPgSdkPlugin{
    private func config(_ call: FlutterMethodCall, result: @escaping FlutterResult){
        if let params = call.arguments as? [Any],
           let key = params[0] as? String,
           let pass = params[1] as? String,
           let enableDebug = params[2] as? Bool{
            
            let credentials = EdfaPgCredential(
                clientKey: key, clientPass: pass,
                paymentUrl: PAYMENT_URL
            )
            
            if enableDebug{
                EdfaPgSdk.enableLogs()
            }
            EdfaPgSdk.config(credentials)
            result(true)
        }
    }
    
}



extension EdfaPgSdkPlugin{
    private func setSuccessAnimation(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let params = call.arguments as? [Any],
           let url = params[0] as? String {
            do{
                try EdfaPgSdk.setSuccessAnimation(url: url)
                result(true)
            }catch{
                result(FlutterError(code: "505", message: error.localizedDescription, details: nil))
            }
        }
    }
    private func setFailureAnimation(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let params = call.arguments as? [Any],
           let url = params[0] as? String {
            do{
                try EdfaPgSdk.setFailureAnimation(url: url)
                result(true)
            }catch{
                result(FlutterError(code: "505", message: error.localizedDescription, details: nil))
            }
        }
    }
    private func setAnimationDelay(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let params = call.arguments as? [Any],
           let delay = params[0] as? Int {
            do{
                try EdfaPgSdk.setAnimationDelay(delay: delay)
                result(true)
            }catch{
                result(FlutterError(code: "505", message: error.localizedDescription, details: nil))
            }
        }
    }
}

