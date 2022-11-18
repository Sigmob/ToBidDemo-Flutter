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
  String? scene;                    /// 广告场景id，由开发者传入
  Map<String, dynamic>? options;     /// 开发者在request中传入的options

  AdInfo({this.networkId,
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
    this.scene,
    this.options}) ;


  factory AdInfo.fromJson(Map<String, dynamic> json) => AdInfo(
        networkId: json["networkId"],
        networkName: json["networkName"], 
        networkPlacementId: json["networkPlacementId"], 
        groupId: json["groupId"], 
        abFlag: json["abFlag"], 
        loadPriority: json["loadPriority"], 
        playPriority: json["playPriority"], 
        eCPM: json["eCPM"], 
        currency: json["currency"], 
        isHeaderBidding: json["isHeaderBidding"], 
        loadId: json["loadId"], 
        userId: json["userId"], 
        adType: json["adType"], 
        scene: json["scene"], 
        options: json["options"],       
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
    "scene":scene,
    "options":options,
  };



}