import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/NativeDrawController.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import 'package:windmill_ad_plugin_example/utils/device_util.dart';
import 'package:windmill_ad_plugin_example/widgets/adslot_widget.dart';

class NativeDrawPage extends StatelessWidget {
  int ad_show_count = 0;
  WindmillNativeAd? ad;

  @override
  Widget build(BuildContext context) {
    DeviceUtil.initialize();
    return Scaffold(
      body: _buildContent(context) );
  }

  Widget _buildContent(BuildContext context) {
    final c = Get.find<NativeDrawController>();

    return PageView.builder(
      itemCount: 10000,
      scrollDirection: Axis.vertical,
      controller: c.pageController,
      itemBuilder: (context, index) {
        if (!c.isLoaded) {
          c.isLoaded = true;
          c.isReady = false;
          _adLoad();
        }
        if (index % 2 == 0) {
          return Container(
            key: Key("${index}"),
            alignment: Alignment.center,
            width: DeviceUtil.screenWidth,
            height: DeviceUtil.screenHeight,
            child: Text("ToBid"),
          );
        } else {
          if (ad != null && c.isReady) {
            return Container(
              key: Key("${index}"),
              alignment: Alignment.center,
              width: DeviceUtil.screenWidth,
              height: DeviceUtil.screenHeight,
              child: _adWidget(),
            );
          }

          return Container(
            key: Key("${index}"),
            alignment: Alignment.center,
            width: DeviceUtil.screenWidth,
            height: DeviceUtil.screenHeight,
            child: Text("ToBid Ad 加载中"),
          );
        }
      },
    );
  }

  Widget _adWidget() {
    return NativeAdWidget(
      nativeAd: ad!,
      height: DeviceUtil.screenHeight,
      width: DeviceUtil.screenWidth,
      nativeCustomViewConfig: {
        CustomNativeAdConfig.rootView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
                DeviceUtil.screenWidth, DeviceUtil.screenHeight,
                x: 0, y: 0, backgroundColor: '#FFFFFF'),
        CustomNativeAdConfig.iconView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          50,
          50,
          x: 5,
          y: DeviceUtil.screenHeight - 130,
        ),
        CustomNativeAdConfig.titleView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          DeviceUtil.screenWidth - 60 - 40 - 10,
          20,
          x: 60,
          y: DeviceUtil.screenHeight - 130,
          fontSize: 15,
          textColor: "#FFFFFF",
        ),
        CustomNativeAdConfig.descriptView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          DeviceUtil.screenWidth - 60 - 40 - 10,
          30,
          x: 60,
          y: DeviceUtil.screenHeight - 110,
          fontSize: 15,
          textColor: "#FFFFFF",
        ),
        CustomNativeAdConfig.ctaButton():
            CustomNativeAdConfig.createNativeSubViewAttribute(
                DeviceUtil.screenWidth - 10, 50,
                x: 5,
                y: DeviceUtil.screenHeight - 70,
                fontSize: 15,
                textColor: "#FFFFFF",
                backgroundColor: "#2576F6"),
        CustomNativeAdConfig.mainAdView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
                DeviceUtil.screenWidth, DeviceUtil.screenHeight-70,
                x: 0, y: 20, backgroundColor: '#000000'),
        CustomNativeAdConfig.adLogoView():
            CustomNativeAdConfig.createNativeSubViewAttribute(20, 20,
                x: DeviceUtil.screenWidth - 40, y: DeviceUtil.screenHeight - 95),
        CustomNativeAdConfig.dislikeButton():
            CustomNativeAdConfig.createNativeSubViewAttribute(20, 20,
                x: DeviceUtil.screenWidth - 40,
                y: DeviceUtil.screenHeight - 130,
                backgroundColor: "#FFFFFF"),
      },
    );
  }

  void _adLoad() {
    final adcontroller = Get.find<NativeDrawController>();
    final c = Get.find<Controller>();
    SlotId slotId = c.adSetting.value.slotIds!
        .where((element) => element.adType == 5)
        .toList()
        .first;
    ad ??= adcontroller.getOrCreateWindmillNativeAd(
        placementId: slotId.adSlotId ?? "",
        userId: c.adSetting.value.otherSetting?.userId,
        size: Size(DeviceUtil.screenWidth, DeviceUtil.screenHeight),
        listener: IWindmillNativeListener());

    ad?.loadAd();
  }
}

class IWindmillNativeListener extends WindmillNativeListener<WindmillNativeAd> {
  final c = Get.find<NativeDrawController>();

  @override
  void onAdFailedToLoad(WindmillNativeAd ad, WMError error) {
    print('onAdFailedToLoad');

    c.isLoaded = false;
    c.callbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId} error: ${error.toJson()} ');
  }

  @override
  void onAdLoaded(WindmillNativeAd ad) {
    print('onAdLoaded');

    c.isReady = true;
    c.callbacks.add('onAdLoaded -- ${ad.request.placementId} }');
    ad.getCacheAdInfoList().then((adinfos) => adinfos?.forEach((element) {
          c.callbacks.add(
              'onAdLoaded -- ${ad.request.placementId} -- adInfo -- ${element.toJson()}');
        }));
  }

  @override
  void onAdOpened(WindmillNativeAd ad) {
    c.isLoaded = false;
    print('onAdOpened');
  }

  @override
  void onAdRenderFail(WindmillNativeAd ad, WMError error) {
    print('onAdRenderFail');
  }

  @override
  void onAdRenderSuccess(WindmillNativeAd ad) {
    print('onAdRenderSuccess');
  }

  @override
  void onAdClicked(WindmillNativeAd ad) {
    print('onAdClicked');
  }

  @override
  void onAdDetailViewClosed(WindmillNativeAd ad) {
    print('onAdDetailViewClosed');
  }

  @override
  void onAdDetailViewOpened(WindmillNativeAd ad) {
    print('onAdDetailViewOpened');
  }

  @override
  void onAdDidDislike(WindmillNativeAd ad, String reason) {
    print('onAdDidDislike');
    c.nextPage();
  }

  @override
  void onAdShowError(WindmillNativeAd ad, WMError error) {
    // TODO: implement onAdShowError
    print('onAdShowError');
  }
}
