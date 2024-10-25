class WindmillFilterInfo {

  int? networkId;

  List<String>? unitIdList;

  WindmillFilterInfo({this.networkId, this.unitIdList});

  Map<String, dynamic> toJson() {
    return {'networkId': networkId, 'unitIdList': unitIdList};
  }
}


class WindMillFilterModel {
  /// 渠道号
  List<int>? channelIdList;
  /// 渠道广告位id
  List<String>? adnIdList;
  /// 渠道价格
  List<WindMillFilterEcpmModel>? ecpmList;
  /// 渠道竞价类型
  List<int>? bidTypeList;

  WindMillFilterModel({
    this.channelIdList,
    this.adnIdList,
    this.ecpmList,
    this.bidTypeList
  });

  Map<String, dynamic> toJson() {
    return {
      "channelIdList": channelIdList,
      "adnIdList": adnIdList,
      "ecpmList": ecpmList?.map((e) => e.toJson()).toList(),
      "bidTypeList": bidTypeList
    };
  }
}

class WindMillBidType {
  /// s2s,服务端bidding
   static const s2s = 0; 
    /// 客户端bidding 
   static const c2s = 1; 
    /// normal 广告位    
   static const normal = 2;
}

class WindMillFilterEcpmModel {
  /// 渠道ecpm,单位为分
  double? ecpm;
  /// 运算类型
  OperatorType? operatorType;

  WindMillFilterEcpmModel({
    this.ecpm,
    this.operatorType,
  });

  Map<String, dynamic> toJson() {
    return {
      "ecpm": ecpm,
      "operator": operatorType?.operator,
    };
  }

}

enum OperatorType {
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
}

extension OperatorTypeExtension on OperatorType {
  String get operator {
    switch(this) {
      case OperatorType.greaterThan:
      return ">";
      case OperatorType.lessThan:
      return "<";
      case OperatorType.greaterThanOrEqual:
      return ">=";
      case OperatorType.lessThanOrEqual:
      return "<=";
      default:
      return "not support";
    }
  }
}