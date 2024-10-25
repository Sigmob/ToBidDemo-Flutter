import 'dart:math' as math;
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../controller/NativeListController.dart';
import '../../controller/controller.dart';
import '../../models/ad_setting.dart';

class NativeListPage extends StatelessWidget {
  final NativeListController service = Get.find();
  late EasyRefreshController refreshController;

  NativeListPage({Key? key}) : super(key: key) {
    this.initData();
  }

  initData() {
    print('codi -- initData -- ');

    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    service.generateFakeDatas();
    final Controller c = Get.find();
    List<SlotId> items = c.adSetting.value.slotIds!
        .where((element) => element.adType == 5)
        .toList();
    var id = items[0].adSlotId;
    service.adLoad(id.toString(), Size(300, 0));

    
    ever(service.notifyFinished, (_) => refreshController.finishLoad());
  }

  Color randomColor() {
    return Color.fromARGB(255, math.Random().nextInt(255),
        math.Random().nextInt(255), math.Random().nextInt(255));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("原生List广告"),
      ),
      body:  Container(
        color: Colors.white,
        child: Obx(
          () => EasyRefresh(
              controller: refreshController,
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
                final Controller c = Get.find();
                List<SlotId> items = c.adSetting.value.slotIds!
                    .where((element) => element.adType == 5)
                    .toList();
                var id = items[0].adSlotId;
                service.adLoad(id.toString(), Size(300, 0));
              },
              child: ListView.builder(
                  itemCount: service.datas.length,
                  itemBuilder: (BuildContext context, int index) {
                    print('codi -- builder -- ${index}');
                    NativeInfo data = service.datas[index];
                    if (data.type == 2) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: data.widget,
                        ),
                      );
                    } else if (data.type == 1) {
                      return Container(
                        height: 200,
                        color: randomColor(),
                      );
                    }
                  })),
        )
     ),
    );
  }
}
