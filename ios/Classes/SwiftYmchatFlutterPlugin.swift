import Flutter
import UIKit
import YMChat

public class SwiftYmchatFlutterPlugin: NSObject, FlutterPlugin {
    private static var ymConfig:YMConfig? = nil;
    
    private static var ymEventHandler: YmChatFlutterStreamHandler  = YmChatFlutterStreamHandler();
    
    private static var ymCloseEventHandler: YmChatFlutterStreamHandler = YmChatFlutterStreamHandler();
    
    private static var localDelegate: CustomYmChatDelegate?

    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "com.yellow.ai.ymchat", binaryMessenger: registrar.messenger());
        
        let ymEventChannel:FlutterEventChannel = FlutterEventChannel(name:"YMChatEvent",binaryMessenger: registrar.messenger());
        
        let ymCloseEventChannel:FlutterEventChannel = FlutterEventChannel(name:"YMBotCloseEvent",binaryMessenger: registrar.messenger());
        
        let instance = SwiftYmchatFlutterPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        ymEventChannel.setStreamHandler(ymEventHandler)
        ymCloseEventChannel.setStreamHandler(ymCloseEventHandler)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method){
            case "setBotId":
                self.setBotId(call: call,result: result, ymEventChannel: ymEventChannel, ymCloseEventChannel:ymCloseEventChannel);
                return;
            case "setDeviceToken":
                self.setDeviceToken(call: call,result: result);
                return;
            case "setEnableSpeech":
                self.setEnableSpeech(call: call,result: result);
                return;
            case "setAuthenticationToken":
                self.setAuthenticationToken(call:call,result: result)
                return;
            case "showCloseButton":
                self.showCloseButton(call:call, result:result);
                return;
            case "setCustomURL":
                self.setCustomURL(call:call,result:result);
                return;
            case "setPayload":
                self.setPayload(call:call,result:result);
                return;
            case "startChatbot":
                self.startChatbot(result:result);
                return;
            case "closeBot":
                self.closeBot(result:result);
                return;
            case "unLinkDeviceToken":
                self.unLinkDeviceToken(call: call,result:result)
                return;
            case "setVersion":
                self.setVersion(call:call, result:result);
                return;
            case "setCustomLoaderURL":
                self.setCustomLoaderURL(call:call,result:result);
                return;
            case "setStatusBarColor":
                self.setStatusBarColor(call:call,result:result);
                return;
            case "setCloseButtonColor":
                self.setCloseButtonColor(call:call,result:result);
                return;
            case "setMicIconColor":
                self.setMicIconColor(call:call,result:result);
                break;
            case "setMicBackgroundColor":
                self.setMicBackgroundColor(call:call,result:result);
                break;
            case "setDisableActionsOnLoad":
                self.setDisableActionsOnLoad(call:call,result:result);
                return;
            case "getUnreadMessages":
                self.getUnreadMessages(call:call,result:result);
                return;
            case "registerDevice":
                self.registerDevice(call:call,result:result);
                return;
            case "useLiteVersion":
                self.useLiteVersion(call:call,result:result);
                return
            case "reloadBot":
                self.reloadBot(result:result);
                return;
            case "revalidateToken":
                revalidateToken(call:call,result:result);
                break;
            case "useSecureYmAuth":
                useSecureYmAuth(call:call,result:result);
                break;
            case "sendEventToBot":
                sendEventToBot(call:call,result:result);
                break;
            default:
                result(FlutterMethodNotImplemented)
                return;
            }
            // Note: this method is invoked on the UI thread.
            
        });
    }

    private static func useLiteVersion(call: FlutterMethodCall, result: FlutterResult){
        let shouldUseLiteVersion:Bool = getRequiredParamater(parameter: "shouldUseLiteVersion", call: call)
        ymConfig?.useLiteVersion = shouldUseLiteVersion
        result(true);
    }
    
    private static func getUnreadMessages(call: FlutterMethodCall, result: @escaping FlutterResult){
        if(ymConfig != nil)
        {
            YMChat.shared.getUnreadMessagesCount(ymConfig: ymConfig!) { unReadMsgs in
                result(unReadMsgs)
            } failure: { errorMsg in
                var failurMsg = [String : String]()
                failurMsg["error"] = errorMsg
                result(failurMsg)
            }
            
        }
        else{
            result("Bot id not found")
        }
    }
    
    private static func registerDevice(call: FlutterMethodCall, result: @escaping FlutterResult){
        if(ymConfig != nil)
        {
            let apiKey:String = getRequiredParamater(parameter: "apiKey", call: call)
            YMChat.shared.registerDevice(apiKey: apiKey, ymConfig: ymConfig!) {
                result(true)
            } failure: { failureMsg in
                result(failureMsg)
            }
        }
        else{
            result("Bot id not found")
        }
    }

    private static func revalidateToken(call: FlutterMethodCall, result: FlutterResult){
        do {
            guard let args = call.arguments as? [String : Any], 
                let token = args["token"] as? String, 
                let refreshSession = args["refreshSession"] as? Bool else { return }
            try YMChat.shared.revalidateToken(token: token, refreshSession: refreshSession);
            result(true);
        } catch{
            result(false);
        }
    }

    private static func useSecureYmAuth(call: FlutterMethodCall, result: FlutterResult){
        let shouldUseSecureYmAuth:Bool = getRequiredParamater(parameter: "shouldUseSecureYmAuth", call: call);
        ymConfig?.useSecureYmAuth = shouldUseSecureYmAuth;
        result(true);
    }

    private static func sendEventToBot(call: FlutterMethodCall, result: FlutterResult){
        do{
            guard let args = call.arguments as? [String : Any], 
                let code = args["code"] as? String, 
                let data: Dictionary<String,Any>? = args["data"] as? Dictionary<String,Any>;
            let event = YMEventModel(code: code, data: data);
            try YMChat.shared.sendEventToBot(event);
            result(true);
        }catch{
            result(false);
        }
    }
    
    private static func setBotId(call: FlutterMethodCall, result: FlutterResult, ymEventChannel: FlutterEventChannel, ymCloseEventChannel: FlutterEventChannel){
        let botId:String = getRequiredParamater(parameter: "botId", call: call)
        
        localDelegate = CustomYmChatDelegate(ymEventHandler: ymEventHandler, ymCloseEventHandler: ymCloseEventHandler)
        
        YMChat.shared.delegate = localDelegate;
        
        ymConfig = YMConfig(botId: botId);
        
        result(true);
    }
    private static func setDeviceToken(call: FlutterMethodCall, result: FlutterResult){
        let deviceToken:String = getRequiredParamater(parameter: "deviceToken", call: call)
        ymConfig?.deviceToken = deviceToken;
        result(true);
    }
    private static func setEnableSpeech(call: FlutterMethodCall, result: FlutterResult){
        let shouldEnableSpeech:Bool = getRequiredParamater(parameter: "shouldEnableSpeech", call: call)
        ymConfig?.enableSpeech = shouldEnableSpeech;
        result(true);
    }
    private static func setAuthenticationToken(call: FlutterMethodCall, result: FlutterResult){
        let authenticationToken:String = getRequiredParamater(parameter: "authenticationToken", call: call)
        ymConfig?.ymAuthenticationToken = authenticationToken;
        result(true);
    }
    private static func showCloseButton(call: FlutterMethodCall, result: FlutterResult){
        let showCloseButton:Bool = getRequiredParamater(parameter: "shouldEnableCloseButton", call: call)
        ymConfig?.showCloseButton = showCloseButton
        result(true);
    }
    private static func setCustomURL(call: FlutterMethodCall, result: FlutterResult){
        let customURL:String = getRequiredParamater(parameter: "customURL", call: call)
        ymConfig?.customBaseUrl = customURL;
        result(true);
    }
    private static func setPayload(call: FlutterMethodCall, result: FlutterResult){
        let payload: Dictionary<String,Any>? = call.arguments as? Dictionary<String,Any>;
        if( payload != nil && payload?.keys.contains("payload") == true){
            ymConfig?.payload = payload?["payload"] as? Dictionary<String,Any> ?? [:];
            result(true);
        }
        else{
            fatalError("payload not found");
        }
    }
    private static func startChatbot( result: FlutterResult){
        YMChat.shared.config = ymConfig;
        do {
            try YMChat.shared.startChatbot();
            result(true);
        } catch{
            result(false);
        }
    }
    private static func closeBot( result: FlutterResult){
        YMChat.shared.closeBot();
        result(true);
    }
    
    private static func getRequiredParamater<T:Decodable>(parameter: String, call: FlutterMethodCall) -> T{
        let args: Dictionary<String, T>? = call.arguments as? Dictionary<String, T>;
        let param: T? = args?[parameter];
        if(param != nil){
            return param!;
        }
        else{
            fatalError("\(parameter) value not found");
        }
    }
    
    private static func unLinkDeviceToken(call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        let apiKey:String  = getRequiredParamater(parameter: "apiKey", call: call);
        YMChat.shared.unlinkDeviceToken(apiKey: apiKey, ymConfig: ymConfig!) {
            result(true);
        } failure: { (failureMessage:String) -> Void in
            result(failureMessage);
        }
    }
    
    private static func setVersion(call: FlutterMethodCall, result: FlutterResult){
        let version:Int = getRequiredParamater(parameter: "version", call: call);
        ymConfig?.version = version;
        result(true);
    }
    
    private static func setCustomLoaderURL(call: FlutterMethodCall, result: FlutterResult){
        let customURL:String = getRequiredParamater(parameter: "customLoaderURL", call: call)
        ymConfig?.customLoaderUrl = customURL;
        result(true);
    }
    
    private static func setStatusBarColor(call: FlutterMethodCall, result: FlutterResult){
        let color:String = getRequiredParamater(parameter: "color", call: call)
        ymConfig?.statusBarColor = hexStringToUIColor(hex: color);
        result(true);
    }
    
    private static func setCloseButtonColor(call: FlutterMethodCall, result: FlutterResult){
        let color:String = getRequiredParamater(parameter: "color", call: call)
        ymConfig?.closeButtonColor = hexStringToUIColor(hex: color);
        result(true);
    }

    private static func reloadBot(result: FlutterResult){
        do {
            try YMChat.shared.reloadBot();
            result(true);
        } catch{
            result(false);
        }
    }
    
    private static func setMicIconColor(call: FlutterMethodCall, result: FlutterResult){
        let color:String = getRequiredParamater(parameter: "color", call: call)
        ymConfig?.enableSpeechConfig.fabIconColor = hexStringToUIColor(hex: color);
        result(true);
    }

    private static func setMicBackgroundColor(call: FlutterMethodCall, result: FlutterResult){
        let color:String = getRequiredParamater(parameter: "color", call: call)
        ymConfig?.enableSpeechConfig.fabBackgroundColor = hexStringToUIColor(hex: color);
        result(true);
    }

    private static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private static func setDisableActionsOnLoad(call: FlutterMethodCall, result: FlutterResult){
        let shouldDisableActionsOnLoad:Bool = getRequiredParamater(parameter: "shouldDisableActionsOnLoad", call: call)
        ymConfig?.disableActionsOnLoad = shouldDisableActionsOnLoad;
        result(true);
    }
    
}

