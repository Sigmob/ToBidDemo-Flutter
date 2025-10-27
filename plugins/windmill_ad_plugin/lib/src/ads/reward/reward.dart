import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/ads/reward/reward_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/ad_request.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


class RewardInfo {
   late bool isReward;
   late String transId;
   late String userId;
   Map<String,dynamic>? customData;
}

class WindmillRewardAd with WindmillEventHandler {

  static const MethodChannel _channel =  MethodChannel('com.windmill/reward');

  final AdRequest request;
  late String _uniqId;
  late MethodChannel _adChannel;

  late final WindmillRewardListener<WindmillRewardAd> _listener;

  WindmillRewardAd({
    required this.request,
    required WindmillRewardListener<WindmillRewardAd> listener,
  }) : super() {
    _uniqId = hashCode.toString();
    _listener = listener;
    delegate = IWindmillRewardListener(this, _listener);
    _adChannel = MethodChannel('com.windmill/reward.$_uniqId');
    _adChannel.setMethodCallHandler(handleEvent);
    _channel.invokeMethod("initRequest", {
      "uniqId": _uniqId,
      "request": request.toJson(),
    });
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

  Future<List<AdInfo>?> getCacheAdInfoList() async{

    List<Object?>? listStr =  await _channel.invokeMethod('getCacheAdInfoList', {
      "uniqId": _uniqId,
    })??[];


    if(listStr.isNotEmpty){

        var cacheList = List.generate(listStr
        .length
        , (index){
              var adInfoStr  = listStr[index] as String;
              final adInfoJson = json.decode(adInfoStr);
              return AdInfo.fromJson(adInfoJson);
        });
        return cacheList; 
    } 
   
    return null;
  }

  /// 自定义分组
  Future<void> setCustomGroup(Map<String, String> customGroup) async {
    await _channel.invokeMethod('setCustomGroup', {
       "uniqId":_uniqId,
       "customGroup": customGroup
    });
  }
  
  /// 广告过滤 (仅Android支持)
  Future<void> addFilter(List<WindMillFilterModel> modelList) async {
    if (Platform.isAndroid) {
      List<Map<String, dynamic>> listMap = [];
      for (WindMillFilterModel model in modelList) {
        listMap.add(model.toJson());
      }
      await _channel.invokeMethod("addFilter", {
        "uniqId": _uniqId,
        "modelList": listMap
      });
    }
  }
  
  Future<void> loadAdData() async {
    await _channel.invokeMethod('load', {
      "uniqId": _uniqId,
      // 'request': request.toJson()
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


