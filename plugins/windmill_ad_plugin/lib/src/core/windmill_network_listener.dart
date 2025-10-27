import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

abstract class  WindmillNetWorkInitListener {
  void onNetworkInitBefore(int networkId);
  void onNetworkInitSuccess(int networkId);
  void onNetworkInitFaileds(int networkId, WMError? error);
}


abstract class WindmillNetWorkInitEventHandler {
   static late final WindmillNetWorkInitListener? delegate;
   static Future<void> handleEvent(MethodCall call) async {
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
      int networkId =0;
      if (arguments.containsKey('networkId')) {
        networkId = arguments['networkId'] as int;
      }
      switch(call.method) {
        case 'onNetworkInitBefore':
        delegate?.onNetworkInitBefore(networkId);
        break;
        case 'onNetworkInitSuccess':
        delegate?.onNetworkInitSuccess(networkId);
        break;
        case 'onNetworkInitFaileds':
        delegate?.onNetworkInitFaileds(networkId, error);
        break;
      }
    } catch (_) {
    }
  }
}