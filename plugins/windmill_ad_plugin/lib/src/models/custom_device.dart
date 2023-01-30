import 'package:windmill_ad_plugin/src/models/location.dart';

class CustomDevice{

  bool? isCanUseLocation;
  bool? isCanUseIdfa;
  bool? isCanUseAndroidId;
  bool? isCanUsePhoneState;
  
  String? customAndoidId;
  String? customOAID;
  String? customIMEI;
  String? customIDFA;
  Location? customLocation;


  CustomDevice({this.isCanUseAndroidId = true,
  this.isCanUseIdfa = true,
  this.isCanUseLocation = true,
  this.isCanUsePhoneState = true,
  this.customAndoidId,
  this.customIDFA,
  this.customIMEI,
  this.customLocation,
  this.customOAID});


}