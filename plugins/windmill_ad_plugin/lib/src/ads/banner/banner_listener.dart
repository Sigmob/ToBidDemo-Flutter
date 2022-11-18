import 'dart:ui';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windmill_ad_plugin/src/ads/banner/banner.dart';
import 'package:windmill_ad_plugin/src/core/windmill_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/error.dart';

abstract class WindmillBannerListener<T> extends WindmillInterface<T> {
  void onAdAutoRefreshFail(T ad, WMError error);
  void onAdAutoRefreshed(T ad);
  void onAdClosed(T ad);
}

class IWindmillBannerListener with WindmillAdEvent {

  final WindmillBannerAd? bannerAd;
  final WindmillBannerListener<WindmillBannerAd> listener;

  IWindmillBannerListener(this.bannerAd, this.listener);

  @override
  void onAdLoaded(Map<String, dynamic>? arguments) {

    if(arguments?.containsKey('width') == true){

          double width = arguments!['width'];
          double height = arguments['height'];
          
          var size = Size(width, height);

          if(Platform.isAndroid && width >0 && height >0){
                size = Size(width/window.devicePixelRatio, height/window.devicePixelRatio);
          } 

          bannerAd?.adSize = size;
    }
    listener.onAdLoaded(bannerAd!);
  }

  @override
  void onAdFailedToLoad(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdFailedToLoad(bannerAd!, error);
  }

  @override
  void onAdOpened(Map<String, dynamic>? arguments) {
    listener.onAdOpened(bannerAd!);
  }

  @override
  void onAdClicked(Map<String, dynamic>? arguments) {
    listener.onAdClicked(bannerAd!);
  }

  @override
  void onAdClosed(Map<String, dynamic>? arguments) {
    listener.onAdClosed(bannerAd!);
  }

  @override
  void onAdAutoRefreshFail(WMError error, Map<String, dynamic>? arguments) {
    listener.onAdAutoRefreshFail(bannerAd!, error);
  }

  @override
  void onAdAutoRefreshed(Map<String, dynamic>? arguments) {

    if(arguments?.containsKey('width') == true){

        double width = arguments!['width'].toDouble();
        double height = arguments['height'].toDouble();
        var size = Size(width, height);

        if(Platform.isAndroid && width >0 && height >0){
           size = Size(width/window.devicePixelRatio, height/window.devicePixelRatio);
        }
      

        bannerAd?.adSize = size;
    }

    listener.onAdAutoRefreshed(bannerAd!);
  }
}