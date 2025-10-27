import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/SplashController.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';
import 'package:windmill_ad_plugin_example/pages/settings/sdk_params_page.dart';
import 'dart:ui';
import '../../controller/controller.dart';
import '../../widgets/adslot_widget.dart';

class SplashPage extends StatelessWidget with WidgetsBindingObserver {
  const SplashPage({Key? key}) : super(key: key);
  static var lastPopTime = null;
  @override
  Widget build(BuildContext context) {
    print("splash_page --- build");
    return Scaffold(
        appBar: AppBar(
          title: const Text('开屏广告'),
        ),
        body: _build());
  }

  Widget _build() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Obx(() => _buildAdSlotWidget()),
            SizedBox(
              height: 10.rpx,
            ),
            Obx(() => _logWidget()),
          ]),
        ),
      ],
    );
  }

  Widget _logWidget() {
    final c = Get.find<SplashController>();
    return Column(
        children: List.generate(
            c.callbacks.length, (index) => Text('${c.callbacks[index]}')));
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if (c.adSetting.value.slotIds == null) return Center();
    return AdSlotWidget(
      c.adSetting.value.slotIds!
          .where((element) => element.adType == 2)
          .toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }

  void _adPlay(String placementId) async {
    if(lastPopTime != null && DateTime.now().difference(lastPopTime) < Duration(seconds: 2)) return;

    final SplashController c = Get.find<SplashController>();

    WindmillSplashAd? ad = c.getWindmillSplashAd(placementId);
    if (ad == null) return;
    bool isReady = await ad.isReady();

    if (isReady) {
      ad.showAd();
    }
    lastPopTime = DateTime.now();
  }

  void _adLoad(String placementId) {
    final c = Get.find<SplashController>();
    final adcontroller = Get.find<Controller>();

    Size size = Size(window.physicalSize.width, window.physicalSize.height);
    if (Platform.isIOS) {
      size = Size(window.physicalSize.width / window.devicePixelRatio,
          window.physicalSize.height / window.devicePixelRatio);
    }
    c.removeSplashAd(placementId);
    WindmillSplashAd ad = c.getOrCreateWindmillSplashAd(
        placementId: placementId,
        userId: adcontroller.adSetting.value.otherSetting?.userId,
        size: size,
        title: "开心消消乐",
        desc: "测试开始",
        listener: IWMSplashListener());

    ad.loadAd();
  }
}

class IWMSplashListener extends WindmillSplashListener<WindmillSplashAd> {
  final SplashController c = Get.find();

  @override
  void onAdClicked(WindmillSplashAd ad) {
    print('flu-Splash --- onAdClicked');
    c.callbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdFailedToLoad(WindmillSplashAd ad, WMError error) {
    print('flu-Splash --- onAdFailedToLoad -- ${error.toJson()}');
    c.callbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
  }

  @override
  void onAdLoaded(WindmillSplashAd ad) {
    print('flu-Splash --- onAdLoaded');
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId}');
    ad.getCacheAdInfoList().then((adinfos) => adinfos?.forEach((element) {
          c.callbacks.add(
              'onAdLoaded -- ${ad.request.placementId} -- adInfo -- ${element.toJson()}');
        }));
    c.adPlay(ad.request.placementId);
  }

  @override
  void onAdOpened(WindmillSplashAd ad) {
    print('flu-Splash --- onAdOpened');
    ad.getAdInfo().then((adinfo) => c.callbacks.add(
        'onAdOpened -- ${ad.request.placementId} -- adInfo -- ${adinfo.toJson()}'));
  }

  @override
  void onAdShowError(WindmillSplashAd ad, WMError error) {
    print('flu-Splash --- onAdShowError');
    c.callbacks.add(
        'onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }

  @override
  void onAdClosed(WindmillSplashAd ad) {
    print('flu-Splash --- onAdClosed');
    // TODO: implement onAdClosed
    c.callbacks.add('onAdClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdSkiped(WindmillSplashAd ad) {
    print('flu-Splash --- onAdSkiped');
    // TODO: implement onAdSkiped
    c.callbacks.add('onAdSkiped -- ${ad.request.placementId}');
  }

  @override
  void onAdDidCloseOtherController(
      WindmillSplashAd ad, WindmillInteractionType interactionType) {
    print('flu-Splash --- onAdDidCloseOtherController');    
    // TODO: implement onAdDidCloseOtherController
    c.callbacks.add(
        'onAdDidCloseOtherController -- ${ad.request.placementId},interactionType: ${interactionType.toString()}');
  }
  
  @override
  void onAdSourceFailed(WindmillSplashAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onAdSourceFailed
    // print('onAdSourceFailed,adInfo:${adInfo?.toJson()}');
    //  c.callbacks.add('onAdSourceFailed -- ${ad.request.placementId},adInfo:${adInfo?.toJson()},error: ${error.toJson()}');
  }
  
  @override
  void onAdSourceStartLoading(WindmillSplashAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
    // print('onAdSourceStartLoading,adInfo:${adInfo?.toJson()}');
    // c.callbacks.add('onAdSourceStartLoading -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onAdSourceSuccess(WindmillSplashAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
    // print('onAdSourceSuccess,adInfo:${adInfo?.toJson()}');
    // c.callbacks.add('onAdSourceSuccess -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onBidAdSourceFailed(WindmillSplashAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onBidAdSourceFailed
    // print('onBidAdSourceFailed,adInfo:${adInfo?.toJson()}');
    // c.callbacks.add('onBidAdSourceFailed -- ${ad.request.placementId},adInfo:${adInfo?.toJson()},error: ${error.toJson()}');
  }
  
  @override
  void onBidAdSourceStart(WindmillSplashAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
    // print('onBidAdSourceStart,adInfo:${adInfo?.toJson()}');
    // c.callbacks.add('onBidAdSourceStart -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onBidAdSourceSuccess(WindmillSplashAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
    // print('onBidAdSourceSuccess,adInfo:${adInfo?.toJson()}');
    // c.callbacks.add('onBidAdSourceSuccess -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onAdAutoLoadFailed(WindmillSplashAd ad, WMError error) {
    // TODO: implement onAdAutoLoadFailed
    // c.callbacks.add('onAdAutoLoadFailed -- ${ad.request.placementId}, error：${error.toJson()}');
  }
  
  @override
  void onAdAutoLoadSuccess(WindmillSplashAd ad) {
    // TODO: implement onAdAutoLoadSuccess
    // c.callbacks.add('onAdAutoLoadSuccess -- ${ad.request.placementId}');
  }
}
