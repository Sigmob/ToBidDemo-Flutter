import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:windmill_ad_plugin/src/ads/native/native.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/native_info.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';


abstract class WindmillNativeListener<T>{
  void onAdLoaded(T ad, WindMillNativeInfo? nativeInfo);
  void onAdFailedToLoad(T ad, WMError error);
  void onAdOpened(T ad);
  void onAdShowError(T ad, WMError error);
  void onAdClicked(T ad);
  void onAdRenderSuccess(T ad);//原生模板广告渲染成功，此时的ad.size.height根据width 完成了动态更新。（只针对模版渲染）
  void onAdRenderFail(T ad, WMError error);//原生模板广告渲染失败（只针对模版渲染）
  void onAdDidDislike(T ad, String reason);//点击dislike回调，开发者需要在这个回调中移除视图，否则，会出现用户点击叉无效的情况
  void onAdDetailViewOpened(T ad);//广告详情页面展示回调
  void onAdDetailViewClosed(T ad);//广告详情页面关闭回调
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

class IWindmillNativeListener with WindmillAdEvent {
  final WindmillNativeAd nativeAd;
  final WindmillNativeListener<WindmillNativeAd> listener;
  IWindmillNativeListener(this.nativeAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {
     WindMillNativeInfo? nativeInfo;
    if (arguments!.containsKey('nativeInfo')) {
      String infoStr = arguments['nativeInfo'] as String;
      print(infoStr);
      nativeInfo = WindMillNativeInfo.fromJson(jsonDecode(infoStr));
    }
    listener.onAdLoaded(nativeAd, nativeInfo);
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
  @override
  void onAdAutoLoadSuccess(Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadSuccess
    listener.onAdAutoLoadSuccess(nativeAd);
  }
  @override
  void onAdAutoLoadFailed(WMError error, Map<String, dynamic>? arguments) {
    // TODO: implement onAdAutoLoadFailed
    listener.onAdAutoLoadFailed(nativeAd, error);
  }
  @override
  void onBidAdSourceStart(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
    listener.onBidAdSourceStart(nativeAd, adInfo);
  }
  @override
  void onBidAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
    listener.onBidAdSourceSuccess(nativeAd, adInfo);
  }
  @override
  void onBidAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceFailed
    listener.onBidAdSourceFailed(nativeAd, adInfo, error);
  }
  @override
  void onAdSourceStartLoading(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
    listener.onAdSourceStartLoading(nativeAd, adInfo);
  }
  @override
  void onAdSourceSuccess(Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
    listener.onAdSourceSuccess(nativeAd, adInfo);
  }
  @override
  void onAdSourceFailed(WMError error, Map<String, dynamic>? arguments, AdInfo? adInfo) {
    // TODO: implement onAdSourceFailed
    listener.onAdSourceFailed(nativeAd, adInfo, error);
  }

} 