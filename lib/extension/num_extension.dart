import '../utils/device_util.dart';

extension NumExtension on num {
  double get rpx {
    return DeviceUtil.setRpx(this);
  }

  double get px {
    return DeviceUtil.setPx(this);
  }
}