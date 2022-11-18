import 'package:get/get.dart';
import 'package:windmill_ad_plugin_example/Binding/ControllerBinding.dart';
import 'package:windmill_ad_plugin_example/pages/home/banner_page.dart';
import 'package:windmill_ad_plugin_example/pages/home/home_page.dart';
import 'package:windmill_ad_plugin_example/pages/home/intersititial_page.dart';
import 'package:windmill_ad_plugin_example/pages/home/native_page.dart';
import 'package:windmill_ad_plugin_example/pages/home/reward_page.dart';
import 'package:windmill_ad_plugin_example/pages/home/splash_page.dart';
import 'package:windmill_ad_plugin_example/tabbar/index.dart';


abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.MAIN, page:()=> MainPage(), binding: ControllerBinding()),
    GetPage(name: Routes.HOME, page:()=> HomePage()),
    GetPage(name: Routes.SPLASH, page:()=> SplashPage(), binding: SplashBinding()),
    GetPage(name: Routes.REWARD, page:()=> RewardPage(), binding: RewardBinding()),
    GetPage(name: Routes.INTERSITITIAL, page:()=> IntersititialPage(), binding: InterstitialBinding()),
    GetPage(name: Routes.BANNER, page:()=> BannerPage(), binding: BannerBinding()),
    GetPage(name: Routes.NATIVE, page:()=> NativePage(), binding: NativeBinding()),
  ];
}


class Routes {
  static const MAIN = '/';
  static const HOME = '/home';
  static const REWARD = '/reward';
  static const INTERSITITIAL = '/intersititial';
  static const BANNER = '/banner';
  static const SPLASH = '/splash';
  static const NATIVE = '/native';
}