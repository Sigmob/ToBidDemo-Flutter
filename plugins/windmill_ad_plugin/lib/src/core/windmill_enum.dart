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

enum WindmillInteractionType {
    interactionTypeCustorm(0) ,
    interactionTypeNO_INTERACTION(1),  // pure ad display
    interactionTypeURL(2),             // open the webpage using a browser
    interactionTypePage(3),            // open the webpage within the app
    interactionTypeDownload(4),        // download the app
    interactionTypePhone(5),           // make a call
    interactionTypeMessage(6),         // send messages
    interactionTypeEmail(7),           // send email
    interactionTypeVideoAdDetail(8),   // video ad details page
    interactionTypeWechat(9),          // open wechat
    interactionTypeDeepLink(10),        // deep link
    interactionTypeMediationOthers(100),  //聚合其他广告sdk返回的类型
    ;
    final int num;
    const WindmillInteractionType(this.num);
    static WindmillInteractionType getType(int num) => WindmillInteractionType.values.firstWhere((test) => test.num == num);
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
  static const REKLAMUP = 33;
  static const OPPOADN = 34;
  static const ADMATE = 35;
  static const HONOR = 36;
  static const INMOBI = 37;
  static const VIVOADN = 38;
  static const BILLOWLINK = 39;
  static const JADYun = 40;
  static const Octopus = 41;        // 章鱼
  static const Mercury = 42;        // 倍业 
  static const HuaWei_Lite = 43;    
  static const TOBIDX = 999;
}
