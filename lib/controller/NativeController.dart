import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class NativeController extends GetxController {

  var adItems = <NativeAdWidget>[].obs;
  var callbacks = <String>[].obs;
  final Map<String, WindmillNativeAd> _adMap = {};

  @override
  void onInit() {
    super.onInit();
    print('NativeController onInit...');
  }

  WindmillNativeAd getOrCreateWindmillNativeAd({required String placementId,String? userId,required Size size, required WindmillNativeListener<WindmillNativeAd> listener}) {
    WindmillNativeAd? nativeAd = getWindmillNativeAd(placementId);
    if (nativeAd != null) return nativeAd;
    AdRequest request = AdRequest(placementId: placementId,userId: userId);
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

  void removeWindmillNativeAd(String placementId) {
     if (_adMap.containsKey(placementId)) {
      _adMap.remove(placementId);
     }
  }
  
  void onClose() {
    super.onClose();
    print('NativeController onClose...');
  }
}