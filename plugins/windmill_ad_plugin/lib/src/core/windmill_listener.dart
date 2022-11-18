import '../models/error.dart';

abstract class WindmillInterface<T> {
  void onAdLoaded(T ad);
  void onAdFailedToLoad(T ad, WMError error);
  void onAdOpened(T ad);
  void onAdShowError(T ad, WMError error);
  void onAdClicked(T ad);
}