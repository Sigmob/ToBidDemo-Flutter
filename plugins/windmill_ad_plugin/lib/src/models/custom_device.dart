import 'package:windmill_ad_plugin/src/models/location.dart';


class PackageInfo {
  /// 包名
  String? packageName;

  /// 应用名称
  String? appName;

  /// 版本名称
  String? versionName;

  /// 版本号
  int? versionCode;

  PackageInfo({
    this.packageName,
    this.appName,
    this.versionName,
    this.versionCode
  });

  Map<String, dynamic> toJson() => {
    'packageName': packageName,
    'appName': appName,
    'versionName': versionName,
    'versionCode': versionCode,
  };
  
}

class CustomDevice{

  /// 是否允许SDK主动获取IDFA信息
  /// @return YES可以获取，NO禁止获取。默认为YES
  bool? isCanUseIdfa;

  /// 当isCanUseIdfa=YES时，可传入idfa信息。sdk使用您传入的idfa信息
  /// @return idfa设备信息
  String? customIDFA;

  /// 是否允许SDK主动使用地理位置信息
  /// @return YES可以获取，NO禁止获取。默认为YES
  bool? isCanUseLocation;

  /// 当isCanUseLocation=NO时，可传入地理位置信息，sdk使用您传入的地理位置信息
  /// @return 地理位置参数
  Location? customLocation;

  /// 是否允许SDK主动使用手机硬件参数，如：imei
  /// @return true可以使用，false禁止使用。默认为true
  bool? isCanUsePhoneState;

  /// 当isCanUsePhoneState=false时，可传入imei信息，ToBid使用您传入的imei信息
  /// @return imei信息
  String? customIMEI;

  /// 是否允许SDK主动使用手机硬件参数，如：android
  /// @return true可以使用，false禁止使用。默认为true
  bool? isCanUseAndroidId;

  /// isCanUseAndroidId=false时，可传入android信息，ToBid使用您传入的android信息
  /// @return android信息
  String? customAndroidId;

  /// 是否允许获取oaid
  /// @return true 允许 false 不允许 默认为true
  bool? isCanUseOaid;

  /// isCanUseOaid=false时，开发者可以传入oaid，ToBid使用您传入的oaid信息
  /// @return oaid
  String? customOAID;

  /// 是否允许SDK主动获取设备上应用安装列表的采集权限
  /// @return true可以使用，false禁止使用。默认为true
  bool? isCanUseAppList;

  /// isCanUseAppList=false时，可传入手机安装包信息，ToBid使用您传入的包信息
  /// @return 应用安装列表
  List<PackageInfo>? customInstalledPackages;

  /// 是否允许SDK主动使用ACCESS_WIFI_STATE权限
  /// @return true可以使用，false禁止使用。默认为true
  bool? isCanUseWifiState;

  /// 是否允许获取MacAddress信息
  /// @return true 允许 false 不允许 默认为true
  bool?  isCanUseMacAddress;

  /// isCanUseMacAddress=false时，可传入MacAddress，ToBid使用您传入的MacAddress信息
  /// @return MacAddress参数
  String? customMacAddress;

  /// 是否允许SDK主动使用WRITE_EXTERNAL_STORAGE权限
  /// @return true可以使用，false禁止使用。默认为true
  bool? isCanUseWriteExternal;

  /// 是否允许SDK在申明和授权了的情况下使用录音权限
  /// @return true 允许 false 不允许 默认为true
  bool? isCanUsePermissionRecordAudio;

  CustomDevice({
  this.isCanUseIdfa = true,
  this.customIDFA,
  this.isCanUseLocation = true,
  this.customLocation,
  this.isCanUsePhoneState = true,
  this.customIMEI,
  this.isCanUseAndroidId = true,
  this.customAndroidId,
  this.isCanUseOaid = true,
  this.customOAID,
  this.isCanUseAppList = true,
  this.customInstalledPackages,
  this.isCanUseWifiState = true,
  this.isCanUseMacAddress = true,
  this.customMacAddress,
  this.isCanUseWriteExternal = true,
  this.isCanUsePermissionRecordAudio = true,
  });

}