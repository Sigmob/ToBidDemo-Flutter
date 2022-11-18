import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/SplashController.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';
import 'dart:ui';
import '../../controller/controller.dart';
import '../../widgets/adslot_widget.dart';

class SplashPage extends StatelessWidget {



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
      onPlay:_adPlay,
    );
  }

  void _adPlay(String placementId) async {
    final SplashController c = Get.find<SplashController>();

    WindmillSplashAd? ad = c.getWindmillSplashAd(placementId);
    if (ad == null) return;
    bool isReady = await ad.isReady();

    if (isReady) {
        ad.showAd();
    }
  }

  void _adLoad(String placementId) {
    final c = Get.find<SplashController>();

    Size size = Size(window.physicalSize.width, window.physicalSize.height);
    if(Platform.isIOS){
        size = Size(window.physicalSize.width/window.devicePixelRatio, window.physicalSize.height/window.devicePixelRatio);
    }
    WindmillSplashAd ad = c.getOrCreateWindmillSplashAd(
        placementId: placementId,
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
  }

  @override
  void onAdOpened(WindmillSplashAd ad) {
    print('flu-Splash --- onAdOpened');
    ad.getAdInfo().then((adinfo) => 
        c.callbacks.add('onAdOpened -- ${ad.request.placementId} -- adInfo -- ${ adinfo.toJson()}')
    );
  }


  
  @override
  void onAdShowError(WindmillSplashAd ad,WMError error) {

    print('flu-Splash --- onAdShowError');
    c.callbacks.add('onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }

  @override
  void onAdClosed(WindmillSplashAd ad) {
    // TODO: implement onAdClosed
    c.callbacks.add('onAdClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdSkiped(WindmillSplashAd ad) {
    // TODO: implement onAdSkiped
    c.callbacks.add('onAdSkiped -- ${ad.request.placementId}');

  }
}
