import 'package:windmill_ad_plugin/src/models/location.dart';

class CustomDevice{

  bool? isCanUseIdfa;

  bool? isCanUseLocation;
  bool? isCanUseAndroidId;
  bool? isCanUsePhoneState;
  bool? isCanUseAppList;
  bool? isCanUseWifiState;
  bool? isCanUseWriteExternal;
  bool? isCanUsePermissionRecordAudio;
  
  String? customMacAddress;
  String? customAndroidId;
  String? customOAID;
  String? customIMEI;
  String? customIDFA;
  Location? customLocation;


  CustomDevice({
  this.isCanUseIdfa = true,

  this.isCanUseAndroidId = true,
  this.isCanUseLocation = true,
  this.isCanUsePhoneState = true,
  this.isCanUseAppList = true,
  this.isCanUseWriteExternal = true,
  this.isCanUseWifiState = true,
  this.isCanUsePermissionRecordAudio = true,

  this.customMacAddress,
  this.customAndroidId,
  this.customIDFA,
  this.customIMEI,
  this.customLocation,
  this.customOAID});

}