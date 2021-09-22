#import "YmchatFlutterPlugin.h"
#if __has_include(<ymchat_flutter/ymchat_flutter-Swift.h>)
#import <ymchat_flutter/ymchat_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ymchat_flutter-Swift.h"
#endif

@implementation YmchatFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYmchatFlutterPlugin registerWithRegistrar:registrar];
}
@end