class YmChatFlutterStreamHandler: NSObject,FlutterStreamHandler {
    
    var _eventSink: FlutterEventSink?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        _eventSink = events;
        return nil;
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil;
        return nil;
    }
    
    public func getEventSink() -> FlutterEventSink? {
        return _eventSink;
    }
    
    @objc public func sendEvent(event:Any){
        if(_eventSink != nil){
            DispatchQueue.main.async {
                self._eventSink!(event);
            }
        }
    }
}

class CustomYmChatDelegate: NSObject,YMChatDelegate{
    
    var ymEventHandler: YmChatFlutterStreamHandler?
    var ymCloseEventHandler: YmChatFlutterStreamHandler?
    
    init(ymEventHandler: YmChatFlutterStreamHandler?,ymCloseEventHandler: YmChatFlutterStreamHandler?){
        self.ymEventHandler = ymEventHandler;
        self.ymCloseEventHandler = ymCloseEventHandler;
    }
    
    func onEventFromBot(response: YMBotEventResponse) {
        let event:NSMutableDictionary = NSMutableDictionary();
        event["code"] = response.code;
        event["data"] = response.data;
        ymEventHandler?.sendEvent(event: event);
    }
    
    func onBotClose() {
        ymCloseEventHandler?.sendEvent(event: true);
    }
}
