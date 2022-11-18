import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';
import 'package:windmill_ad_plugin_example/router/index.dart';

class HomePage extends StatelessWidget {
  final List _items = [
    {'icon': Icons.play_circle_outline_outlined, 'title': '开屏广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '横幅广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '激励视频广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '插屏广告'},
    {'icon': Icons.play_circle_outline_outlined, 'title': '原生广告'},
  ];

  void _initSDK() async {
    AdSetting? adSetting = await AdSetting.fromFile();
    if (adSetting != null) {
       WindmillAd.adult(adSetting.otherSetting!.adultState == 0? Adult.adult:Adult.children);

       WindmillAd.setUserId(adSetting.otherSetting!.userId);


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


       WindmillAd.age( adSetting.otherSetting!.age);


      await WindmillAd.init(adSetting.appId!.toString());
      
    
    }

    print("sdkVersion: ${await WindmillAd.sdkVersion()}");
  }

  @override
  Widget build(BuildContext context) {
    _initSDK();
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
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
        style: TextStyle(fontSize: 18),
      ),
      trailing: null,
      onTap: () => _itemOnTap(index),
    );
  }

  Widget _separatorBuilder(BuildContext ctx, int index) {
    return Divider(
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
    }
  }
}
