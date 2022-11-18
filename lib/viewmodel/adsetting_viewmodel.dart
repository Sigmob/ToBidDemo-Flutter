import 'package:flutter/material.dart';
import '../models/ad_setting.dart';


class AdSettingViewModel with ChangeNotifier {
  AdSetting? _adSetting;

  AdSetting? get adSetting => _adSetting;

  set adSetting(AdSetting? value) {
    _adSetting = value;
    notifyListeners();
  }
}