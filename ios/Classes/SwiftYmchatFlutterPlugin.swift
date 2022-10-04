import Flutter
import UIKit
import YMChat

public class SwiftYmchatFlutterPlugin: NSObject, FlutterPlugin {
    private static var ymConfig:YMConfig? = nil;
    
    private static var ymEventHandler: YmChatFlutterStreamHandler  = YmChatFlutterStreamHandler();
    
    private static var ymCloseEventHandler: YmChatFlutterStreamHandler = YmChatFlutterStreamHandler();
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "com.yellow.ai.ymchat", binaryMessenger: registrar.messenger());
        
        let ymEventChannel:FlutterEventChannel = FlutterEventChannel(name:"YMChatEvent",binaryMessenger: registrar.messenger());
        
        let ymCloseEventChannel:FlutterEventChannel = FlutterEventChannel(name:"YMBotCloseEvent",binaryMessenger: registrar.messenger());
        
        let instance = SwiftYmchatFlutterPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
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
    
    private static func setBotId(call: FlutterMethodCall, result: FlutterResult, ymEventChannel: FlutterEventChannel, ymCloseEventChannel: FlutterEventChannel){
        let botId:String = getRequiredParamater(parameter: "botId", call: call)
        
        ymEventChannel.setStreamHandler(ymEventHandler);
        
        ymCloseEventChannel.setStreamHandler(ymCloseEventHandler);
        
        let localDelegate = CustomYmChatDelegate(ymEventHandler: ymEventHandler, ymCloseEventHandler: ymCloseEventHandler)
        
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
        if( payload != nil){
            ymConfig?.payload = payload!;
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
        let botId:String = getRequiredParamater(parameter: "botId", call: call);
        let apiKey:String  = getRequiredParamater(parameter: "apiKey", call: call);
        let deviceToken:String = getRequiredParamater(parameter: "deviceToken", call: call);
        YMChat.shared.unlinkDeviceToken(botId: botId, apiKey: apiKey, deviceToken: deviceToken) {
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
        else{
            fatalError("Event sink is missing to emmit event");
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
