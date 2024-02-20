import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/InterstitialController.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import 'package:windmill_ad_plugin_example/widgets/adslot_widget.dart';

class IntersititialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('插屏广告'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final c = Get.find<IntersititialController>();
    return Column(
      children: [
        Container(
          child: Obx(() => _buildAdSlotWidget()),
        ),
        Expanded(
            child: Obx(() => ListView.builder(
                itemCount: c.callbacks.length,
                itemBuilder: (ctx, index) {
                  return Text(c.callbacks[index]);
                })))
      ],
    );
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if (c.adSetting.value.slotIds == null) return Center();
    WindmillAd.sceneExpose("Interstitial", "flutter_Interstitial");
    return AdSlotWidget(
      c.adSetting.value.slotIds!
          .where((element) => element.adType == 4)
          .toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }

  void _adLoad(String placementId) {
    final c = Get.find<IntersititialController>();
    final adcontroller = Get.find<Controller>();

    WindmillInterstitialAd ad = c.getOrCreateWindmillInterstitialAd(
        placementId: placementId,
        userId: adcontroller.adSetting.value.otherSetting?.userId,
        listener: IWindMillInterstitialListener());
    ad.loadAdData();
  }

  void _adPlay(String placementId) async {
    final c = Get.find<IntersititialController>();
    WindmillInterstitialAd? ad = c.getWindmillInterstitialAd(placementId);
    if (ad == null) return;
    bool isReady = await ad.isReady();
    if (isReady) {
      AdSetting? adSetting = await AdSetting.fromFile();

      Map<String, String>? map;
      if (adSetting != null) {
        map = {
          "AD_SCENE_ID": adSetting.otherSetting?.adSceneId ?? "",
          "AD_SCENE_DESC": adSetting.otherSetting?.adSceneDesc ?? ""
        };
      }
      ad.showAd(options: map);
    } else {
      print('ad is not ready!!!');
    }
  }
}

class IWindMillInterstitialListener
    extends WindmillInterstitialListener<WindmillInterstitialAd> {
  final c = Get.find<IntersititialController>();

  @override
  void onAdClicked(WindmillInterstitialAd ad) {
    print('onAdClicked -- ${ad.request.placementId}');
    c.callbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdClosed(WindmillInterstitialAd ad) {
    print('onAdClosed -- ${ad.request.placementId}');
    c.callbacks.add('onAdClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdFailedToLoad(WindmillInterstitialAd ad, WMError error) {
    print(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
    c.callbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
  }

  @override
  void onAdLoaded(WindmillInterstitialAd ad) {
    print('onAdLoaded -- ${ad.request.placementId}');
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId}');
    ad.getCacheAdInfoList().then((adinfos) => adinfos?.forEach((element) {
          c.callbacks.add(
              'onAdLoaded -- ${ad.request.placementId} -- adInfo -- ${element.toJson()}');
        }));
  }

  @override
  void onAdOpened(WindmillInterstitialAd ad) {
    print('onAdOpened -- ${ad.request.placementId}');
    ad.getAdInfo().then((adinfo) => c.callbacks.add(
        'onAdOpened -- ${ad.request.placementId} -- adInfo -- ${adinfo.toJson()}'));
  }

  @override
  void onAdSkiped(WindmillInterstitialAd ad) {
    print('onAdSkiped -- ${ad.request.placementId}');
    c.callbacks.add('onAdSkiped -- ${ad.request.placementId}');
  }

  @override
  void onAdVideoPlayFinished(WindmillInterstitialAd ad) {
    print('onAdVideoPlayFinished -- ${ad.request.placementId}');

    c.callbacks.add('onAdVideoPlayFinished -- ${ad.request.placementId}');
  }

  @override
  void onAdShowError(WindmillInterstitialAd ad, WMError error) {
    print('onAdShowError');
    c.callbacks.add(
        'onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }

  @override
  void onAdDidCloseOtherController(
      WindmillInterstitialAd ad, WindmillInteractionType interactionType) {
    print('onAdDidCloseOtherController');
    c.callbacks.add(
        'onAdDidCloseOtherController -- ${ad.request.placementId},interactionType: ${interactionType.toString()}');
  }
}
