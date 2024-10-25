import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

import '../models/error.dart';

abstract class WindmillAdEvent {
  void onAdLoaded(Map<String, dynamic>? arguments) {}
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {}
  void onAdOpened(Map<String, dynamic>? arguments) {}
  void onAdClicked(Map<String, dynamic>? arguments) {}
  void onAdSkiped(Map<String, dynamic>? arguments) {}
  void onAdReward(Map<String, dynamic>? arguments) {}
  void onAdVideoPlayFinished(WMError? error, Map<String, dynamic>? arguments) {}
  void onAdClosed(Map<String, dynamic>? arguments) {}
  void onAdAutoRefreshFail(WMError error, Map<String, dynamic>? arguments) {}
  void onAdAutoRefreshed(Map<String, dynamic>? arguments) {}
  void onAdRenderSuccess(Map<String, dynamic>? arguments){}
  void onAdRenderFail(WMError error, Map<String, dynamic>? arguments) {}
  void onAdDidDislike(Map<String, dynamic>? arguments){}
  void onAdDetailViewOpened(Map<String, dynamic>? arguments){}
  void onAdDetailViewClosed(Map<String, dynamic>? arguments){}
  void onAdShowError(WMError? error, Map<String, dynamic>? arguments) {}
  // 广告播放中加载成功回调
  void onAdAutoLoadSuccess(Map<String, dynamic>? arguments) {}
  // 广告播放中加载失败回调
  void onAdAutoLoadFailed(WMError error, Map<String, dynamic>? arguments) {}
  // 竞价广告源开始竞价回调
  void onBidAdSourceStart(Map<String, dynamic>? arguments, AdInfo? adInfo) {}
  // 竞价广告源竞价成功回调
  void onBidAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {}
  // 竞价广告源竞价失败回调
  void onBidAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {}
  // 广告源开始加载回调
  void onAdSourceStartLoading(Map<String, dynamic>? arguments, AdInfo? adInfo) {}
  // 广告源广告填充回调
  void onAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {}
  // 广告源加载失败回调
  void onAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {}
}

abstract class WindmillEventHandler {

  late final WindmillAdEvent? delegate;

  Future<void> handleEvent(MethodCall call) async {
    try {
      if(delegate == null) return;
      Map<String, dynamic> arguments = {};
      if (call.arguments != null) {
        arguments.addAll(Map<String, dynamic>.from(call.arguments));
      }
      WMError? error;
      if(arguments.containsKey('code')) {
        var errorCode = arguments['code'] as int;
        var msg = arguments['message'] as String;
        error = WMError(errorCode, msg);
      }
      AdInfo? adInfo;
      if (arguments.containsKey('adInfo'))  {
        var adInfoStr = arguments['adInfo'] as String;
        adInfo = AdInfo.fromJson(jsonDecode(adInfoStr));
      }
      switch (call.method) {
        case 'onAdLoaded':
          delegate!.onAdLoaded(arguments);
          break;
        case 'onAdFailedToLoad':
          delegate!.onAdFailedToLoad(error!, arguments);
          break;
        case 'onAdOpened':
          delegate!.onAdOpened(arguments);
          break;
        case 'onAdClicked':
          delegate!.onAdClicked(arguments);
          break;
        case 'onAdSkiped':
          delegate!.onAdSkiped(arguments);
          break;
        case 'onAdReward':
          delegate!.onAdReward(arguments);
          break;
        case 'onAdVideoPlayFinished':
          delegate!.onAdVideoPlayFinished(error, arguments);
          break;
        case 'onAdClosed':
          delegate!.onAdClosed(arguments);
          break;
        case 'onAdAutoRefreshed':
          delegate!.onAdAutoRefreshed(arguments);
          break;
        case 'onAdAutoRefreshFail':
          delegate!.onAdAutoRefreshFail(error!, arguments);
          break;
        case 'onAdRenderFail':
          delegate!.onAdRenderFail(error!, arguments);
          break;
        case 'onAdRenderSuccess':
          delegate!.onAdRenderSuccess(arguments);
          break;
        case 'onAdDidDislike':
          delegate!.onAdDidDislike(arguments);
          break;
        case 'onAdDetailViewOpened':
          delegate!.onAdDetailViewOpened(arguments);
          break;
        case 'onAdDetailViewClosed':
          delegate!.onAdDetailViewClosed(arguments);
          break;
        case 'onAdShowError':
          delegate!.onAdShowError(error!,arguments);
          break;
        case 'onAdAutoLoadSuccess':
          delegate!.onAdAutoLoadSuccess(arguments);
          break;
        case 'onAdAutoLoadFailed':
          delegate!.onAdAutoLoadFailed(error!, arguments);
          break;
        case 'onBidAdSourceStart':
          delegate!.onBidAdSourceStart(arguments, adInfo);
          break;
        case 'onBidAdSourceSuccess':
          delegate!.onBidAdSourceSuccess(arguments, adInfo);
          break;
        case 'onBidAdSourceFailed':
          delegate!.onBidAdSourceFailed(error!, arguments, adInfo);
          break;
        case 'onAdSourceStartLoading':
          delegate!.onAdSourceStartLoading(arguments, adInfo);
          break;
        case 'onAdSourceSuccess':
          delegate!.onAdSourceSuccess(arguments, adInfo);
          break;
        case 'onAdSourceFailed':
          delegate!.onAdSourceFailed(error!, arguments, adInfo);
          break;
    
      }
    } catch (_) {
    }
  }
}