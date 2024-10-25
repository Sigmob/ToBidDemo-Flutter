import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/ads/splash/splash_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/ad_request.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class WindmillSplashAd with WindmillEventHandler{

  static const MethodChannel _channel =  MethodChannel('com.windmill/splash');

  static const double APP_BOTTOM_HEIGHT = 100.0;

  final double width; //广告宽度
  final double height; //广告高度，设置为0表示根据width自适应，通过adSize.height获取自适应后的高度
  late final Size? adSize; // 广告渲染成功后，返回广实际大小
  late final ValueNotifier<Size> sizeNotify;

  final AdRequest request;
  late String _uniqId;
  String? title;
  String? desc;

  late MethodChannel _adChannel;
  late final WindmillSplashListener<WindmillSplashAd> _listener;
  WindmillSplashAd({
    Key? key,
    required this.request,
    required this.width,
    required this.height,
    this.title,
    this.desc,
    required WindmillSplashListener<WindmillSplashAd> listener
  }):super() {
    _uniqId = hashCode.toString();
    _listener = listener;
    delegate = IWindmillSplashListener(this, _listener);
    _adChannel = MethodChannel('com.windmill/splash.$_uniqId');
    _adChannel.setMethodCallHandler(handleEvent);
    _channel.invokeMethod("initRequest", {
      "uniqId": _uniqId,
      'request': request.toJson()
    });
  }


  void updateAdSize(Size size) {
    adSize = size;
  }

  Size? getAdSize(){
    return adSize;
  }

  Future<bool> isReady() async {
    bool isReady = await _channel.invokeMethod('isReady', {
      "uniqId": _uniqId
    });
    return isReady;
  }

  Future<void> loadAd() async {

    var optHeight = height;
    if(Platform.isIOS && title != null ){ 
        optHeight -= APP_BOTTOM_HEIGHT;
    }
    await _channel.invokeMethod('load', {
      "uniqId": _uniqId,
      "width":  width,
      "height": optHeight,
      "title": title,
      "desc": desc,
      // 'request': request.toJson()
    });
  }

  Future<void> showAd() async {
    await _channel.invokeMethod('showAd', {
      "uniqId": _uniqId,
    });
  }

  Future<List<AdInfo>?> getCacheAdInfoList() async{

    List<Object?> listStr =  await _channel.invokeMethod('getCacheAdInfoList', {
      "uniqId": _uniqId,
    });


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
  Future<AdInfo> getAdInfo() async {
    String adinfoStr = await _channel.invokeMethod("getAdInfo",{
      "uniqId":_uniqId 
    });
    final adInfoJson = json.decode(adinfoStr);
    return AdInfo.fromJson(adInfoJson); 
  }
  

  Future<void> destroy() async {
    await _channel.invokeMethod('destroy', {
      "uniqId": _uniqId
    });
  }
}
