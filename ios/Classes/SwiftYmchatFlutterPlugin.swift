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
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
              switch(call.method)
              {
              case "setBotId":
                self.setBotId(call: call,result: result, ymEventChannel: ymEventChannel, ymCloseEventChannel:ymCloseEventChannel);
                return;
              case "setDeviceToken":
                  self.setDeviceToken(call: call,result: result);
                return;
              case "setEnableSpeech":
                  self.setEnableSpeech(call: call,result: result);
                return;
              case "setEnableHistory":
                  self.setEnableHistory(call: call,result: result);
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
              default:
                  result(FlutterMethodNotImplemented)
                return;
              }
          // Note: this method is invoked on the UI thread.
          
      });
  }
    
    
    private static func setBotId(call: FlutterMethodCall, result: FlutterResult, ymEventChannel: FlutterEventChannel, ymCloseEventChannel: FlutterEventChannel)
    {
        let botId:String = getRequiredParamater(parameter: "botId", call: call)
        
        ymEventChannel.setStreamHandler(ymEventHandler);
        
        ymCloseEventChannel.setStreamHandler(ymCloseEventHandler);
        
        let localDelegate = CustomYmChatDelegate(ymEventHandler: ymEventHandler, ymCloseEventHandler: ymCloseEventHandler)
        
        YMChat.shared.delegate = localDelegate;
        
        ymConfig = YMConfig(botId: botId);
        
        result(true);
    }
    private static func setDeviceToken(call: FlutterMethodCall, result: FlutterResult)
    {
        let deviceToken:String = getRequiredParamater(parameter: "deviceToken", call: call)
        ymConfig?.deviceToken = deviceToken;
        result(true);
    }
    private static func setEnableSpeech(call: FlutterMethodCall, result: FlutterResult)
    {
        let shouldEnableSpeech:Bool = getRequiredParamater(parameter: "shouldEnableSpeech", call: call)
        ymConfig?.enableSpeech = shouldEnableSpeech;
        result(true);
    }
    private static func setEnableHistory(call: FlutterMethodCall, result: FlutterResult)
    {
        let shouldEnableHistory:Bool = getRequiredParamater(parameter: "shouldEnableHistory", call: call)
        ymConfig?.enableHistory = shouldEnableHistory
        result(true);
    }
    private static func setAuthenticationToken(call: FlutterMethodCall, result: FlutterResult)
    {
        let authenticationToken:String = getRequiredParamater(parameter: "authenticationToken", call: call)
        ymConfig?.ymAuthenticationToken = authenticationToken;
        result(true);
    }
    private static func showCloseButton(call: FlutterMethodCall, result: FlutterResult)
    {
        let showCloseButton:Bool = getRequiredParamater(parameter: "shouldEnableCloseButton", call: call)
        ymConfig?.showCloseButton = showCloseButton
        result(true);
    }
    private static func setCustomURL(call: FlutterMethodCall, result: FlutterResult)
    {
        let customURL:String = getRequiredParamater(parameter: "customURL", call: call)
        ymConfig?.customBaseUrl = customURL;
        result(true);
    }
    private static func setPayload(call: FlutterMethodCall, result: FlutterResult)
    {
        let payload: Dictionary<String,Any>? = call.arguments as? Dictionary<String,Any>;
        if( payload != nil)
        {
            ymConfig?.payload = payload!;
            result(true);
        }
        else{
            assert(false, "payload not found");
        }
    }
    private static func startChatbot( result: FlutterResult)
    {
        YMChat.shared.config = ymConfig;
        do {
            try YMChat.shared.startChatbot();
            result(true);
        } catch{
            result(false);
        }
    }
    private static func closeBot( result: FlutterResult)
    {
        result(true);
    }
    
    private static func getRequiredParamater<T:Decodable>(parameter: String, call: FlutterMethodCall) -> T
    {
        let args: Dictionary<String, T>? = call.arguments as? Dictionary<String, T>;
        let param: T? = args?[parameter];
        if(param != nil)
        {
            return param!;
        }
        else{
            assert(false, "\(parameter) value not found");
        }
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
    
    public func getEventSink() -> FlutterEventSink?
    {
        return _eventSink;
    }
    
    @objc public func sendEvent(event:Any)
    {
        if(_eventSink != nil)
        {
            DispatchQueue.main.async {
                self._eventSink!(event);
            }
        }
        else{
            assert(false, "Event sink is missing to emmit event");
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
