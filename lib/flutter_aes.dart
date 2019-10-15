import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAes {
  static const MethodChannel _channel = const MethodChannel('flutter_aes');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> encrypt(String plainText, String key) async {
    return await _channel.invokeMethod('encrypt', {
      "plainText": plainText,
      "key": key,
    });
  }

  static Future<String> decrypt(String encryptedText, String key) async {
    return await _channel.invokeMethod('decrypt', {
      "encryptedText": encryptedText,
      "key": key,
    });
  }
}
