import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class TBData {
  int type = 0;
  WindmillNativeAd? nativeAd;
  double height = 0;
  String? message;
}

// 原生广告模块控制器
class NativeAdService extends GetxService {
  var adItems = <NativeAdWidget>[].obs;

  var datas = <TBData>[].obs;

  var callbacks = <String>[].obs;
  final Map<String, WindmillNativeAd> _adMap = {};
  bool initialized = false; // 添加标志确保只初始化一次first
  late String appId; // 当前应用的id

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _initializeService() async {
    if (!initialized) {
      print("NativeController onInit...");
      initialized = true; // 设置标志为true，表示已经初始化过
      // 初始化操作
      appId = Platform.isIOS ? "44084" : "44085";
      WindmillAd.init(appId.toString());
    }
  }

  WindmillNativeAd getOrCreateWindmillNativeAd(
      {required String placementId,
      String? userId,
      required Size size,
      required WindmillNativeListener<WindmillNativeAd> listener}) {
    WindmillNativeAd? nativeAd = getWindmillNativeAd(placementId);
    if (nativeAd != null) return nativeAd;
    AdRequest request = AdRequest(placementId: placementId, userId: userId);
    nativeAd = WindmillNativeAd(
      request: request,
      listener: listener,
      width: size.width,
      height: size.height,
    );
    _adMap[placementId] = nativeAd;
    return nativeAd;
  }

  ///  获取WindmillRewardAd，若不存在返回null
  WindmillNativeAd? getWindmillNativeAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }

  generateFakeDatas() {
    for (var i = 0; i < 10; i++) {
      var data = new TBData();
      data.type = 1;
      data.message = 'fake data --> ${i}';
      this.datas.add(data);
    }
  }

  @override
  void onClose() {
    super.onClose();
    print("NativeController onClose...");
  }

  // 加载原生广告load
  Future<void> adLoad(String placementId, Size size) async {
    WindmillNativeAd ad = getOrCreateWindmillNativeAd(
        placementId: placementId,
        userId: "",
        size: Size(size.width, size.height),
        listener: WindMillNativeListener());
    ad.loadAd();
  }

  // 通知并展示原生广告
  void adPlay(WindmillNativeAd ad, Size size) {
    print('codi -- adPlay: ${ad.request.placementId}');
    var data = new TBData();
    data.nativeAd = ad;
    data.type = 2;
    this.datas.insert(2, data);
    this.datas.refresh();
  }
}

// 原生广告监听类
class WindMillNativeListener extends WindmillNativeListener<WindmillNativeAd> {
  final NativeAdService c = Get.find();

  @override
  void onAdFailedToLoad(WindmillNativeAd ad, WMError error) {
    print('flu-nav-onAdFailedToLoad');
    print(
        'onAdFailedToLoad -- ${ad.request.placementId} error: ${error.toJson()} ');
    c.callbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId} error: ${error.toJson()} ');
  }

  @override
  void onAdLoaded(WindmillNativeAd ad) {
    print('flu-nav-onAdLoaded');
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId}');
    // 调用成功
    print('codi -- onAdLoaded: ${ad.request.placementId}');

    c.adPlay(ad, Size(ad.width, ad.height));
  }

  @override
  void onAdOpened(WindmillNativeAd ad) {
    print('flu-nav-onAdOpened');
    ad.getAdInfo().then((adinfo) => c.callbacks.add(
        'onAdOpened -- ${ad.request.placementId} --  adInfo -- ${adinfo.toJson()}'));

    ad.getAppInfo().then((appInfo) => c.callbacks.add(
        'onAdOpened -- ${ad.request.placementId} --  appInfo -- ${appInfo?.toString()}'));
  }

  @override
  void onAdRenderFail(WindmillNativeAd ad, WMError error) {
    print('flu-nav-onAdRenderFail');
    c.callbacks.add(
        'onAdRenderFail -- ${ad.request.placementId} error: ${error.toJson()}');
  }

  @override
  void onAdRenderSuccess(WindmillNativeAd ad) {
    print('codi -- onAdRenderSuccess: ${ad.adSize}');
    // c.datas.forEach((element) {
    //   if (element.nativeAd != null &&
    //       element.nativeAd == ad &&
    //       ad.adSize != null) {
    //     print('codi -- onAdRenderSuccess update: ${ad.adSize}');
    //     element.height = ad.adSize!.height;
    //   }
    // });
    c.callbacks.add(
        'onAdRenderSuccess -- ${ad.request.placementId} - width : ${ad.adSize?.width} , height : ${ad.adSize?.height}');
  }

  @override
  void onAdClicked(WindmillNativeAd ad) {
    print('flu-nav-onAdClicked');
    c.callbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewClosed(WindmillNativeAd ad) {
    print('flu-nav-onAdDetailViewClosed');
    c.callbacks.add('onAdDetailViewClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewOpened(WindmillNativeAd ad) {
    print('flu-nav-onAdDetailViewOpened');
    c.callbacks.add('onAdDetailViewOpened -- ${ad.request.placementId}');
  }

  @override
  void onAdDidDislike(WindmillNativeAd ad, String reason) {
    print('flu-nav-onAdDidDislike');
    c.callbacks.add('onAdDidDislike -- ${ad.request.placementId}');
    ad.destroy();
    c.adItems.removeLast();
    c.adItems.refresh();
  }

  @override
  void onAdShowError(WindmillNativeAd ad, WMError error) {
    print('flu-nav-onAdShowError');
    c.callbacks.add(
        'onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }
}
