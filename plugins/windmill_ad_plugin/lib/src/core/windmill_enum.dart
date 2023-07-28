enum CCPA {
  unknow,
  accepted,
  denied
}
enum GDPR {
  unknow,
  accepted,
  denied
}
enum COPPA {
  unknow,
  accepted,//年龄受限制
  denied////成年人，年龄不受限制
}
enum Adult {
  adult,
  children
}
enum Personalized {
  on,
  off
}

 class WindmillNetworkId {
  static const Mintegral = 1;
  static const Vungle = 4;
  static const Applovin = 5;
  static const UnityAds = 6;
  static const Ironsource = 7;
  static const Sigmob = 9;
  static const Admob =11;
  static const CSJ = 13;
  static const GDT = 16;
  static const KuaiShou = 19;
  static const Klevin = 20;
  static const Baidu = 21;
  static const GroMore = 22;
  static const Oppo = 23;
  static const Vivo = 24;
  static const HuaWei = 25;
  static const Mimo = 26;
  static const Adscope =27;
  static const Qumeng =28;
  static const TapTap =29;
  static const Pangle =30;
  static const Max =31;
}