#import "FlutterAesPlugin.h"
#import "NSString+AES.h"

@implementation FlutterAesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aes"
            binaryMessenger:[registrar messenger]];
  FlutterAesPlugin* instance = [[FlutterAesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"encrypt" isEqualToString:call.method]) {
      result([self encrypt:call]);
    return;
  }

  if ([@"decrypt" isEqualToString:call.method]) {
      result([self decrypt:call]);
    return;
  }

  result(FlutterMethodNotImplemented);
}

- (NSString*)encrypt:(FlutterMethodCall*)call {
    NSString* key = call.arguments[@"key"];
    NSString* plainText = call.arguments[@"plainText"];
    return [plainText encryptWithHexKey:key hexIV:nil];
}

- (NSString*)decrypt:(FlutterMethodCall*)call {
    NSString* key = call.arguments[@"key"];
    NSString* encryptedText = call.arguments[@"encryptedText"];
    return [encryptedText decryptWithHexKey:key hexIV:nil];
}

@end
