import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/core/windmill_network_listener.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class WindmillAd with WindmillNetWorkInitEventHandler {
  static const _channel = MethodChannel('com.windmill.ad');

  /// 获取SDK版本号
  static Future<String?> sdkVersion() {
    return _channel.invokeMethod('getSdkVersion');
  }

  /// 初始化SDK
  static Future<void> init(String appId) {
    return _channel.invokeMethod('setupSdkWithAppId', {'appId': appId});
  }

  /// 中国大陆权限授权接口（仅针对中国大陆）仅Android
  static Future<void> requestPermission() {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('requestPermission');
    }
    return Future.value();
  }

  /// 设置流量分组自定义规则【应用级设置】
  /// (在线文档：https://doc.sigmob.com/#/ToBid使用指南/高级功能说明/流量分组/)
  static Future<void> initCustomGroup(Map customGroup) {
    return _channel.invokeMethod(
        'initCustomGroup', {'customGroup': json.encode(customGroup)});
  }

  /// 设置流量分组自定义规则【聚合广告位级设置】
  /// (在线文档：https://doc.sigmob.com/#/ToBid使用指南/高级功能说明/流量分组/)
  static Future<void> initCustomGroupForPlacement(
      Map customGroup, String placementId) {
    return _channel.invokeMethod('initCustomGroupForPlacement',
        {'customGroup': json.encode(customGroup), 'placementId': placementId});
  }

  /// 渠道过滤
  static Future<void> setFilterNetworkFirmIdList(
      String? placementId, List<String> networkFirmIdList) {
    return _channel.invokeMethod('setFilterNetworkFirmIdList', {
      'placementId': placementId ?? "",
      'networkFirmIdList': networkFirmIdList
    });
  }

  /// 设置自定义信息
  static Future<void> setCustomDevice(CustomDevice customDevice) {
    return _channel.invokeMethod('customDevice', {
      'isCanUseIdfa': customDevice.isCanUseIdfa,
      'customIDFA': customDevice.customIDFA,
      'isCanUseLocation': customDevice.isCanUseLocation,
      'customLocation': {
        'latitude': customDevice.customLocation?.latitude,
        'longitude': customDevice.customLocation?.longitude
      },
      'isCanUsePhoneState': customDevice.isCanUsePhoneState,
      'customIMEI': customDevice.customIMEI,
      'isCanUseAndroidId': customDevice.isCanUseAndroidId,
      'customAndroidId': customDevice.customAndroidId,
      'isCanUseOaid': customDevice.isCanUseOaid,
      'customOAID': customDevice.customOAID,
      'isCanUseAppList': customDevice.isCanUseAppList,
      'customInstalledPackages': customDevice.customInstalledPackages?.map((e) => e.toJson()).toList(),
      'isCanUseWifiState': customDevice.isCanUseWifiState,
      'isCanUseMacAddress': customDevice.isCanUseMacAddress,
      'customMacAddress': customDevice.customMacAddress,
      'isCanUseWriteExternal': customDevice.isCanUseWriteExternal,
      'isCanUsePermissionRecordAudio':
          customDevice.isCanUsePermissionRecordAudio,
    });
  }

  /// 场景曝光，sceneId由平台生成
  static Future<void> sceneExpose(String? sceneId, String? sceneName) {
    return _channel.invokeMethod('sceneExpose',
        {'sceneId': sceneId ?? "", 'sceneName': sceneName ?? ""});
  }

  /// 获取平台唯一ID，需要在一次广告请求后，否则返回为nil
  static Future<String?> uid() {
    return _channel.invokeMethod('getUid');
  }

  /// Debug开关
  static Future<void> setDebugEnable(bool flags) {
    return _channel.invokeMethod('setDebugEnable', {'flags': flags});
  }

  /// 多进程 仅Android
  static Future<void> setSupportMultiProcess(bool flags) {
    return _channel.invokeMethod('setSupportMultiProcess', {'flags': flags});
  }

  /// 微信小程序 仅Android
  static Future<void> setWxOpenAppIdAndUniversalLink(
      String? wxAppId, String? universalLink) {
    return _channel.invokeMethod('setWxOpenAppIdAndUniversalLink', {
      'wxAppId': wxAppId ?? "",
      'universalLink': universalLink ?? "",
    });
  }

  /// GDPR授权
  static Future<void> gdpr(GDPR state) {
    return _channel.invokeMethod('setGDPRStatus', {'state': state.index});
  }

  /// 用户id
  static Future<void> setUserId(String? userId) {
    return _channel.invokeMethod('setUserId', {'userId': userId ?? ""});
  }

  /// 添加过滤；支持渠道、渠道广告位id等条件过滤
  @Deprecated('请使用addWaterfallFilter')
  static Future<void> addFilter(String? placementId, List<WindmillFilterInfo>? filterInfoList) {

    if (filterInfoList == null) {
      return Future.value();
    }

    List<Map<String, dynamic>> filterInfoListMap = [];

    for (WindmillFilterInfo filterInfo in filterInfoList) {
      filterInfoListMap.add(filterInfo.toJson());
    }

    return _channel.invokeMethod('addFilter',
        {'placementId': placementId ?? "", 'filterInfoList': filterInfoListMap});
  }

  /// 添加过滤；支持渠道、渠道广告位id、渠道价格、渠道竞价类型等条件过滤
  static Future<void> addWaterfallFilter(String? placementId, List<WindMillFilterModel>? modelList){
    if (modelList == null) {
      return Future.value();
    }
    List<Map<String, dynamic>> listMap = [];
    for (WindMillFilterModel model in modelList) {
      listMap.add(model.toJson());
    }
    return _channel.invokeMethod("addWaterfallFilter", {
      "placementId": placementId ?? "",
      "modelList": listMap
    });
  }

  /// 取消过滤
  static Future<void> removeFilter() {
    return _channel.invokeMethod('removeFilter');
  }

  /// 根据placementId取消过滤
  static Future<void> removeFilterWithPlacementId(String? placementId) {
    return _channel.invokeMethod('removeFilterWithPlacementId', {
      'placementId': placementId ?? ''
    });
  }

  /// 渠道初始化
  static Future<void> networkPreInit(
      List<WindmillNetworkInfo>? networkInfoList) {
    if (networkInfoList == null) {
      return Future.value();
    }
    List<Map<String, dynamic>> networkInfoListMap = [];
    for (WindmillNetworkInfo networkInfo in networkInfoList) {
      networkInfoListMap.add(networkInfo.toJson());
    }

    return _channel
        .invokeMethod("networkPreInit", {'networksMap': networkInfoListMap});
  }

  /// CCPA授权
  static Future<void> ccpa(CCPA state) {
    return _channel.invokeMethod('setCCPAStatus', {'state': state.index});
  }

  /// OAID 证书
  static Future<void> setOAIDCertPem(String certpemStr) {
    return _channel.invokeMethod('setOAIDCertPem', {'certPem': certpemStr});
  }

  /// COPPA授权
  static Future<void> coppa(COPPA state) {
    return _channel.invokeMethod('setCOPPAStatus', {'state': state.index});
  }

  /// 年龄
  static Future<void> age(int age) {
    return _channel.invokeMethod('setAge', {'age': age});
  }

  /// 成年人状态
  static Future<void> adult(Adult state) {
    return _channel.invokeMethod('setAdultStatus', {'state': state.index});
  }

  /// 个性化推荐
  static Future<void> personalizedAdvertisin(Personalized state) {
    return _channel
        .invokeMethod('setPersonalizedStatus', {'state': state.index});
  }

  /// 设置广告位预置策略所在的Bundle路径
  static Future<void> setPresetLocalStrategyPath(String path) {
    return _channel.invokeMethod('setPresetLocalStrategyPath', {'path': path});
  }

  /// 设置渠道初始化代理
  static Future<void> setAdNetworkInitListener(WindmillNetWorkInitListener listener) {
    WindmillNetWorkInitEventHandler.delegate = listener;
    _channel.setMethodCallHandler(WindmillNetWorkInitEventHandler.handleEvent);
    return _channel.invokeMethod("setAdNetworkInitListener");
  }
}
