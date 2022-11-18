class AdRequest {
  String? userId;
  String placementId;
  Map<String, String>? options;

  AdRequest({required this.placementId, this.userId, this.options});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['placementId'] = placementId;
    if(userId != null) {
      json['userId'] = userId;
    }
    if(options != null) {
      json['options'] = options;
    }
    return json;
  }
}