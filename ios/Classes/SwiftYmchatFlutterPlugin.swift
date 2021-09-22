import Flutter
import UIKit
import YMChat

public class SwiftYmchatFlutterPlugin: NSObject, FlutterPlugin {
    static var ymConfig:YMConfig? = nil;
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.yellow.ai.ymchat", binaryMessenger: registrar.messenger())
    
    let instance = SwiftYmchatFlutterPlugin()
    
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    channel.setMethodCallHandler({
        (call: FlutterMethodCall, result: FlutterResult) -> Void in
              switch(call.method)
              {
              case "setBotId":
                self.setBotId(call: call,result: result);
                  break;
              case "setDeviceToken":
                  self.setDeviceToken(call: call,result: result);
                  break;
              case "setEnableSpeech":
                  self.setEnableSpeech(call: call,result: result);
                  break;
              case "setEnableHistory":
                  self.setEnableHistory(call: call,result: result);
                  break;
              case "setAuthenticationToken":
                  self.setAuthenticationToken(call:call,result: result)
                  break;
              case "showCloseButton":
                  self.showCloseButton(call:call, result:result);
                  break;
              case "setCustomURL":
                  self.setCustomURL(call:call,result:result);
                  break;
              case "setPayload":
                  self.setPayload(call:call,result:result);
                  break;
              case "startChatbot":
                  self.startChatbot(result:result);
                  break;
              case "closeBot":
                  self.closeBot(result:result);
                  break;
              default:
                  result(FlutterMethodNotImplemented)
              }
          // Note: this method is invoked on the UI thread.
          
      });
  }
    
    
    private static func setBotId(call: FlutterMethodCall, result: FlutterResult)
    {
        let botId:String = getRequiredParamater(parameter: "botId", call: call)
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
        let showCloseButton:Bool = getRequiredParamater(parameter: "showCloseButton", call: call)
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
