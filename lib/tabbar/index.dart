import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/SplashController.dart';
import '../controller/controller.dart';
import 'initialize_items.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        items: items,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
  @override
  void initState() {
    // 添加观察者
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    // 移除观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('AppLifecycleState.inactive');
        break;
      case AppLifecycleState.paused:
        print('AppLifecycleState.paused');
        break;
      case AppLifecycleState.resumed:
        print('AppLifecycleState.resumed');
        loadSplashAd("3570962751953533");
        break;
      case AppLifecycleState.detached:
        print('AppLifecycleState.suspending');
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  // 开屏
  void loadSplashAd(String? placementId) async {
    if (!Get.isRegistered<Controller>()){
      Get.put(Controller());
    }
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }
    final c = Get.find<SplashController>();
    await c.adLoad(placementId ?? "");
  }
}