import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

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

  static Future<void> requestPermission() {
    
    if( Platform.isAndroid){
        return _channel.invokeMethod('requestPermission');
    }
    return Future.value();
  }


  static Future<void> initCustomGroup(Map customGroup) {
    return _channel.invokeMethod('initCustomGroup', {
      'customGroup': json.encode(customGroup)
    });
  }

  static Future<void> initCustomGroupForPlacement(Map customGroup,String placementId) {
    return _channel.invokeMethod('initCustomGroupForPlacement', {
      'customGroup': json.encode(customGroup),
      'placementId': placementId
    });
  }

  static Future<void> setFilterNetworkFirmIdList(String? placementId, List<String> networkFirmIdList) {
    return _channel.invokeMethod('setFilterNetworkFirmIdList', {
      'placementId': placementId??"",
      'networkFirmIdList': networkFirmIdList
    });
  }

  static Future<void> setCustomDevice(CustomDevice customDevice) {
    return _channel.invokeMethod('customDevice', {
      'isCanUseAppList':customDevice.isCanUseAppList,
      'isCanUseWifiState':customDevice.isCanUseWifiState,
      'isCanUseWriteExternal':customDevice.isCanUseWriteExternal, 
      'isCanUsePermissionRecordAudio':customDevice.isCanUsePermissionRecordAudio, 
      'isCanUseAndroidId':customDevice.isCanUseAndroidId,
      'isCanUseLocation':customDevice.isCanUseLocation,
      'isCanUsePhoneState':customDevice.isCanUsePhoneState, 
      'customAndroidId':customDevice.customAndroidId, 
      'customIMEI':customDevice.customIMEI, 
      'customOAID':customDevice.customOAID, 
      'customMacAddress':customDevice.customMacAddress, 
      'isCanUseIdfa': customDevice.isCanUseIdfa,
      'customIDFA':customDevice.customIDFA, 
      'customLocation':{'latitude':customDevice.customLocation?.latitude,'longitude':customDevice.customLocation?.longitude}, 
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

  static Future<void> setSupportMultiProcess(bool flags) {
    return _channel.invokeMethod('setSupportMultiProcess', {
      'flags': flags
    });
  }

  static Future<void> setWxOpenAppIdAndUniversalLink(String? wxAppId,String? universalLink) {
    return _channel.invokeMethod('setWxOpenAppIdAndUniversalLink', {
      'wxAppId': wxAppId??"",
      'universalLink': universalLink??"",
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

  static Future<void> networkPreInit(List<WindmillNetworkInfo>? networkInfoList) {


      if(networkInfoList == null){
        return Future.value();
      }
      List<Map<String,dynamic>> networkInfoListMap = [];
      for(WindmillNetworkInfo networkInfo in networkInfoList){
        networkInfoListMap.add(networkInfo.toJson());
      }

      return _channel.invokeMethod("networkPreInit",{
        'networksMap':networkInfoListMap
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

  static Future<void> setPresetLocalStrategyPath(String path) {
     return _channel.invokeMethod('setPresetLocalStrategyPath', {
      'path':path
    });
  }
}
