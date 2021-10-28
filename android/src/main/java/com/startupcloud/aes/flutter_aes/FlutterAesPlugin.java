package com.startupcloud.aes.flutter_aes;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** FlutterAesPlugin */
public class FlutterAesPlugin implements FlutterPlugin, MethodCallHandler {
  /** Plugin registration. */
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_aes");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if ("encrypt".equals(call.method)) {
        result.success(encrypt(call));
        return;
    }

    if ("decrypt".equals(call.method)) {
        result.success(decrypt(call));
        return;
    }

    return;
  }

  private String encrypt(MethodCall call) {
      try {
          String key = call.argument("key");
          String plainText = call.argument("plainText");
          return FlutterAesHandler.encrypt(key, plainText);
      } catch (Exception e) {
          return "errorEncrypt";
      }
  }

  private String decrypt(MethodCall call) {
      try {
          String key = call.argument("key");
          String encryptedText = call.argument("encryptedText");
          return FlutterAesHandler.decrypt(key, encryptedText);
      } catch (Exception e) {
          e.printStackTrace();
          return "errorDecrypt";
      }
  }
}

