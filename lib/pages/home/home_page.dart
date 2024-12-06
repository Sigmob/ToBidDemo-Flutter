import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import 'package:windmill_ad_plugin_example/router/index.dart';
import 'package:windmill_ad_plugin_example/utils/device_util.dart';

class HomePage extends StatelessWidget {
  final List _items = [
    {'icon': Icons.play_circle_outline_outlined, 'title': '开屏广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '横幅广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '激励视频广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '插屏广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '原生广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '原生list广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '原生draw广告'},
    // {'icon': Icons.play_circle_outline_outlined, 'title': '添加过滤'},
    // {'icon': Icons.play_circle_outline_outlined, 'title': '移除过滤 - 8618177000518077'},
    // {'icon': Icons.play_circle_outline_outlined, 'title': '移除过滤'},
  ];

   HomePage({Key? key}) : super(key: key);

  void _initSDK() async {
    DeviceUtil.initialize();
    AdSetting? adSetting = await AdSetting.fromFile();
    if (adSetting != null) {

       WindmillAd.requestPermission(); 

       WindmillAd.adult(adSetting.otherSetting!.adultState == 0? Adult.adult:Adult.children);

       WindmillAd.setUserId(adSetting.otherSetting!.userId);

       List<WindmillNetworkInfo> infolist = <WindmillNetworkInfo>[];
        
      
      //  var sigAppId = Platform.isIOS?"21193":"1282";
      //  var groAppId = Platform.isIOS?"5002048":"5002970";
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Mintegral,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Vungle,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Applovin,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.UnityAds,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Ironsource,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Admob,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.GroMore,appId: groAppId,appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Sigmob,appId: sigAppId,appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.KuaiShou,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Klevin,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Baidu,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Adscope,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Qumeng,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.TapTap,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Pangle,appId: "",appKey: ""));
      // infolist.add(WindmillNetworkInfo(networkId: WindmillNetworkId.Pangle,appId: "",appKey: ""));

       WindmillAd.networkPreInit(infolist);


       var path = Platform.isIOS? "localstrategy":"localStrategy";
       WindmillAd.setPresetLocalStrategyPath(path);
       WindmillAd.personalizedAdvertisin(adSetting.otherSetting!.personalizedAdvertisingState == 0? Personalized.on:Personalized.off);

      switch (adSetting.otherSetting!.gdprIndex) {
          case 0:
                 WindmillAd.gdpr( GDPR.unknow);
          break;
          case 1:
                 WindmillAd.gdpr( GDPR.accepted);
          break;
          case 2:
                 WindmillAd.gdpr( GDPR.denied);
          break;

        default:
      } 

      switch (adSetting.otherSetting!.coppaIndex) {
        case 0:
            WindmillAd.coppa(COPPA.unknow);
 
          break;
            case 1:
            WindmillAd.coppa(COPPA.accepted);
          break;
          case 2:
            WindmillAd.coppa(COPPA.denied);
          break;
        default:
      }

       var locationStr = adSetting.otherSetting?.customLocation;
       var location;
       if(locationStr != null){

          var list = locationStr.split(',');
          if(list.length == 2){
             location = Location(longitude: double.parse(list[0]),latitude:double.parse(list[1]));
          }
       }

      var customDevice = CustomDevice(
      isCanUseAndroidId: adSetting.otherSetting?.isCanUseAndroidId,
      isCanUseIdfa: adSetting.otherSetting?.isCanUseIdfa,
      isCanUseLocation: adSetting.otherSetting?.isCanUseLocation,
      isCanUsePhoneState: adSetting.otherSetting?.isCanUsePhoneState,
      isCanUseAppList: adSetting.otherSetting?.isCanUseAppList,
      isCanUseWifiState: adSetting.otherSetting?.isCanUseWifiState,
      isCanUseWriteExternal: adSetting.otherSetting?.isCanUseWriteExternal,
      isCanUsePermissionRecordAudio: adSetting.otherSetting?.isCanUsePermissionRecordAudio,
      customMacAddress: adSetting.otherSetting?.customMacAddress,
      customAndroidId: adSetting.otherSetting?.customAndroidId,
      customIDFA: adSetting.otherSetting?.customIDFA,
      customIMEI: adSetting.otherSetting?.customIMEI,
      customOAID: adSetting.otherSetting?.customOAID,
      customLocation: location);
      WindmillAd.setCustomDevice(customDevice);

