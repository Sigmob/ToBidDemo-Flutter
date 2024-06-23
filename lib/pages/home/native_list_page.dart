import 'dart:async';
import 'dart:math' as math;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/extension/num_extension.dart';
import 'package:windmill_ad_plugin_example/pages/home/native_ad_service.dart';
import 'package:windmill_ad_plugin_example/utils/device_util.dart';

class NativeListPage extends StatefulWidget {
  const NativeListPage({Key? key}) : super(key: key);

  @override
  State<NativeListPage> createState() => _NativeListPage();
}

class _NativeListPage extends State<NativeListPage> {
  int ad_show_count = 0;

  final service = Get.find<NativeAdService>();

  @override
  void initState() {
    super.initState();

    service.generateFakeDatas();

    service.adLoad(
        "7547245474827569", Size(MediaQuery.of(context).size.width, 200));

    service.adLoad(
        "3328854952462696", Size(MediaQuery.of(context).size.width, 200));

    Future.delayed(Duration(seconds: 10), () {
      return service.adLoad(
          "5225613544461947", Size(MediaQuery.of(context).size.width, 0));
    });

    // service.adLoad(
    //     "2873998415684324", Size(MediaQuery.of(context).size.width, 200));

    // service.adLoad(
    //     "5225613544461947", Size(MediaQuery.of(context).size.width, 200));

    ///忽略1秒内的所有变化。
    interval(
        service.notify,
        (_) => {
              setState(() {
                print('codi -3- setState');
              })
            },
        time: Duration(seconds: 1));

    // Timer(Duration(seconds: 7), () {
    //   setState(() {
    //     print('codi -3- setState');
    //   });
    //   setState(() {
    //     print('codi -3- setState');
    //   });
    // });

    // ever(
    //     service.notify,
    //     (_) => {
    //           setState(() {
    //             print('codi -- setState');
    //           })
    //         });
  }

  @override
  Widget build(BuildContext context) {
    DeviceUtil.initialize();

    return Scaffold(body: _build(context));
  }

  Widget _build(BuildContext context) {
    return ListView.builder(
        itemCount: service.datas.length,
        itemBuilder: (context, index) {
          var data = service.datas[index];
          if (data.type == 1) {
            return Obx(() => Container(
                  width: 200.px,
                  height: 200.px,
                  color: Color.fromARGB(255, math.Random().nextInt(255),
                      math.Random().nextInt(255), math.Random().nextInt(255)),
                  child: Text('${service.datas.length}'),
                ));
          } else if (data.type == 3) {
            return Container(child: data.widget!);
          }
        });
  }

  Widget _build2(BuildContext context) {
    return ListView.builder(
      itemCount: service.datas.length,
      itemBuilder: (context, index) {
        var data = service.datas[index];
        print('codi -- itemBuilder:  ${data.type} size: ${data.height}');
        if (data.type == 2) {
          return Container(
              child: NativeAdWidget(
            nativeAd: data.nativeAd!,
            height: 200,
            width: MediaQuery.of(context).size.width,
          ));
        } else if (data.type == 3) {
          return Container(child: data.widget!);
        } else if (data.type == 1) {
          return Container(
            height: 200.px, // 设置广告item的高度
            width: MediaQuery.of(context).size.width, // 设置广告item的宽度
            child: Text('${data.message!}'),
            color: Color.fromARGB(255, math.Random().nextInt(255),
                math.Random().nextInt(255), math.Random().nextInt(255)),
          );
        }
      },
    );
  }
}




// if (service.datas.length > index) {
            //   return Obx(() {
            //     return Container(
            //       width: MediaQuery.of(context).size.width,
            //       child: Text('asdasaasas'),
            //     );
            //   });
            // } else {
            //   return Container(
            //     height: 200.px, // 设置广告item的高度
            //     width: MediaQuery.of(context).size.width, // 设置广告item的宽度
            //     child: Text("item  =====  ${index}"),
            //   );
            // }
