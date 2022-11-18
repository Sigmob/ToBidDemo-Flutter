import 'package:windmill_ad_plugin/src/ads/splash/splash.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';

abstract class WindmillSplashListener<T> extends WindmillInterface<T> {
  void onAdSkiped(T ad);
  void onAdClosed(T ad);
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
}