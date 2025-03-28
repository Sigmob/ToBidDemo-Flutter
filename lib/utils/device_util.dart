import 'dart:ui';

class DeviceUtil {
  static double physicalWidth = 0;
  static double physicalHeight = 0;
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double dpr = 0;
  static double statusHeight = 0;

  static double rpx = 0;
  static double px = 0;

  static double bodyHeight = 0;

  static void initialize({double standardSize = 750}) {
    // 1.手机的物理分辨率

    physicalWidth = window.physicalSize.width;
    physicalHeight = window.physicalSize.height;
    // 2.获取dpr
    dpr = window.devicePixelRatio;
    // 3.宽度和高度
    screenWidth = physicalWidth / dpr;
    screenHeight = physicalHeight / dpr;
    // 4.状态栏高度
    statusHeight = window.padding.top / dpr;
    // 5.计算rpx的大小
    
    rpx = screenWidth / standardSize;
    px = screenWidth / standardSize * 2;
  }


  static double setRpx(num size) {
    return rpx * size.toDouble();
  }

  static double setPx(num size) {
    return px * size.toDouble();
  }
}