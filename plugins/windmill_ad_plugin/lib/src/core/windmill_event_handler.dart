import 'package:flutter/services.dart';

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
    
      }
    } catch (_) {
    }
  }
}