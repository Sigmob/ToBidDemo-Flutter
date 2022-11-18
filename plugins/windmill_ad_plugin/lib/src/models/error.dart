class WMError {
  int code;
  String message;

  WMError(this.code, this.message);

  Map<String, dynamic> toJson() => {
    "code": code,
    "mesage": message
  };

}