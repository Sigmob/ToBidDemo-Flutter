import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/BannerController.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';

import '../../controller/controller.dart';
import '../../widgets/adslot_widget.dart';

class BannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("banner_page --- build");
    return Scaffold(
        appBar: AppBar(
          title: const Text('横幅广告'),
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
            Obx(() => _adWidget()),
            Obx(() => _logWidget()),
          ]),
        ),
      ],
    );
  }

  Widget _adWidget() {
    final c = Get.find<BannerController>();
    return Column(
        children: List.generate(c.adItems.length, (index) => c.adItems[index]));
  }

  Widget _logWidget() {
    final c = Get.find<BannerController>();
    return Column(
        children: List.generate(
            c.callbacks.length, (index) => Text('${c.callbacks[index]}')));
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if (c.adSetting.value.slotIds == null) return Center();

     WindmillAd.sceneExpose("banner","flutter_banner");

    return AdSlotWidget(
      c.adSetting.value.slotIds!
          .where((element) => element.adType == 7)
          .toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }


  void _adPlay(String placementId) async {
    final BannerController c = Get.find<BannerController>();

    WindmillBannerAd? ad = c.getWindmillBannerAd(placementId);
    if(ad == null) return;
    bool isReady = await ad.isReady();

    if(isReady){

      double height = 50;
      double width = 320;

      if(ad.adSize!.width >0){
        width = ad.adSize!.width;
        height = ad.adSize!.height;
      }
      BannerAdWidget bannerAdWidget = BannerAdWidget(
        windmillBannerAd: ad,
        height: height,
        width: width,
      );
      c.adItems.add(bannerAdWidget);
      c.update();
    }
  }
  void _adLoad(String placementId) {
    final BannerController c = Get.find<BannerController>();

    WindmillBannerAd ad = c.getOrCreateWindmillBannerAd(placementId: placementId, listener: IWindmillBannerListener());

    ad.loadAd();
  }
}

class IWindmillBannerListener extends WindmillBannerListener<WindmillBannerAd> {
  final BannerController c = Get.find();

  @override
  void onAdAutoRefreshFail(WindmillBannerAd ad, WMError error) {
    print('flu-banner --- onAdAutoRefreshFail');
    c.callbacks.add('onAdAutoRefreshFail -- ${ad.request.placementId}');
  }

  @override
  void onAdAutoRefreshed(WindmillBannerAd ad) {
    print('flu-banner --- onAdAutoRefreshed');
    final BannerController c = Get.find();
    c.callbacks.add('onAdAutoRefreshed -- ${ad.request.placementId}');
  }

  @override
  void onAdClicked(WindmillBannerAd ad) {
    print('flu-banner --- onAdClicked');
    c.callbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdFailedToLoad(WindmillBannerAd ad, WMError error) {
    print('flu-banner --- onAdFailedToLoad -- ${error.toJson()}');
    c.callbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
  }

  @override
  void onAdLoaded(WindmillBannerAd ad) {
    print('flu-banner --- onAdLoaded');
    
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId}');
  }

  @override
  void onAdOpened(WindmillBannerAd ad) {
    print('flu-banner --- onAdOpened');
    ad.getAdInfo().then((adinfo) => 
        c.callbacks.add('onAdOpened -- ${ad.request.placementId} -- adInfo -- ${ adinfo.toJson()}')
    );
  }

  @override
  void onAdClosed(WindmillBannerAd ad) {
    print('flu-banner --- onAdClosed');
    c.adItems.removeLast();
    c.callbacks.add('onAdClosed -- ${ad.request.placementId}');
  }
  
  @override
  void onAdShowError(WindmillBannerAd ad,WMError error) {
    // TODO: implement onAdShowError
      print('flu-banner --- onAdShowError');
    c.callbacks.add('onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }
}
