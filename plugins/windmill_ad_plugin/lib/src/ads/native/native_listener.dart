import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:windmill_ad_plugin/src/ads/native/native.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';


abstract class WindmillNativeListener<T>{
  void onAdLoaded(T ad);
  void onAdFailedToLoad(T ad, WMError error);
  void onAdOpened(T ad);
  void onAdShowError(T ad, WMError error);
  void onAdClicked(T ad);
  void onAdRenderSuccess(T ad);//原生模板广告渲染成功，此时的ad.size.height根据width 完成了动态更新。（只针对模版渲染）
  void onAdRenderFail(T ad, WMError error);//原生模板广告渲染失败（只针对模版渲染）
  void onAdDidDislike(T ad, String reason);//点击dislike回调，开发者需要在这个回调中移除视图，否则，会出现用户点击叉无效的情况
  void onAdDetailViewOpened(T ad);//广告详情页面展示回调
  void onAdDetailViewClosed(T ad);//广告详情页面关闭回调
}

class IWindmillNativeListener with WindmillAdEvent {
  final WindmillNativeAd nativeAd;
  final WindmillNativeListener<WindmillNativeAd> listener;
  IWindmillNativeListener(this.nativeAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {
    listener.onAdLoaded(nativeAd);
  }
  @override
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdFailedToLoad(nativeAd, error);
  }
  @override
  void onAdOpened(Map<String, dynamic>? arguments) {
    listener.onAdOpened(nativeAd);
  }
  @override
  void onAdClicked(Map<String, dynamic>? arguments) {
    listener.onAdClicked(nativeAd);
  }
  @override
  void onAdRenderSuccess(Map<String, dynamic>? arguments){

    if(arguments?.containsKey('width') == true){
      double width = arguments!['width'].toDouble();
      double height = arguments['height'].toDouble();

      print("-------codi------onAdRenderSuccess---${width}----${height}");
      
      if(width >0 && height >0){
        var size = Size(width, height);
        if(Platform.isAndroid){
          size = Size(width/window.devicePixelRatio, height/window.devicePixelRatio);
        }
          nativeAd.adSize = size;
      }
    }
   
    listener.onAdRenderSuccess(nativeAd);
  }
  @override
  void onAdRenderFail(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdRenderFail(nativeAd, error);
  }
  @override
  void onAdDidDislike(Map<String, dynamic>? arguments){
    String reason = arguments!['reason'];
    listener.onAdDidDislike(nativeAd, reason);
  }
  @override
  void onAdDetailViewOpened(Map<String, dynamic>? arguments){
    listener.onAdDetailViewOpened(nativeAd);
  }
  @override
  void onAdDetailViewClosed(Map<String, dynamic>? arguments){
    listener.onAdDetailViewClosed(nativeAd);
  }

} 