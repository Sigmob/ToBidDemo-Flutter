import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class RwController extends GetxController {

  var rwCallbacks = <String>[].obs;
  final Map<String, WindmillRewardAd> _adMap = {};

  @override
  void onInit() {
    super.onInit();
  }

  void onClose() {
    super.onClose();
  }

  ///  获取WindmillRewardAd，若不存在，则创建WindmillRewardAd
  WindmillRewardAd getOrCreateWindmillRewardAd({required String placementId, String? userId, required WindmillRewardListener<WindmillRewardAd> listener}) {
    WindmillRewardAd? rewardAd = getWindmillRewardAd(placementId);
    if (rewardAd != null) return rewardAd;
    AdRequest request = AdRequest(placementId: placementId,userId: userId);
    rewardAd = WindmillRewardAd(
        request: request,
        listener: listener
    );
    _adMap[placementId] = rewardAd;
    return rewardAd;
  }

  ///  获取WindmillRewardAd，若不存在返回null
  WindmillRewardAd? getWindmillRewardAd(String placementId) {
    if (_adMap.containsKey(placementId)) {
      return _adMap[placementId];
    }
    return null;
  }

}
