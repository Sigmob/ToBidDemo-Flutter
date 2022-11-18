import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class BannerController extends GetxController {

  var adItems = <BannerAdWidget>[].obs;
  var callbacks = <String>[].obs;
  final Map<String, WindmillBannerAd> _adMap = {};

  @override
  void onInit() {
    super.onInit();
    print('BannerController onInit...');
  }

  WindmillBannerAd getOrCreateWindmillBannerAd({required String placementId, required WindmillBannerListener<WindmillBannerAd> listener}) {
    WindmillBannerAd? bannerAd = getWindmillBannerAd(placementId);
    if (bannerAd != null) return bannerAd;
    AdRequest request = AdRequest(placementId: placementId);
    bannerAd = WindmillBannerAd(
        request: request,
        listener: listener,
    );
    _adMap[placementId] = bannerAd;
    return bannerAd;
  }

  ///  获取WindmillRewardAd，若不存在返回null
  WindmillBannerAd? getWindmillBannerAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }
  void onClose() {
    super.onClose();
    print('BannerController onClose...');
  }
}