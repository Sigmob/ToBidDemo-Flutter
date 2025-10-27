import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class SplashController extends GetxController {

  final Map<String, WindmillSplashAd> _adMap = {};
  var callbacks = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    print('SplashController onInit...');
  }

  WindmillSplashAd getOrCreateWindmillSplashAd({required String placementId,String? userId,required Size size, String? title, String? desc, required WindmillSplashListener<WindmillSplashAd> listener}) {
    WindmillSplashAd? splashAd = getWindmillSplashAd(placementId);
    if (splashAd != null) return splashAd;
    AdRequest request = AdRequest(placementId: placementId,userId: userId);
    splashAd = WindmillSplashAd(
      request: request,
      listener: listener,
      width: size.width,
      height: size.height,
      title: title,
      desc: desc,
    );
    _adMap[placementId] = splashAd;
    return splashAd;
  }

  ///  获取WindmillRewardAd，若不存在返回null
  WindmillSplashAd? getWindmillSplashAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }

  void removeSplashAd(String placementId) {
   if (_adMap.containsKey(placementId)) {
      _adMap.remove(placementId);
    }
  }

  void onClose() {
    super.onClose();
    print('SplashController onClose...');
  }
}