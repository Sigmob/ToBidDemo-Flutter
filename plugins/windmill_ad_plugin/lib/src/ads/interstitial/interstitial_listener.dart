import 'package:windmill_ad_plugin/src/ads/interstitial/interstitial.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_enum.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

abstract class WindmillInterstitialListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdVideoPlayFinished(T ad);
  void onAdClosed(T ad);
  void onAdDidCloseOtherController(
      T ad, WindmillInteractionType interactionType);
}

class IWindmillInterstitalListener with WindmillAdEvent {
  final WindmillInterstitialAd? interstitialAd;
  final WindmillInterstitialListener<WindmillInterstitialAd> listener;

  IWindmillInterstitalListener(this.interstitialAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {
    listener.onAdLoaded(interstitialAd!);
  }

  @override
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdFailedToLoad(interstitialAd!, error);
  }

  @override
  void onAdOpened(Map<String, dynamic>? arguments) {
    listener.onAdOpened(interstitialAd!);
  }

  @override
  void onAdClicked(Map<String, dynamic>? arguments) {
    listener.onAdClicked(interstitialAd!);
  }

  @override
  void onAdSkiped(Map<String, dynamic>? arguments) {
    listener.onAdSkiped(interstitialAd!);
  }

  @override
  void onAdVideoPlayFinished(WMError? error, Map<String, dynamic>? arguments) {
    if (error != null) {
      listener.onAdShowError(interstitialAd!, error);
    } else {
      listener.onAdVideoPlayFinished(interstitialAd!);
    }
  }

  @override
  void onAdShowError(WMError? error, Map<String, dynamic>? arguments) {
    listener.onAdShowError(interstitialAd!, error!);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(interstitialAd!);
  }

  @override
  void onAdDetailViewClosed(Map<String, dynamic>? arguments) {
    WindmillInteractionType interactionType =
        WindmillInteractionType.interactionTypeCustorm;

    if (arguments != null && arguments.containsKey('interactionType')) {
      String type = arguments['interactionType'] as String;
      switch (type) {
        case "0":
          {
            interactionType = WindmillInteractionType.interactionTypeCustorm;
          }
          break;
        case "1":
          {
            interactionType =
                WindmillInteractionType.interactionTypeNO_INTERACTION;
          }
          break;
        case "2":
          {
            interactionType = WindmillInteractionType.interactionTypeURL;
          }
          break;

        case "3":
          {
            interactionType = WindmillInteractionType.interactionTypePage;
          }
          break;
        case "4":
          {
            interactionType = WindmillInteractionType.interactionTypeDownload;
          }
          break;
        case "5":
          {
            interactionType = WindmillInteractionType.interactionTypePhone;
          }
          break;
        case "6":
          {
            interactionType = WindmillInteractionType.interactionTypeMessage;
          }
          break;
        case "7":
          {
            interactionType = WindmillInteractionType.interactionTypeEmail;
          }
          break;
        case "8":
          {
            interactionType = WindmillInteractionType.interactionTypeVideoAdDetail;
          }
          break;
        case "100":
          {
            interactionType = WindmillInteractionType.interactionTypeMediationOthers;
          }
          break;
      }
    }

    listener.onAdDidCloseOtherController(interstitialAd!, interactionType);
  }
  @override
  void onAdAutoLoadSuccess(Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadSuccess
    listener.onAdAutoLoadSuccess(interstitialAd!);
  }
  @override
  void onAdAutoLoadFailed(WMError error, Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadFailed
    listener.onAdAutoLoadFailed(interstitialAd!, error);
  }
  @override
  void onBidAdSourceStart(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
    listener.onBidAdSourceStart(interstitialAd!, adInfo);
  }
  @override
  void onBidAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
    listener.onBidAdSourceSuccess(interstitialAd!, adInfo);
  }
  @override
  void onBidAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceFailed
    listener.onBidAdSourceFailed(interstitialAd!, adInfo, error);
  }
  @override
  void onAdSourceStartLoading(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
    listener.onAdSourceStartLoading(interstitialAd!, adInfo);
  }
  @override
  void onAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
    listener.onAdSourceSuccess(interstitialAd!, adInfo);
  }
  @override
  void onAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceFailed
    listener.onAdSourceFailed(interstitialAd!, adInfo, error);
  }
}
