import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/NativeController.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';
import 'package:windmill_ad_plugin_example/widgets/adslot_widget.dart';

class NativePage extends StatelessWidget {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('原生广告'),
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
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
        ]))
      ],
    );
  }

  Widget _adWidget() {
    final c = Get.find<NativeController>();
    return Column(
        children: List.generate(c.adItems.length, (index) => c.adItems[index]));
  }

  Widget _logWidget() {
    final c = Get.find<NativeController>();
    return Column(
        children: List.generate(
            c.callbacks.length, (index) => Text('${c.callbacks[index]}')));
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if (c.adSetting.value.slotIds == null) return Center();
     WindmillAd.sceneExpose("native","flutter_native");
    return AdSlotWidget(
      c.adSetting.value.slotIds!
          .where((element) => element.adType == 5)
          .toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }
  void _adPlay(String placementId) async {
    final NativeController c = Get.find<NativeController>();

    WindmillNativeAd? ad = c.getWindmillNativeAd(placementId);
    if(ad == null) return;
    bool isReady = await ad.isReady();

    if(isReady){
      NativeAdWidget nativeAdWidget = NativeAdWidget(
        nativeAd: ad,
        height: 350,
        width: 300,
        nativeCustomViewConfig: {
                    CustomNativeAdConfig.rootView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                      300, 350,
                      x: 50,
                      y: 350,
                      backgroundColor: '#FFFFFF'
                    ),
                    CustomNativeAdConfig.iconView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                        50, 50,
                        x: 5, y: 210,),
                    CustomNativeAdConfig.titleView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                      200,
                      20,
                      x: 60,
                      y: 210,
                      fontSize: 15,
                    ),
                    CustomNativeAdConfig.descriptView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                        230, 20,
                        x: 60, y:230, fontSize: 15),
                    CustomNativeAdConfig.ctaButton(): CustomNativeAdConfig.createNativeSubViewAttribute(
                      100,
                      50,
                      x:60,
                      y: 265,
                      fontSize: 15,
                      textColor: "#000000",
                      backgroundColor: "#FFFFFF"
                    ),
                    CustomNativeAdConfig.mainAdView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                        290, 200,
                        x: 5, y: 5, backgroundColor: '#FFFFFF'),
                    CustomNativeAdConfig.adLogoView(): CustomNativeAdConfig.createNativeSubViewAttribute(
                        20, 20,
                        x: 10,
                        y: 10,
                        backgroundColor: '#FFFFFF'),
                    CustomNativeAdConfig.dislikeButton(): CustomNativeAdConfig.createNativeSubViewAttribute(
                      20,
                      20,
                      x:260,
                      y: 210,
                      textColor: "#FFFFFF",
                      backgroundColor: "#FFFFFF"
                    ),
              },
      );
      
      c.adItems.add(nativeAdWidget);
      c.update();
    }
  }

  void _adLoad(String placementId) {
    final c = Get.find<NativeController>();
    final adcontroller = Get.find<Controller>();

    WindmillNativeAd ad = c.getOrCreateWindmillNativeAd(placementId: placementId,userId:adcontroller.adSetting.value.otherSetting?.userId,size: Size(300, 350), listener: IWindmillNativeListener());

    ad.loadAd();
   
  }
}

class IWindmillNativeListener extends WindmillNativeListener<WindmillNativeAd> {
  final c = Get.find<NativeController>();

  @override
  void onAdFailedToLoad(WindmillNativeAd ad, WMError error) {
    print('onAdFailedToLoad');
    c.callbacks.add('onAdFailedToLoad -- ${ad.request.placementId} error: ${error.toJson()} ');
  }

  @override
  void onAdLoaded(WindmillNativeAd ad) {
    print('onAdLoaded');
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId}');
  }

  @override
  void onAdOpened(WindmillNativeAd ad) {
    print('onAdOpened');
    ad.getAdInfo().then((adinfo) => 
        c.callbacks.add('onAdOpened -- ${ad.request.placementId} --  adInfo -- ${ adinfo.toJson()}')
    );
  }

  @override
  void onAdRenderFail(WindmillNativeAd ad, WMError error) {
    print('onAdRenderFail');
    c.callbacks.add('onAdRenderFail -- ${ad.request.placementId} error: ${error.toJson()}');
  }

  @override
  void onAdRenderSuccess(WindmillNativeAd ad) {
    print('onAdRenderSuccess');

    NativeAdWidget widget = c.adItems.last;

    
    widget.updateAdSize(ad.adSize!);
    c.callbacks.add('onAdRenderSuccess -- ${ad.request.placementId}');
  }

  @override
  void onAdClicked(WindmillNativeAd ad) {
    print('onAdClicked');
    c.callbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewClosed(WindmillNativeAd ad) {
    print('onAdDetailViewClosed');
    c.callbacks.add('onAdDetailViewClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewOpened(WindmillNativeAd ad) {
    print('onAdDetailViewOpened');
    c.callbacks.add('onAdDetailViewOpened -- ${ad.request.placementId}');
  }

  @override
  void onAdDidDislike(WindmillNativeAd ad, String reason) {
    print('onAdDidDislike');
    c.callbacks.add('onAdDidDislike -- ${ad.request.placementId}');
    ad.destory();
    c.adItems.removeLast();
    c.update();

  }
  @override
  void onAdShowError(WindmillNativeAd ad,WMError error) {
    // TODO: implement onAdShowError
     print('onAdShowError');
    c.callbacks.add('onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }
}
