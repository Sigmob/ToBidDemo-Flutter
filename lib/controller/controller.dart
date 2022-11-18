import 'package:get/get.dart';
import '../models/ad_setting.dart';

class Controller extends GetxController {
  var adSetting = AdSetting().obs;

  @override
  void onInit() {
    super.onInit();
    print('controller onInit...');
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    print('controller onClose...');
  }

  void _initData() async {
    AdSetting? adSetting = await AdSetting.fromFile();
    this.adSetting.update((val) {
      val!.slotIds = adSetting == null ? [] : adSetting.slotIds;
      val.appId = adSetting?.appId;
      val.id = adSetting?.id;
      val.otherSetting = adSetting == null ? OtherSetting() : adSetting.otherSetting;
    });
  }
}