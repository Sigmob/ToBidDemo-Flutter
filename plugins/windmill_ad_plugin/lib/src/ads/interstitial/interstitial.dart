import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/ads/interstitial/interstitial_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/ad_request.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class WindmillInterstitialAd with WindmillEventHandler {
  static const MethodChannel _channel =  MethodChannel('com.windmill/interstitial');

  final AdRequest request;
  late String _uniqId;
  late MethodChannel _adChannel;

  late final WindmillInterstitialListener<WindmillInterstitialAd> _listener;

  WindmillInterstitialAd({
    required this.request,
    required WindmillInterstitialListener<WindmillInterstitialAd> listener,
  }) : super() {
    _uniqId = hashCode.toString();
    _listener = listener;
    delegate = IWindmillInterstitalListener(this, _listener);
    _adChannel = MethodChannel('com.windmill/interstitial.$_uniqId');
    _adChannel.setMethodCallHandler(handleEvent);
  }

  Future<bool> isReady() async {
    bool isReady = await _channel.invokeMethod('isReady', {
      "uniqId": _uniqId
    });
    return isReady;
  }


  Future<AdInfo> getAdInfo() async {
    String adinfoStr = await _channel.invokeMethod("getAdInfo",{
      "uniqId":_uniqId 
    });
    final adInfoJson = json.decode(adinfoStr);
    return AdInfo.fromJson(adInfoJson); 
  }

  Future<void> loadAdData() async {
    await _channel.invokeMethod('load', {
      "uniqId": _uniqId,
      'request': request.toJson()
    });
  }

  Future<void> showAd({Map<String, String>? options}) async{
    await _channel.invokeMethod('showAd', {
      "uniqId": _uniqId,
      'request': request.toJson(),
      'options': options ?? {}
    });
  }

  Future<void> destroy() async {
    await _channel.invokeMethod('destroy', {
      "uniqId": _uniqId
    });
  }
}

