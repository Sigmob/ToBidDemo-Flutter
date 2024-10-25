import 'dart:io';

class AdInfo {
  int? networkId;                   /// 渠道id
  String? networkName;              /// 渠道名称
  String? networkPlacementId;       /// 渠道的广告位ID
  String? groupId;                  /// 瀑布流id / 策略分组ID
  int? abFlag;                      /// ab分组
  int? loadPriority;                /// 加载优先级
  int? playPriority;                /// 播放优先级
  int? eCPM;                        /// 单位分
  String? currency;                 /// 货币单位
  bool isHeaderBidding;             /// 是否hb广告源
  String? loadId;                   /// 每次展示广告时生成的独立 ID，可用于排查问题
  String? userId;                   /// app自己的用户体系的id，开发者传入
  int? adType;                      /// 当前广告类型
  int? networkAdType;               /// 当前三方广告源广告类型
  String? scene;                    /// 广告场景id，由开发者传入
  Map<String, dynamic>? options;    /// 开发者在request中传入的options
  Map<String, dynamic>? networkOptions; /// 渠道传入的options
  String? aggrWaterfallId;          /// ToBid 平台定义广告源id，开发者可用于排序
  String? ruleId;                   /// 定向包ID
  int? rewardTiming;                /// 多类型广告优选，发放激励时机 激励视频类型：0  默认激励时机（三方渠道的激励回调）插屏/开屏： 1  广告关闭时机 2  广告点击时机
  int? bidType;                     /// bid类型，0：s2s，1：c2c
  int? adsourceIndex;               /// 广告源序号
  int? isNativeAdsource;            /// 是否是原生广告源转换的广告
  String? pecm;                     /// 获取加密广告价格，注意格式为非数字,目前仅支持百度


  AdInfo({
    this.networkId,
    this.networkName,
    this.networkPlacementId,
    this.groupId,
    this.abFlag,
    this.loadPriority,
    this.playPriority,
    this.eCPM,
    this.currency,
    this.isHeaderBidding = false,
    this.loadId,
    this.userId,
    this.adType,
    this.networkAdType,
    this.scene,
    this.options,
    this.networkOptions,
    this.aggrWaterfallId,
    this.ruleId,
    this.rewardTiming,
    this.bidType,
    this.adsourceIndex,
    this.isNativeAdsource,
    this.pecm,
    }) ;


  factory AdInfo.fromJson(Map<String, dynamic> json) => AdInfo(
        networkId: json["networkId"],
        networkName: json["networkName"], 
        networkPlacementId: json["networkPlacementId"], 
        groupId: json["groupId"], 
        abFlag: json["abFlag"], 
        loadPriority: json["loadPriority"], 
        playPriority: json["playPriority"], 
        eCPM: (json["eCPM"] is int) ? json["eCPM"] : int.parse(json["eCPM"].replaceAll(RegExp(r'[^0-9]'),'')), 
        currency: json["currency"], 
        isHeaderBidding: json["isHeaderBidding"], 
        loadId: json["loadId"], 
        userId: json["userId"], 
        adType: json["adType"], 
        networkAdType: json.containsKey('network_adType') ? json["network_adType"] : json['networkAdtype'], 
        scene: json["scene"],
        options: json["options"],
        networkOptions: json.containsKey('networkOptions') ? json['networkOptions'] : json['netWorkOptions'],
        aggrWaterfallId: json.containsKey('aggrWaterfallId') ? json['aggrWaterfallId'] : json['aggreWaterfallId'].toString(),
        ruleId: json['ruleId'],
        rewardTiming: json.containsKey('rewardTiming') ? json['rewardTiming'] : json['reward_timing'],
        bidType: json['bidType'],
        adsourceIndex: json.containsKey('adsourceIndex') ? json['adsourceIndex'] : json['adSourceIndex'],
        isNativeAdsource: json.containsKey('isNativeAdsource') ? json['isNativeAdsource'] : json['isNativeAdSource'],
        pecm: json['pecm'],   
  );

  
  Map<String, dynamic> toJson() => {
    "networkId": networkId,
    "networkName":networkName,
    "networkPlacementId":networkPlacementId,
    "groupId":groupId,
    "abFlag":abFlag,
    "loadPriority":loadPriority,
    "playPriority":playPriority,
    "eCPM":eCPM,
    "currency":currency,
    "isHeaderBidding":isHeaderBidding,
    "loadId":loadId,
    "userId":userId,
    "adType":adType,
    "networkAdType":networkAdType,
    "scene":scene,
    "options":options,
    'networkOptions':networkOptions,
    'aggrWaterfallId':aggrWaterfallId,
    'ruleId':ruleId,
    'rewardTiming':rewardTiming,
    'bidType':bidType,
    'adsourceIndex':adsourceIndex,
    'isNativeAdsource':isNativeAdsource,
    'pecm':pecm
  };



}