      WindmillAd.age( adSetting.otherSetting!.age);

      var customGroupStr = adSetting.otherSetting?.customGroup;
      Map customGroup = {};
      if(customGroupStr != null){

         var list = customGroupStr.split(',');
         for (var custom in list) {
            var group = custom.split('-');
            if(group.length == 2){
             customGroup[group[0]]= group[1];
            }
         }
      }
      var placementId = Platform.isIOS?"9966371082635223":"7373760992206247";
      WindmillAd.initCustomGroup(customGroup);
      Map customGroup2 = {};
      customGroup2["qa"] = "test";
      WindmillAd.initCustomGroupForPlacement(customGroup2,placementId);

      WindmillAd.setSupportMultiProcess(true);
      WindmillAd.setWxOpenAppIdAndUniversalLink("wxdb34fba95bb9c942","https://8car0x2emn.1rtb.com/mssdkdemo/");
      WindmillAd.setDebugEnable(true);
      
      await WindmillAd.init(adSetting.appId!.toString());
      
    
    }

    print("sdkVersion: ${await WindmillAd.sdkVersion()}");
  }

  @override
  Widget build(BuildContext context) {
    _initSDK();
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: ListView.separated(
          itemBuilder: _itemBuilder,
          separatorBuilder: _separatorBuilder,
          itemCount: _items.length),
    );
  }

  Widget _itemBuilder(BuildContext ctx, int index) {
    return ListTile(
      leading: Icon(_items[index]['icon'], size: 30, color: Colors.redAccent),
      title: Text(
        _items[index]['title'],
        style: const TextStyle(fontSize: 18),
      ),
      trailing: null,
      onTap: () => _itemOnTap(index),
    );
  }

  Widget _separatorBuilder(BuildContext ctx, int index) {
    return const Divider(
      indent: 20,
    );
  }

  void _itemOnTap(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.SPLASH);
        break;
      case 1:
        Get.toNamed(Routes.BANNER);
        break;
      case 2:
        Get.toNamed(Routes.REWARD);
        break;
      case 3:
        Get.toNamed(Routes.INTERSITITIAL);
        break;
      case 4:
        Get.toNamed(Routes.NATIVE);
        break;
      case 5:
        Get.toNamed(Routes.NATIVE_LIST);
        break;
      case 6:
        Get.toNamed(Routes.NATIVE_DRAW);
        break;
      case 7:
      _addFilterTest();
      break;
      case 8:
      _removFilterTest('8618177000518077');
      break;
      case 9:
      _removeAllFilter();
      break;
    }
  }

  void _addFilterTest() {
    List<WindMillFilterModel> list = <WindMillFilterModel>[];
    list.add(
       WindMillFilterModel(
        channelIdList: [WindmillNetworkId.Sigmob],
      )
    );
     WindmillAd.addWaterfallFilter('7494199205693422', list);
     
    List<WindMillFilterModel> list1 = <WindMillFilterModel>[];
     list1.add(
       WindMillFilterModel(
        bidTypeList: [WindMillBidType.c2s],
      )
    );
    WindmillAd.addWaterfallFilter('8618177000518077', list1);

     List<WindMillFilterModel> list2 = <WindMillFilterModel>[];
    list2.add(
      WindMillFilterModel(
        ecpmList: [
          WindMillFilterEcpmModel(
            operatorType: OperatorType.greaterThan,
            ecpm: 100
          )
        ]
      )
    );
    WindmillAd.addWaterfallFilter('9832515539413140', list2);
  }

  void _removFilterTest(String placementId) {
    WindmillAd.removeFilterWithPlacementId(placementId);
  }

  void _removeAllFilter() {
    WindmillAd.removeFilter();
  }
}
