import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'edfapg_sdk_platform_interface.dart';

/// An implementation of [EdfaPgSdkPlatform] that uses method channels.
class MethodChannelEdfaPgSdk extends EdfaPgSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.edfapg.flutter.sdk');


  final methodGetPlatformVersion = "getPlatformVersion";
  final methodConfig = "config";
  final methodSetSuccessAnimation = "setSuccessAnimation";
  final methodSetFailureAnimation = "setFailureAnimation";
  final methodSetAnimationDelay = "setAnimationDelay";

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(methodGetPlatformVersion);
    return version;
  }

  @override
  Future<bool> config(String key,String password, bool enableDebug) async {
    final result = await methodChannel.invokeMethod<bool>(methodConfig,[key, password, enableDebug]);
    return result ?? false;
  }

  @override
  Future<bool> setSuccessAnimation(String url) async {
    final result = await methodChannel.invokeMethod<bool>(methodSetSuccessAnimation,[url]);
    return result ?? false;
  }

  @override
  Future<bool> setFailureAnimation(String url) async {
    final result = await methodChannel.invokeMethod<bool>(methodSetFailureAnimation,[url]);
    return result ?? false;
  }

  @override
  Future<bool> setAnimationDelay(int delay) async {
    final result = await methodChannel.invokeMethod<bool>(methodSetAnimationDelay,[delay]);
    return result ?? false;
  }
}
