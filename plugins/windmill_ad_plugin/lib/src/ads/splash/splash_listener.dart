import 'package:windmill_ad_plugin/src/ads/splash/splash.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_enum.dart';

abstract class WindmillSplashListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdClosed(T ad);
  void onAdDidCloseOtherController(
      T ad, WindmillInteractionType interactionType);
}

class IWindmillSplashListener with WindmillAdEvent {
  final WindmillSplashAd? splashAd;
  final WindmillSplashListener<WindmillSplashAd> listener;

  IWindmillSplashListener(this.splashAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {
    listener.onAdLoaded(splashAd!);
  }

  @override
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdFailedToLoad(splashAd!, error);
  }

  @override
  void onAdOpened(Map<String, dynamic>? arguments) {
    listener.onAdOpened(splashAd!);
  }

  @override
  void onAdClicked(Map<String, dynamic>? arguments) {
    listener.onAdClicked(splashAd!);
  }

  @override
  void onAdSkiped(Map<String, dynamic>? arguments) {
    listener.onAdSkiped(splashAd!);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(splashAd!);
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

    listener.onAdDidCloseOtherController(splashAd!, interactionType);
  }
}
