import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

AdSetting adSettingFromJson(String str) => AdSetting.fromJson(json.decode(str));

String adSettingToJson(AdSetting data) => json.encode(data.toJson());

extension WindMillFilterModelExtension on WindMillFilterModel {
  static WindMillFilterModel fromJson(Map<String, dynamic> json) {
    return WindMillFilterModel(
      channelIdList: List<int>.from(json['channelIdList']),
      adnIdList:  List<String>.from(json['adnIdList']),
      bidTypeList: List<int>.from(json['bidTypeList']),
      ecpmList: List<WindMillFilterEcpmModel>.from(json['ecpmList'].map((value) => WindMillFilterEcpmModelExtension.fromJson(value))),
    );
  }
}

extension WindMillFilterEcpmModelExtension on WindMillFilterEcpmModel {
  static WindMillFilterEcpmModel fromJson(Map<String, dynamic> json) {
    return WindMillFilterEcpmModel(
      operatorType: OperatorTypeExtension.fromOperator(json['operator']),
      ecpm: json['ecpm']
    );
  }
}

extension OperatorTypeExtension on OperatorType {
  static fromOperator(String operator) {
    switch (operator) {
      case '>':
      return OperatorType.greaterThan;
      case '>=':
      return OperatorType.greaterThanOrEqual;
      case '<':
      return OperatorType.lessThan;
      case '<=':
      return OperatorType.lessThanOrEqual;
    }
  }
}
class AdSetting {
  AdSetting(
      {this.id,
      this.appId,
      this.appKey,
      this.slotIds,
      this.udid,
      this.displayName,
      this.otherSetting,
      this.filterModelList,
      });

  int? id;
  int? appId;
  String? appKey;
  List<SlotId>? slotIds;
  String? udid;
  String? displayName;
  OtherSetting? otherSetting;
  List<WindMillFilterModel>? filterModelList;

  static Future<String> _path() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return '$appDocPath/adsetting.json';
  }

  static Future<AdSetting?> fromFile() async {
    try {
      String path = await _path();
      var file = File(path);
      String contents = await file.readAsString();
      var json = convert.jsonDecode(contents);
      print('adSettingJson = $json');
      return AdSetting.fromJson(json);
    } catch (err) {
      print('adSettingJsonError = $err');
        /* adType:
        * 1:激励广告
        * 2:开屏广告 
        * 4:插屏广告
        * 5:原生信息流广告
        * 7:横幅广告
        */
      if(Platform.isIOS){
          return  AdSetting(appId: 16990,slotIds: [
                        SlotId(adSlotId: "8373387208687695",adType: 1), // 激励广告位
                        SlotId(adSlotId: "8374774642581842",adType: 2), // 开屏广告位 
                        SlotId(adSlotId: "9690693976929807",adType: 4), // 插屏广告位
                        SlotId(adSlotId: "5756789376418096",adType: 5), // 原生信息流广告位 
                        SlotId(adSlotId: "9828667573411889",adType: 7), // 横幅广告位
                      ],otherSetting:  OtherSetting());

      }else{
          return  AdSetting(appId: 63448,slotIds: [
                      SlotId(adSlotId: "9387595158051935",adType: 1), // 激励广告位
                      SlotId(adSlotId: "7538995191492217",adType: 2), // 开屏广告位
                      SlotId(adSlotId: "4753286031006593",adType: 4), // 插屏广告位
                      SlotId(adSlotId: "9224761251541712",adType: 5), // 原生信息流广告位 
                      SlotId(adSlotId: "6426940313333654",adType: 7), // 横幅广告位
                    ],otherSetting:  OtherSetting());
      }
    }
  }

  void saveToFile() async {
    try {
      String path = await _path();
      var file = File(path);
      var contents = convert.jsonEncode(this.toJson());
      print('contents: $contents');
      file.writeAsString(contents);
    } catch (error) {
      print('saveError: $error');
    }
  }

  factory AdSetting.fromJson(Map<String, dynamic> json) => AdSetting(
        id: json["id"],
        appId: json["appId"],
        appKey: json["appKey"],
        slotIds:
            List<SlotId>.from(json["slotIds"].map((x) => SlotId.fromJson(x))),
        otherSetting: json['otherSetting'] == null
            ? OtherSetting()
            : OtherSetting.fromJson(json['otherSetting']),
        udid: json["udid"],
        displayName: json["displayName"],
        filterModelList: json['otherSetting'] == null ? [] : List<WindMillFilterModel>.from(json['filterModelList'].map((json) => WindMillFilterModelExtension.fromJson(json))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appId": appId,
        "appKey": appKey,
        "slotIds": slotIds == null
            ? <dynamic>[]
            : List<dynamic>.from(slotIds!.map((x) => x.toJson())),
        "otherSetting": otherSetting == null ? null : otherSetting!.toJson(),
        "udid": udid,
        "displayName": displayName,
        "filterModelList": filterModelList == null ? <dynamic>[] : List.from(filterModelList!.map((value) => value.toJson()))
      };
}

