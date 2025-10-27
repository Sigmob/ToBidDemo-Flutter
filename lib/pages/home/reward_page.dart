import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/RwController.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import 'package:windmill_ad_plugin_example/utils/Utils.dart';
import '../../controller/controller.dart';
import '../../widgets/adslot_widget.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('激励视频广告'),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
          child: const Text("清除日志", style: TextStyle(fontSize: 13),),
          onPressed: _cleanCallback),
    );
  }
  void _cleanCallback() {
    final RwController c = Get.find<RwController>();
    c.rwCallbacks.clear();
  }

  Widget _buildBody(BuildContext context) {
    final c = Get.find<RwController>();
    // return Column(
    //   children: [
    //     Container(
    //       child: Obx(() => _buildAdSlotWidget()),
    //     ),
    //     Expanded(
    //         child: Obx(() => ListView.builder(
    //             itemCount: c.rwCallbacks.length,
    //             itemBuilder: (ctx, index) {
    //               return Text(c.rwCallbacks[index]);
    //             })))
    //   ],
    // );
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Obx(() => _buildAdSlotWidget()),
        ),
        SliverToBoxAdapter(
          child: Obx(() => ListView.builder(
                itemCount: c.rwCallbacks.length,
                itemBuilder: (ctx, index) {
                  return Text(c.rwCallbacks[index]);
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
               ),
             ),
        )
      ],
    );
  }

  Widget _buildAdSlotWidget() {
    final Controller c = Get.find();
    if (c.adSetting.value.slotIds == null) return const Center();
    WindmillAd.sceneExpose("reward", "flutter_reward");
    return AdSlotWidget(
      c.adSetting.value.slotIds!
          .where((element) => element.adType == 1)
          .toList(),
      onLoad: _adLoad,
      onPlay: _adPlay,
    );
  }

  void _adLoad(String placementId) {
    final c = Get.find<RwController>();
    final adcontroller = Get.find<Controller>();

    // List<String> networkFirmIdList = ["16"];
    // WindmillAd.setFilterNetworkFirmIdList(placementId, networkFirmIdList);

    //ios
    // List<WindmillFilterInfo> filterInfoList = <WindmillFilterInfo>[];
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.KuaiShou));
    // filterInfoList.add(WindmillFilterInfo(unitIdList: ["8150227349885070","951339662"]));
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.GDT,unitIdList: ["8150227349885070"]));
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.CSJ,unitIdList: ["951339662"]));
    // WindmillAd.addFilter(placementId, filterInfoList);

    //android
    // List<WindmillFilterInfo> filterInfoList = <WindmillFilterInfo>[];
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.KuaiShou));
    // filterInfoList.add(WindmillFilterInfo(unitIdList: ["5081642918611034","952881546"]));
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.GDT,unitIdList: ["5081642918611034"]));
    // filterInfoList.add(WindmillFilterInfo(networkId: WindmillNetworkId.CSJ,unitIdList: ["952881546"]));
    // WindmillAd.addFilter(placementId, filterInfoList);


    /*
    下面构造了过滤表达式例子的含义为:
          *1、针对聚合广告位id:88888888 过滤gdt渠道下的广告位id:123
          *2、针对聚合广告位id:88888888 过滤ks渠道下的广告位id集合:123、456、789
          *3、针对聚合广告位id:88888888 过滤渠道gdt、csj、ks、baidu
          *4、针对聚合广告位id:88888888 过滤普通广告源竞价类型
          *5、针对聚合广告位id:88888888 过滤服务端广告源竞价类型
          *6、针对聚合广告位id:88888888 过滤客户端广告源竞价类型
          *7、针对聚合广告位id:88888888 过滤价格 >=1200
          *8、针对聚合广告位id:88888888 过滤价格 <=3000
          */
    List<WindMillFilterModel> list = <WindMillFilterModel>[];
    list.add
    (WindMillFilterModel(
      channelIdList: [WindmillNetworkId.GDT], 
      adnIdList: ["123"],
      )
    );
    list.add(
      WindMillFilterModel(
        channelIdList: [WindmillNetworkId.KuaiShou],
        adnIdList: ["123", "456", "789"],
      )
    );
    list.add(
      WindMillFilterModel(
        channelIdList: [WindmillNetworkId.GDT, WindmillNetworkId.CSJ, WindmillNetworkId.KuaiShou, WindmillNetworkId.Baidu],
      )
    );
    list.add(
      WindMillFilterModel(
        bidTypeList: [WindMillBidType.c2s, WindMillBidType.s2s, WindMillBidType.normal],
      )
    );
    list.add(
      WindMillFilterModel(
        ecpmList: [
          WindMillFilterEcpmModel(
            operatorType: OperatorType.greaterThanOrEqual,
            ecpm: 1200
          ),
          WindMillFilterEcpmModel(
            operatorType: OperatorType.lessThanOrEqual,
            ecpm: 3000
          )
        ]
      )
    );
    // WindmillAd.addWaterfallFilter(placementId, list);
     list = adcontroller.adSetting.value.filterModelList ?? [];
    //  WindmillAd.addWaterfallFilter(placementId, list);
    
    // WindmillAd.removeFilter();
    // WindmillAd.removeFilterWithPlacementId(placementId);

    WindmillRewardAd ad = c.getOrCreateWindmillRewardAd(
        placementId: placementId,
        userId: adcontroller.adSetting.value.otherSetting?.userId,
        listener: IWindMillRewardListener());
    ad.setCustomGroup({"customKey":"customValue"});
    ad.addFilter(list);
    ad.loadAdData();
  }

  void _adPlay(String placementId) async {
    final c = Get.find<RwController>();

    // List<String> networkFirmIdList=["16"];
    // WindmillAd.setFilterNetworkFirmIdList(placementId, networkFirmIdList);

    WindmillRewardAd? ad = c.getWindmillRewardAd(placementId);
    if (ad == null) {
      Utils.showToast('无广告数据');
      return;
    }
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
      print(map);
      ad.showAd(options: map);
    } else {
      print('ad is not ready!!!');
       Utils.showToast('广告已过期');
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
    print(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
    c.rwCallbacks.add(
        'onAdFailedToLoad -- ${ad.request.placementId}, error: ${error.toJson()}');
  }

  @override
  void onAdLoaded(WindmillRewardAd ad) {
    print('onAdLoaded -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdLoaded -- ${ad.request.placementId}');
    ad.getCacheAdInfoList().then((adinfos) => adinfos?.forEach((element) {
          c.rwCallbacks.add(
              'onAdLoaded -- ${ad.request.placementId} -- adInfo -- ${element.toJson()}');
        }));
  }

  @override
  void onAdOpened(WindmillRewardAd ad) {
    print('onAdOpened -- ${ad.request.placementId}');

    ad.getAdInfo().then((adinfo) => c.rwCallbacks.add(
        'onAdOpened -- ${ad.request.placementId} -- adInfo -- ${adinfo.toJson()}'));
    // ad.loadAdData();
  }

  @override
  void onAdReward(WindmillRewardAd ad, RewardInfo rewardInfo) {
    var customdata = rewardInfo.customData ?? "";
    print(
        'onAdReward -- ${ad.request.placementId} -- IsReward -- ${rewardInfo.isReward} --- TransId -- ${rewardInfo.transId} -- UserId -- ${rewardInfo.userId} -- customData -- ${customdata}');
    c.rwCallbacks.add(
        'onAdReward -- ${ad.request.placementId} -- IsReward -- ${rewardInfo.isReward} --- TransId -- ${rewardInfo.transId} -- UserId -- ${rewardInfo.userId} -- customData -- ${customdata}');
  }

  @override
  void onAdSkiped(WindmillRewardAd ad) {
    print('onAdSkiped -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdSkiped -- ${ad.request.placementId}');
  }

  @override
  void onAdVideoPlayFinished(WindmillRewardAd ad) {
    print('onAdVideoPlayFinished -- ${ad.request.placementId}');
    c.rwCallbacks.add('onAdVideoPlayFinished -- ${ad.request.placementId}');
  }

  @override
  void onAdShowError(WindmillRewardAd ad, WMError error) {
    // TODO: implement onAdShowError
    print('onAdShowError');
    c.rwCallbacks.add(
        'onAdShowError -- ${ad.request.placementId},error: ${error.toJson()}');
  }
  @override
  void onAdAutoLoadSuccess(WindmillRewardAd ad) {
    // TODO: implement onAdAutoLoadSuccess
    print('onAdAutoLoadSuccess');
    c.rwCallbacks.add('onAdAutoLoadSuccess -- ${ad.request.placementId}');
  }
  @override
  void onAdAutoLoadFailed(WindmillRewardAd ad, WMError error) {
    // TODO: implement onAdAutoLoadFailed
    print('onAdAutoLoadFailed');
    c.rwCallbacks.add(
        'onAdAutoLoadFailed -- ${ad.request.placementId},error: ${error.toJson()}');
  }

  @override
  void onAdSourceFailed(WindmillRewardAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onAdSourceFailed
    print('onAdSourceFailed');
    // c.rwCallbacks.add('onAdSourceFailed -- ${ad.request.placementId},adInfo:${adInfo?.toJson()},error: ${error.toJson()}');
  }
  
  @override
  void onAdSourceStartLoading(WindmillRewardAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceStartLoading
    print('onAdSourceStartLoading,adInfo:${adInfo?.toJson()}');
    // c.rwCallbacks.add('onAdSourceStartLoading -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onAdSourceSuccess(WindmillRewardAd ad, AdInfo? adInfo) {
    // TODO: implement onAdSourceSuccess
    print('onAdSourceSuccess,adInfo:${adInfo?.toJson()}');
    // c.rwCallbacks.add('onAdSourceSuccess -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onBidAdSourceFailed(WindmillRewardAd ad, AdInfo? adInfo, WMError error) {
    // TODO: implement onBidAdSourceFailed
    print('onBidAdSourceFailed,adInfo:${adInfo?.toJson()}');
    // c.rwCallbacks.add('onBidAdSourceFailed -- ${ad.request.placementId},adInfo:${adInfo?.toJson()},error: ${error.toJson()}');
  }
  
  @override
  void onBidAdSourceStart(WindmillRewardAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceStart
    print('onBidAdSourceStart,adInfo:${adInfo?.toJson()}');
    // c.rwCallbacks.add('onBidAdSourceStart -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
  
  @override
  void onBidAdSourceSuccess(WindmillRewardAd ad, AdInfo? adInfo) {
    // TODO: implement onBidAdSourceSuccess
    print('onBidAdSourceSuccess,adInfo:${adInfo?.toJson()}');
    // c.rwCallbacks.add('onBidAdSourceSuccess -- ${ad.request.placementId},adInfo:${adInfo?.toJson()}');
  }
}
