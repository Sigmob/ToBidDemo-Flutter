import 'package:windmill_ad_plugin/src/ads/reward/reward.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';

abstract class WindmillRewardListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdReward(T ad);
  void onAdVideoPlayFinished(T ad, WMError? error);
  void onAdClosed(T ad);
}

class IWindmillRewardListener with WindmillAdEvent {

  final WindmillRewardAd? rewardAd;
  final WindmillRewardListener<WindmillRewardAd> listener;

  IWindmillRewardListener(this.rewardAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {
    listener.onAdLoaded(rewardAd!);
  }

  @override
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdFailedToLoad(rewardAd!, error);
  }

  @override
  void onAdOpened(Map<String, dynamic>? arguments) {
    listener.onAdOpened(rewardAd!);
  }

  @override
  void onAdClicked(Map<String, dynamic>? arguments) {
    listener.onAdClicked(rewardAd!);
  }

  @override
  void onAdSkiped(Map<String, dynamic>? arguments) {
    listener.onAdSkiped(rewardAd!);
  }

  @override
  void onAdReward(Map<String, dynamic>? arguments) {
    listener.onAdReward(rewardAd!);
  }

  @override
  void onAdVideoPlayFinished(WMError? error, Map<String, dynamic>? arguments) {
    listener.onAdVideoPlayFinished(rewardAd!, error);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(rewardAd!);
  }
}