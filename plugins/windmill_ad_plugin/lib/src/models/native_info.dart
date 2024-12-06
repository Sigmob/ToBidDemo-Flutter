
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

enum WindMillFeedADMode {
  none(0),
  smallImage(2),
  largeImage(3),
  groupImage(4),
  nativeExpress(5),
  portraitImage(6),
  video(14),
  videoPortrait(15),
  videoLandSpace(16),
  ;


  final int num;
  const WindMillFeedADMode(this.num);
  static WindMillFeedADMode getMode(int num) => WindMillFeedADMode.values.firstWhere((e) => e.num == num);

}



enum WindMillNativeAdSlotAdType {
  none(0),
  feed(1),
  drawVideo(2),
  ;
  final int num;
  const WindMillNativeAdSlotAdType(this.num);
  static WindMillNativeAdSlotAdType getType(int num) => WindMillNativeAdSlotAdType.values.firstWhere((e) => e.num == num);
}


class WMImageInfo {
  String? imageURL;
  double? width;
  double? height;

  WMImageInfo({
    this.imageURL,
    this.width,
    this.height
  });

  static WMImageInfo fromJson(Map<String, dynamic> json) {
    return WMImageInfo(
      imageURL: json['imageURL'],
      width: json['width'] is num ? (json['width'] as num).toDouble() : 0,
      height: json['height'] is num ? (json['height'] as num).toDouble() : 0
    );
  }

  Map<String, dynamic> toJson() => {
    'imageURL': imageURL,
    'width': width,
    'height': height
  };

}

class WindMillNativeInfo {
  /// 标题
  String? title;
  /// 描述
  String? desc;
  /// 图标地址
  String? iconUrl;
  /// cta名称
  String? callToAction;
  /// 图片信息列表
  List<WMImageInfo>? imageModelList;
  /// 渠道id
  int? networkId;
  /// 广告模式
  WindMillFeedADMode? feedADMode;
  /// 广告类型
  WindMillNativeAdSlotAdType? adType;
  /// 广告交互类型
  WindmillInteractionType? interactionType;


  WindMillNativeInfo({
    this.title,
    this.desc,
    this.iconUrl,
    this.callToAction,
    this.imageModelList,
    this.networkId,
    this.feedADMode,
    this.adType,
    this.interactionType,
  });

  static WindMillNativeInfo fromJson(Map<String, dynamic> json) => WindMillNativeInfo(
    title: json['title'],
    desc: json['desc'],
    iconUrl: json['iconUrl'],
    callToAction: json['callToAction'],
    imageModelList: json.containsKey('imageModelList') ? List.from(json['imageModelList']).map((e) => WMImageInfo.fromJson(e)).toList() : null,
    networkId: json['networkId'],
    feedADMode: WindMillFeedADMode.getMode(json["feedADMode"]),
    adType: WindMillNativeAdSlotAdType.getType(json['adType']),
    interactionType: WindmillInteractionType.getType(json['interactionType']),
  );


  Map<String, dynamic> toJson() => {
    'title': title,
    'desc': desc,
    'iconUrl': iconUrl,
    'callToActionn': callToAction,
    'imageModelList': imageModelList?.map((e) => e.toJson()),
    'networkId': networkId,
    'feedADMode': feedADMode?.num,
    'adType': adType?.num,
    'interactionType': interactionType?.num,
  };

}

