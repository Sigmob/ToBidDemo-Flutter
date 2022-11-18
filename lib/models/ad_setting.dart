import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';

AdSetting adSettingFromJson(String str) => AdSetting.fromJson(json.decode(str));

String adSettingToJson(AdSetting data) => json.encode(data.toJson());

class AdSetting {
  AdSetting(
      {this.id,
      this.appId,
      this.appKey,
      this.slotIds,
      this.udid,
      this.displayName,
      this.otherSetting});

  int? id;
  int? appId;
  String? appKey;
  List<SlotId>? slotIds;
  String? udid;
  String? displayName;
  OtherSetting? otherSetting;

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
      return AdSetting.fromJson(json);
    } catch (err) {
       return   AdSetting(appId: 16991,slotIds: [SlotId(adSlotId: "3431532395562379",adType: 2)],otherSetting:  OtherSetting());
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
      print(error);
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
      this.useNewInstance = false});

  String? userId;
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
      };
}
