import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

import '../models/error.dart';

abstract class WindmillInterface<T> {
  void onAdLoaded(T ad);
  void onAdFailedToLoad(T ad, WMError error);
  void onAdOpened(T ad);
  void onAdShowError(T ad, WMError error);
  void onAdClicked(T ad);
  // 广告播放中加载成功回调
  void onAdAutoLoadSuccess(T ad);
  // 广告播放中加载失败回调
  void onAdAutoLoadFailed(T ad, WMError error);
   // 竞价广告源开始竞价回调
  void onBidAdSourceStart(T ad, AdInfo? adInfo);
  // 竞价广告源竞价成功回调
  void onBidAdSourceSuccess(T ad, AdInfo? adInfo);
  // 竞价广告源竞价失败回调
  void onBidAdSourceFailed(T ad, AdInfo? adInfo, WMError error);
  // 广告源开始加载回调
  void onAdSourceStartLoading(T ad, AdInfo? adInfo);
  // 广告源广告填充回调
  void onAdSourceSuccess(T ad, AdInfo? adInfo);
  // 广告源加载失败回调
  void onAdSourceFailed(T ad, AdInfo? adInfo, WMError error);
}