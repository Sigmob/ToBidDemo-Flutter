import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

import '../pages/home/splash_page.dart';
import 'controller.dart';


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

  void onClose() {
    super.onClose();
    print('SplashController onClose...');
  }

  void removeSplashAd(String placementId) {
   if (_adMap.containsKey(placementId)) {
      _adMap.remove(placementId);
    }
  }

  Future<void> adLoad(String placementId) async {
    final c = Get.find<SplashController>();
    final adcontroller = Get.find<Controller>();

    Size size = Size(window.physicalSize.width, window.physicalSize.height);
    if (Platform.isIOS) {
      size = Size(window.physicalSize.width / window.devicePixelRatio,
          window.physicalSize.height / window.devicePixelRatio);
      c.removeSplashAd(placementId);
      WindmillSplashAd ad = c.getOrCreateWindmillSplashAd(
          placementId: placementId,
          userId: adcontroller.adSetting.value.otherSetting?.userId,
          size: size,
          title: "大象驾到Pro",
          desc: "题   准,      通   过   率   高",
          listener: IWMSplashListener());

      ad.loadAd();
    }else if (Platform.isAndroid) {
      c.removeSplashAd(placementId);
      c.getOrCreateWindmillSplashAd(
          placementId: placementId,
          userId: adcontroller.adSetting.value.otherSetting?.userId,
          size: size,
          title: "大象驾到Pro",
          desc: "题   准,      通   过   率   高",
          listener: IWMSplashListener());
      _adMap[placementId] ?.loadAd();
      // AdRequest request = AdRequest(placementId: placementId,userId:  adcontroller.adSetting.value.otherSetting?.userId,);
      //
      // ad = WindmillSplashAd(
      //   request: request,
      //   listener: IWMSplashListener(),
      //   width: size.width,
      //   height: size.height,
      //   // title: title,
      //   // desc: desc,
      // );
      // ad.loadAd();
    }

  }

  void adPlay(String placementId) async {
    // if(lastPopTime != null && DateTime.now().difference(lastPopTime) < Duration(seconds: 2)) return;

    final SplashController c = Get.find<SplashController>();

    WindmillSplashAd? ad = c.getWindmillSplashAd(placementId);
    if (ad == null) return;
    bool isReady = await ad.isReady();

    if (isReady) {
      ad.showAd();
    }else {
      debugPrint("ad is not ready");
      // IEventBus.get().post(IEvent(JkKey.EVENT_splashAdLoadFailed,""));
    }
    // lastPopTime = DateTime.now();
  }
}