import 'package:windmill_ad_plugin/src/ads/interstitial/interstitial.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';

abstract class WindmillInterstitialListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdVideoPlayFinished(T ad );
  void onAdClosed(T ad);
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
    listener.onAdVideoPlayFinished(interstitialAd!);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(interstitialAd!);
  }
}