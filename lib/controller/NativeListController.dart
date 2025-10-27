import 'dart:ui';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';

class NativeInfo {
  int type = 0;
  WindmillNativeAd? nativeAd;
  NativeAdWidget? widget;
  String? message;
}

class NativeListController extends GetxController {
  var datas = <NativeInfo>[].obs;
  var notifyFinished = false.obs;

  WindmillNativeAd createWindmillNativeAd(
      {required String placementId,
      String? userId,
      required Size size,
      required WindmillNativeListener<WindmillNativeAd> listener}) {
    AdRequest request = AdRequest(placementId: placementId, userId: userId);
    WindmillNativeAd nativeAd = WindmillNativeAd(
      request: request,
      listener: listener,
      width: size.width,
      height: size.height,
    );
    return nativeAd;
  }

  generateFakeDatas() {
    for (var i = 0; i < 10; i++) {
      var data = new NativeInfo();
      data.type = 1;
      data.message = '假数据 random.value = ${math.Random().nextDouble()}';
      this.datas.add(data);
    }
  }

  // 加载原生广告load
  Future<void> adLoad(String placementId, Size size) async {
    print('codi -- adLoad: ${placementId} - ${size}}');
    final c = Get.find<NativeListController>();
    final adcontroller = Get.find<Controller>();

    WindmillNativeAd ad = createWindmillNativeAd(
        placementId: placementId,
        userId: adcontroller.adSetting.value.otherSetting?.userId,
        size: Size(size.width, size.height),
        listener: WindMillNativeListener());
    ad.loadAd();
  }

  // 通知并展示原生广告
  void adPlay(WindmillNativeAd ad, Size size) async {
    print('codi -- adPlay: ${ad.request.placementId} - ${size}}');
    var data = new NativeInfo();
    data.nativeAd = ad;
    data.type = 2;
    data.widget = NativeAdWidget(
      nativeAd: ad,
      height: size.height,
      width: size.width,
      nativeCustomViewConfig: {
        CustomNativeAdConfig.rootView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
                size.width, size.height,
                x: 50, y: 350, backgroundColor: '#FFFFFF'),
        CustomNativeAdConfig.iconView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          50,
          50,
          x: 5,
          y: 210,
        ),
        CustomNativeAdConfig.titleView():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          200,
          20,
          x: 60,
          y: 210,
          fontSize: 15,
        ),
        CustomNativeAdConfig.descriptView():
            CustomNativeAdConfig.createNativeSubViewAttribute(230, 20,
                x: 60, y: 230, fontSize: 15),
        CustomNativeAdConfig.ctaButton():
            CustomNativeAdConfig.createNativeSubViewAttribute(size.width, 50,
                x: 0,
                y: 265,
                fontSize: 15,
                textColor: "#FFFFFF",
                backgroundColor: "#2576F6"),
        CustomNativeAdConfig.mainAdView():
            CustomNativeAdConfig.createNativeSubViewAttribute(290, 200,
                x: 5, y: 5, backgroundColor: '#FFFFFF'),
        CustomNativeAdConfig.adLogoView():
            CustomNativeAdConfig.createNativeSubViewAttribute(20, 20,
                x: 270, y: 180),
        CustomNativeAdConfig.dislikeButton():
            CustomNativeAdConfig.createNativeSubViewAttribute(
          20,
          20,
          x: 260,
          y: 210,
        ),
      },
    );
    this.datas.add(data);
  }
}

// 原生广告监听类
class WindMillNativeListener extends WindmillNativeListener<WindmillNativeAd> {
  final NativeListController c = Get.find();

  @override
  void onAdFailedToLoad(WindmillNativeAd ad, WMError error) {
    print('onAdRenderFail -- ${ad.request.placementId} error: ${error.toJson()}');
    c.notifyFinished.value = !c.notifyFinished.value;
  }

  @override
  void onAdLoaded(WindmillNativeAd ad, WindMillNativeInfo? nativeInfo) {
    print('codi -- onAdLoaded: ${ad.request.placementId} nativeInfo: ${nativeInfo?.toJson()}');
    c.adPlay(ad, Size(ad.width, ad.height));
    c.notifyFinished.value = !c.notifyFinished.value;

    ad.getCacheAdInfoList().then((adinfos) => adinfos?.forEach((element) {
          print(
              'codi -- onAdLoaded -- : ${ad.request.placementId} -- adInfo -- ${element.toJson()}');
        }));
  }

  @override
  void onAdOpened(WindmillNativeAd ad) {
    print('codi -- onAdOpened: ${ad.request.placementId}');
  }

  @override
  void onAdRenderFail(WindmillNativeAd ad, WMError error) {
    print('codi -- onAdRenderFail: ${ad.request.placementId}');
  }

  @override
  void onAdRenderSuccess(WindmillNativeAd ad) {
    print('codi -- onAdRenderSuccess: ${ad.request.placementId}');
    c.datas.forEach((element) {
      if (element.nativeAd != null &&
          element.widget != null &&
          element.nativeAd == ad &&
          ad.adSize != null) {
        print('codi -- onAdRenderSuccess update: ${ad.adSize}');
        element.widget!.updateAdSize(ad.adSize!);
      }
    });
  }

  @override
  void onAdClicked(WindmillNativeAd ad) {
    print('codi -- onAdClicked: ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewClosed(WindmillNativeAd ad) {
    print('codi -- onAdDetailViewClosed: ${ad.request.placementId}');
  }

  @override
  void onAdDetailViewOpened(WindmillNativeAd ad) {
    print('codi -- onAdDetailViewOpened: ${ad.request.placementId}');
  }

  @override
  void onAdDidDislike(WindmillNativeAd ad, String reason) {
    print('codi -- onAdDidDislike: ${ad.request.placementId}');
    ad.destroy();
    c.datas.removeWhere((element) =>(element.nativeAd != null &&
          element.widget != null &&
          element.nativeAd == ad &&
          ad.adSize != null));
  }

  @override
  void onAdShowError(WindmillNativeAd ad, WMError error) {
    print('codi -- onAdShowError: ${ad.request.placementId}');
  }
  
  @override
  void onAdSourceFailed(WindmillNativeAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onAdSourceFailed
  }
  
  @override
  void onAdSourceStartLoading(WindmillNativeAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
  }
  
  @override
  void onAdSourceSuccess(WindmillNativeAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
  }
  
  @override
  void onBidAdSourceFailed(WindmillNativeAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onBidAdSourceFailed
  }
  
  @override
  void onBidAdSourceStart(WindmillNativeAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
  }
  
  @override
  void onBidAdSourceSuccess(WindmillNativeAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
  }
  
  @override
  void onAdAutoLoadFailed(WindmillNativeAd ad, WMError error) {
    // TODO: implement onAdAutoLoadFailed
  }
  
  @override
  void onAdAutoLoadSuccess(WindmillNativeAd ad) {
    // TODO: implement onAdAutoLoadSuccess
  }
}
