class WindmillNetworkInfo {

    int networkId;
    String? appId;
    String? appKey;

  WindmillNetworkInfo({ required this.networkId,this.appId,this.appKey});

  Map<String, dynamic> toJson() {
    return {
      'networkId': networkId,
      'appId': appId,
      'appKey': appKey,
    };
  }
}