class SlotId {
  SlotId({
    this.adSlotId,
    this.adType,
    this.bidType,
  });

  String? adSlotId;
  int? adType;
  int? bidType;

  factory SlotId.fromJson(Map<String, dynamic> json) => SlotId(
        adSlotId: json["adSlotId"],
        adType: json["adType"],
        bidType: json["bidType"],
      );

  Map<String, dynamic> toJson() => {
        "adSlotId": adSlotId,
        "adType": adType,
        "bidType": bidType,
      };
}

class OtherSetting {
  OtherSetting(
      {this.userId,
      this.adSceneDesc,
      this.adSceneId,
      this.age = 0,
      this.loadCount = 3,
      this.gdprIndex = 0,
      this.coppaIndex = 0,
      this.adultState = 0,
      this.personalizedAdvertisingState = 0,
      this.enablePlayingLoad = false,
      this.isCanUseAndroidId = true,
      this.isCanUseIdfa = true,
      this.isCanUseLocation = true,
      this.isCanUsePhoneState = true,
      this.isCanUseAppList = true,
      this.isCanUseWifiState = true,
      this.isCanUseWriteExternal = true,
      this.isCanUsePermissionRecordAudio = true,
      this.customMacAddress = "",
      this.customAndroidId = "",
      this.customIDFA = "",
      this.customIMEI = "",
      this.customLocation = "",
      this.customOAID = "",
      this.useNewInstance = false,
      this.customGroup = ""});

  String? userId;
  String? customGroup;

  bool isCanUseLocation;
  bool isCanUseIdfa;
  bool isCanUseAndroidId;
  bool isCanUsePhoneState;

  bool isCanUseAppList;
  bool isCanUseWifiState;
  bool isCanUseWriteExternal;
  bool isCanUsePermissionRecordAudio;

  String? customMacAddress;
  String? customAndroidId;
  String? customOAID;
  String? customIMEI;
  String? customIDFA;
  String? customLocation;
 
  String? adSceneDesc;
  String? adSceneId;

  int age;
  int loadCount;
  int gdprIndex;
  int coppaIndex;
  int adultState;
  int personalizedAdvertisingState;
  bool enablePlayingLoad;
  bool useNewInstance;

  factory OtherSetting.fromJson(Map<String, dynamic> json) => OtherSetting(
        userId: json["userId"],
        adSceneDesc: json["adSceneDesc"],
        adSceneId: json["adSceneId"],
        age: json["age"],
        loadCount: json["loadCount"],
        gdprIndex: json["gdprIndex"],
        coppaIndex: json["coppaIndex"],
        adultState: json["adultState"],
        personalizedAdvertisingState: json["personalizedAdvertisingState"],
        enablePlayingLoad: json["enablePlayingLoad"],
        useNewInstance: json["useNewInstance"],
        isCanUseAndroidId: json["isCanUseAndroidId"],
        isCanUsePhoneState: json["isCanUsePhoneState"], 
        isCanUseIdfa: json["isCanUseIdfa"],
        isCanUseLocation: json["isCanUseLocation"],
        isCanUseAppList: json["isCanUseAppList"],
        isCanUseWifiState: json["isCanUseWifiState"], 
        isCanUseWriteExternal: json["isCanUseWriteExternal"],
        isCanUsePermissionRecordAudio: json["isCanUsePermissionRecordAudio"],
        customMacAddress: json["customMacAddress"],
        customAndroidId: json["customAndroidId"],
        customOAID: json["customOAID"],
        customIMEI: json["customIMEI"],
        customIDFA: json["customIDFA"],
        customLocation: json["customLocation"],
        customGroup: json["customGroup"],
        
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "adSceneDesc": adSceneDesc,
        "adSceneId": adSceneId,
        "age": age,
        "loadCount": loadCount,
        "gdprIndex": gdprIndex,
        "coppaIndex": coppaIndex,
        "adultState": adultState,
        "personalizedAdvertisingState": personalizedAdvertisingState,
        "enablePlayingLoad": enablePlayingLoad,
        "useNewInstance": useNewInstance,
        "isCanUseAndroidId": isCanUseAndroidId,
        "isCanUsePhoneState": isCanUsePhoneState,
        "isCanUseLocation": isCanUseLocation,
        "isCanUseIdfa": isCanUseIdfa,
        "isCanUseAppList": isCanUseAppList,
        "isCanUseWifiState": isCanUseWifiState,
        "isCanUseWriteExternal": isCanUseWriteExternal,
        "isCanUsePermissionRecordAudio": isCanUsePermissionRecordAudio,
        "customMacAddress": customMacAddress,
        "customAndroidId": customAndroidId,
        "customOAID": customOAID,
        "customIMEI": customIMEI,
        "customIDFA": customIDFA,
        "customLocation": customLocation,
        "customGroup": customGroup,

      };
}
