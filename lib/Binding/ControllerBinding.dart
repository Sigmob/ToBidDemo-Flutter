import 'package:get/get.dart';
import 'package:windmill_ad_plugin_example/controller/BannerController.dart';
import 'package:windmill_ad_plugin_example/controller/InterstitialController.dart';
import 'package:windmill_ad_plugin_example/controller/NativeController.dart';
import 'package:windmill_ad_plugin_example/controller/NativeDrawController.dart';
import 'package:windmill_ad_plugin_example/controller/RwController.dart';
import 'package:windmill_ad_plugin_example/controller/SplashController.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import 'package:windmill_ad_plugin_example/pages/home/native_ad_service.dart';

class ControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(Controller());
  }
}

class RewardBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RwController());
  }
}

class InterstitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(IntersititialController());
  }
}

class BannerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(BannerController());
  }
}

class NativeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NativeController());
  }

}

class NativeListBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NativeAdService());
  }
}

class NativeDrawBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(NativeDrawController());
  }
}

class SplashBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }

}



