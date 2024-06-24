import 'dart:async';
import 'dart:math' as math;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  final service = Get.find<NativeAdService>();
  late EasyRefreshController _controller;

  @override
  void initState() {
    super.initState();

    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    service.generateFakeDatas();

    service.adLoad(
        "7547245474827569", Size(MediaQuery.of(context).size.width, 200));

    service.adLoad(
        "3328854952462696", Size(MediaQuery.of(context).size.width, 200));

    // service.adLoad(
    //     "2873998415684324", Size(MediaQuery.of(context).size.width, 200));

    // service.adLoad(
    //     "5225613544461947", Size(MediaQuery.of(context).size.width, 200));

    ///忽略1秒内的所有变化。
    interval(
        service.notify,
        (_) => {
              setState(() {
                _controller.finishLoad(IndicatorResult.success);
                print('codi -3- setState');
              })
            },
        time: Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceUtil.initialize();
    return Scaffold(body: _build(context));
  }

  Widget _build(BuildContext context) {
    return EasyRefresh(
        controller: _controller,
        refreshOnStart: true,
        refreshOnStartHeader: BuilderHeader(
          triggerOffset: 70,
          clamping: true,
          position: IndicatorPosition.above,
          processedDuration: Duration.zero,
          builder: (ctx, state) {
            if (state.mode == IndicatorMode.inactive ||
                state.mode == IndicatorMode.done) {
              return const SizedBox();
            }
            return Container(
              padding: const EdgeInsets.only(bottom: 100),
              width: double.infinity,
              height: state.viewportDimension,
              alignment: Alignment.center,
              child: const SpinKitFadingCube(
                size: 24,
                color: Color.fromARGB(255, 255, 0, 0),
              ),
            );
          },
        ),
        onLoad: () async {
          service.adLoad(
              "9399188276982074", Size(MediaQuery.of(context).size.width, 0));
        },
        child: ListView.builder(
            itemCount: service.datas.length,
            itemBuilder: (context, index) {
              var data = service.datas[index];
              if (data.type == 1) {
                return Obx(() => Container(
                      width: 200.px,
                      height: 200.px,
                      color: Color.fromARGB(
                          255,
                          math.Random().nextInt(255),
                          math.Random().nextInt(255),
                          math.Random().nextInt(255)),
                      child: Text('${service.datas.length}'),
                    ));
              } else if (data.type == 3) {
                return Container(child: data.widget!);
              }
            }));
  }
}
