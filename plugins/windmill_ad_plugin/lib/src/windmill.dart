import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/core/windmill_enum.dart';

class WindmillAd {
  static const _channel = MethodChannel('com.windmill.ad');
  /// 获取SDK版本号
  static Future<String?> sdkVersion() {
    return _channel.invokeMethod('getSdkVersion');
  }
  /// 初始化SDK
  static Future<void> init(String appId) {
    return _channel.invokeMethod('setupSdkWithAppId', {
      'appId': appId
    });
  }
  /// 场景曝光，sceneId由平台生成
  static Future<void> sceneExpose(String? sceneId, String? sceneName) {
    return _channel.invokeMethod('sceneExpose', {
      'sceneId': sceneId??"",
      'sceneName': sceneName ?? ""
    });
  }
  /// 获取平台唯一ID，需要在一次广告请求后，否则返回为nil
  static Future<String?> uid() {
    return _channel.invokeMethod('getUid');
  }
  /// Debug开关
  static Future<void> setDebugEnable(bool flags) {
    return _channel.invokeMethod('setDebugEnable', {
      'flags': flags
    });
  }
  static Future<void> gdpr(GDPR state) {
    return _channel.invokeMethod('setGDPRStatus', {
      'state': state.index
    });
  }

  static Future<void> setUserId(String? userId) {
    return _channel.invokeMethod('setUserId', {
      'userId': userId??""
    });
  }

  static Future<void> ccpa(CCPA state) {
    return _channel.invokeMethod('setCCPAStatus', {
      'state': state.index
    });
  }


  static Future<void> setOAIDCertPem(String certpemStr) {
    return _channel.invokeMethod('setOAIDCertPem', {
      'certPem': certpemStr
    });
  }
  static Future<void> coppa(COPPA state) {
    return _channel.invokeMethod('setCOPPAStatus', {
      'state': state.index
    });
  }
  static Future<void> age(int age) {
    return _channel.invokeMethod('setAge', {
      'age': age
    });
  }
  static Future<void> adult(Adult state) {
    return _channel.invokeMethod('setAdultStatus', {
      'state': state.index
    });
  }
  static Future<void> personalizedAdvertisin(Personalized state) {
    return _channel.invokeMethod('setPersonalizedStatus', {
      'state': state.index
    });
  }
}
