import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/RwController.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import '../../controller/controller.dart';
import '../../widgets/adslot_widget.dart';

class RewardPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('激励视频广告'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final c = Get.find<RwController>();
    return Column(
      children: [
        Container(
          child: Obx(() => _buildAdSlotWidget()),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
              itemCount: c.rwCallbacks.length,
              itemBuilder: (ctx, index) {
                return Text(c.rwCallbacks[index]);
              }
          ))
        )
      ],
    );
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if(c.adSetting.value.slotIds == null) return Center();
         WindmillAd.sceneExpose("reward","flutter_reward");
    return AdSlotWidget(
      c.adSetting.value.slotIds!.where((element) => element.adType == 1).toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }

  void _adLoad(String placementId) {
    final c = Get.find<RwController>();
    final adcontroller = Get.find<Controller>();

    WindmillRewardAd ad = c.getOrCreateWindmillRewardAd(placementId: placementId,userId: adcontroller.adSetting.value.otherSetting?.userId, listener: IWindMillRewardListener());
    ad.loadAdData();
  }

  void _adPlay(String placementId) async{
    final c = Get.find<RwController>();
    WindmillRewardAd? ad = c.getWindmillRewardAd(placementId);
    if(ad == null) return;
    bool isReady = await ad.isReady();
    if (isReady) {
      AdSetting? adSetting = await AdSetting.fromFile();
      Map<String,String>? map;   
     if(adSetting != null){
       map = {"AD_SCENE_ID":adSetting.otherSetting?.adSceneId??"","AD_SCENE_DESC":adSetting.otherSetting?.adSceneDesc??""};
     }
    ad.showAd(options: map);
    }else {
      print('ad is not ready!!!');
    }
  }
}

class IWindMillRewardListener extends WindmillRewardListener<WindmillRewardAd> {

  final c = Get.find<RwController>();

  @override
  void onAdClicked(WindmillRewardAd ad) {
      print('onAdClicked -- ${ad.request.placementId}');
      c.rwCallbacks.add('onAdClicked -- ${ad.request.placementId}');
  }

  @override
  void onAdClosed(WindmillRewardAd ad) {
    print('onAdClosed -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdClosed -- ${ad.request.placementId}');
  }

  @override
  void onAdFailedToLoad(WindmillRewardAd ad, WMError error) {
    print('onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
    c.rwCallbacks.add('onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
  }

  @override
  void onAdLoaded(WindmillRewardAd ad) {
    print('onAdLoaded -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdLoaded -- ${ad.request.placementId}');
  }

  @override
  void onAdOpened(WindmillRewardAd ad) {
    print('onAdOpened -- ${ad.request.placementId}');
     ad.getAdInfo().then((adinfo) => 
        c.rwCallbacks.add('onAdOpened -- ${ad.request.placementId} -- adInfo -- ${ adinfo.toJson()}')
    );
  }

  @override
  void onAdReward(WindmillRewardAd ad, RewardInfo rewardInfo) {
    print('onAdReward -- ${ad.request.placementId} -- IsReward -- ${rewardInfo.isReward} --- TransId -- ${rewardInfo.transId} -- UserId -- ${rewardInfo.userId} ');
    c.rwCallbacks.add('onAdReward -- ${ad.request.placementId} -- IsReward -- ${rewardInfo.isReward} --- TransId -- ${rewardInfo.transId} -- UserId -- ${rewardInfo.userId} ');
  }

  @override
  void onAdSkiped(WindmillRewardAd ad) {
    print('onAdSkiped -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdSkiped -- ${ad.request.placementId}');
  }

  @override
  void onAdVideoPlayFinished(WindmillRewardAd ad, WMError? error) {
    print('onAdVideoPlayFinished -- ${ad.request.placementId}, error: ${error == null ? "null" : error.toJson()}');
    c.rwCallbacks.add('onAdVideoPlayFinished -- ${ad.request.placementId}, error: ${error == null ? "null" : error.toJson()}');
  }

  @override
  void onAdShowError(WindmillRewardAd ad,WMError error) {
    // TODO: implement onAdShowError
     print('onAdShowError');
    c.rwCallbacks.add('onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }

}

