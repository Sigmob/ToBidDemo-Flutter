import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class IntersititialController extends GetxController {

  var callbacks = <String>[].obs;
  final Map<String, WindmillInterstitialAd> _adMap = {};

  @override
  void onInit() {
    super.onInit();
  }

  void onClose() {
    super.onClose();
    _adMap.forEach((key, value) {
      value.destory();
    });
    _adMap.clear();
  }

  ///  获取WindmillIntersititialAd，若不存在，则创建WindmillRewardAd
  WindmillInterstitialAd getOrCreateWindmillInterstitialAd({required String placementId, required WindmillInterstitialListener<WindmillInterstitialAd> listener}) {
    WindmillInterstitialAd? ad = getWindmillInterstitialAd(placementId);
    if (ad != null) return ad;
    AdRequest request = AdRequest(placementId: placementId);
    ad = WindmillInterstitialAd(
        request: request,
        listener: listener
    );
    _adMap[placementId] = ad;
    return ad;
  }

  ///  获取WindmillIntersititialAd，若不存在返回null
  WindmillInterstitialAd? getWindmillInterstitialAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }

}
