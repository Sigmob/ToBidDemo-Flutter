class WindmillFilterInfo {

  int? networkId;

  List<String>? unitIdList;

  WindmillFilterInfo({this.networkId, this.unitIdList});

  Map<String, dynamic> toJson() {
    return {'networkId': networkId, 'unitIdList': unitIdList};
  }
}
