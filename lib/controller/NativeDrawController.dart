import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class NativeDrawController extends GetxController {

  var callbacks = <String>[].obs;
  final Map<String, WindmillNativeAd> _adMap = {};

  final PageController pageController = PageController();

  var isLoaded = false;
  var isReady = false;
  @override
  void onInit() {
    super.onInit();
    print('NativeDrawController onInit...');
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

  void nextPage(){
    pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
  }
  ///  获取WindmillRewardAd，若不存在返回null
  WindmillNativeAd? getWindmillNativeAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }
  
  void onClose() {
    super.onClose();
    print('NativeDrawController onClose...');
  }
}