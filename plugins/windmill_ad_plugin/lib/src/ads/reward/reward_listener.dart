import 'dart:convert';

import 'package:windmill_ad_plugin/src/ads/reward/reward.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

abstract class WindmillRewardListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdReward(T ad, RewardInfo rewardInfo);
  void onAdVideoPlayFinished(T ad);
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
    RewardInfo rewardInfo = RewardInfo();
    rewardInfo.isReward = true;
    if (arguments != null) {
      if (arguments['user_id'] != null) {
        rewardInfo.userId = arguments['user_id'] as String;
      }

      if (arguments['trans_id'] != null) {
        rewardInfo.transId = arguments['trans_id'] as String;
      }

      if (arguments.containsKey("customData")) {
        try {
          var customData = jsonDecode(arguments['customData']);
          rewardInfo.customData = customData as Map<String, dynamic>?;
        } catch (e) {
          print(" unknow error: $e");
        }
      }
    }

    listener.onAdReward(rewardAd!, rewardInfo);
  }

  @override
  void onAdVideoPlayFinished(WMError? error, Map<String, dynamic>? arguments) {
    if (error != null) {
      listener.onAdShowError(rewardAd!, error);
    } else {
      listener.onAdVideoPlayFinished(rewardAd!);
    }
  }

  @override
  void onAdShowError(WMError? error, Map<String, dynamic>? arguments) {
    listener.onAdShowError(rewardAd!, error!);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(rewardAd!);
  }
  @override
  void onAdAutoLoadSuccess(Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadSuccess
    listener.onAdAutoLoadSuccess(rewardAd!);
  }
  @override
  void onAdAutoLoadFailed(WMError error, Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadFailed
    listener.onAdAutoLoadFailed(rewardAd!, error);
  }
  @override
  void onBidAdSourceStart(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
    listener.onBidAdSourceStart(rewardAd!, adInfo);
  }
  @override
  void onBidAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
    listener.onBidAdSourceSuccess(rewardAd!, adInfo);
  }
  @override
  void onBidAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceFailed
    listener.onBidAdSourceFailed(rewardAd!, adInfo, error);
  }
  @override
  void onAdSourceStartLoading(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
    listener.onAdSourceStartLoading(rewardAd!, adInfo);
  }
  @override
  void onAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
    listener.onAdSourceSuccess(rewardAd!, adInfo);
  }
  @override
  void onAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceFailed
    listener.onAdSourceFailed(rewardAd!, adInfo, error);
  }
}
