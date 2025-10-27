# ToBid SDK - Flutter 入门指南



## flutter SDK 示例源码
> https://github.com/Sigmob/ToBidDemo-Flutter

* Demo示例中我们在AdSetting.dart 默认内置了一套Tobid iOS/Android 测试广告位代码， 开发者可根据需要替换为申请的Tobid广告参数

```dart
 /* adType:
  * 1:激励广告
  * 2:开屏广告 
  * 4:插屏广告
  * 5:原生信息流广告
  * 7:横幅广告
  */
if(Platform.isIOS){
    return AdSetting(appId: 16990,slotIds: [
                SlotId(adSlotId: "8373387208687695",adType: 1), // 激励广告位
                SlotId(adSlotId: "8374774642581842",adType: 2), // 开屏广告位 
                SlotId(adSlotId: "9690693976929807",adType: 4), // 插屏广告位
                SlotId(adSlotId: "5756789376418096",adType: 5), // 原生信息流广告位 
                SlotId(adSlotId: "9828667573411889",adType: 7), // 横幅广告位
              ],otherSetting: OtherSetting());

}else{
    return AdSetting(appId: 16991,slotIds: [
                SlotId(adSlotId: "9387595158051935",adType: 1), // 激励广告位
                SlotId(adSlotId: "2009470615832232",adType: 2), // 开屏广告位 
                SlotId(adSlotId: "4753286031006593",adType: 4), // 插屏广告位
                SlotId(adSlotId: "9224761251541712",adType: 5), // 原生信息流广告位 
                SlotId(adSlotId: "6426940313333654",adType: 7), // 横幅广告位
              ],otherSetting: OtherSetting());
}
```

## flutter SDK 开放源码
> https://github.com/Sigmob/ToBidAd-Flutter

## 前提条件
  * Flutter版本要求: Flutter: ">=2.12.0" , Dart: ">=2.12.0"

## 导入移动广告 SDK
  * 手动导入:  
     1. 新建Plugins目录, 将下载的flutter sdk 放入到项目Plugins目录下
     2. 编辑 pubspec.yaml 文件
        ```yaml
        dependencies:
          windmill_ad_plugin: 
            path: Plugins/windmill_ad_plugin/
        ```
    3. 执行 `flutter pub get` 在使用类中引入头文件:
        ```dart
        import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
        ```

## iOS平台导入说明

### 添加接入的渠道

1. 更新plugins/windmill_ad_plugin/ios/windmill_ad_plugin.podspec文件，添加要接入的渠道pod内容
```dart
  s.dependency 'ToBid-iOS', '3.3.0'
  s.dependency 'ToBid-iOS/TouTiaoAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/CSJMediationAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/AdmobAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/MintegralAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/GDTAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/VungleAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/UnityAdsAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/KSAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/BaiduAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/KlevinAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/AdScopeAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/IronSourceAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/AppLovinAdapter', '3.3.0'
  s.dependency 'ToBid-iOS/MSAdAdapter', '3.3.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
```

### 添加“ObjC”链接器标记

在Xcode中选择项目的Targets->Build Settings，配置Other Link Flags 增加 **-ObjC**。

### Admob 渠道接入说明

>如果作为聚合接入且接入了Google AdMob SDK,需要在info.plist 添加GADApplicationIdentifier字段，value为AppId，`<key>GADApplicationIdentifier</key><string>申请的admob的appid</string>`，具体请参考Google AdMob 文档：https://developers.google.com/admob/ios/quick-start

**来自Google文档参数，仅做参考。**
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

### 添加HTTP权限

工程info.plist文件设置，点击右边的information Property List后边的 "+" 展开
添加 App Transport Security Settings，先点击左侧展开箭头，再点右侧加号，Allow Arbitrary Loads 选项自动加入，修改值为 YES。 SDK API 已经全部支持HTTPS，但是广告主素材存在非HTTPS情况。

```xml
<key>NSAppTransportSecurity</key>
<dict>
      <key>NSAllowsArbitraryLoads</key>
      <true/>
</dict>
```
### 添加定位权限

工程info.plist文件设置，点击右边的information Property List后边的 "+" 展开
添加Privacy - Location When In Use Usage Description。

### iOS 14 适配

#### 获取App Tracking Transparency授权

```xml
<key>NSUserTrackingUsageDescription</key>
<string>获取标记权限向您提供更优质、安全的个性化服务及内容，未经同意我们不会用于其他目的；开启后，您也可以前往系统“设置-隐私 ”中随时关闭</string>
```

### SKAdNetwork 支持
 *  从平台获取 SKAdNetwork IDs 代码列表信息 添加到 info.plist

## Android平台导入说明

### 下载并导入Android原生SDK

> 原生SDK下载地址：https://dash.sigmob.com/#/mediation/sdk-tools

### 1.将Android SDK压缩包中xml目录中的内容对应复制到工程的res目录的xml下

<img src="http://mn.sigmob.com/supportcenter_v2/windmill/SDK/flutter/res.png">

### 2. 将下载的SDK AdNetworks到plugins/windmill_ad_plugin/android/的libs目录下

<img src="http://mn.sigmob.com/supportcenter_v2/windmill/SDK/flutter/android_tobid_sdk_dir.png">

### 3. 修改android/app/build.gradle 根据需要添加依赖的渠道目录

如:

```java
dependencies {
    //AndroidX
    implementation 'androidx.legacy:legacy-support-v4:1.0.0'
    implementation 'com.android.support:multidex:1.0.3'
    implementation "androidx.appcompat:appcompat:1.2.0"
    implementation "androidx.recyclerview:recyclerview:1.2.0" 
    implementation "com.android.support:support-annotations:28.0.0"
    // implementation 'com.android.support:recyclerview-v7:28.0.0'
    // implementation 'com.android.support:appcompat-v7:28.0.0'
    // implementation 'com.android.support:support-v4:28.0.0'

    implementation fileTree(include: ["*.jar","*.aar"], dir: 'libs')

    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/Core')

    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/csj')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/gromore')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/gdt')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/kuaishou')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/baidu')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/mintegral-cn')
    implementation fileTree(include: ["*.jar","*.aar"], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/adscope')
    implementation fileTree(include: ["*.jar",'*.aar'], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/klevin')
    implementation fileTree(include: ["*.jar",'*.aar'], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/qumeng')

    implementation fileTree(include: ["*.jar", '*.aar'], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/taptap')
    implementation "com.github.bumptech.glide:glide:4.9.0"
    implementation 'io.reactivex.rxjava2:rxandroid:2.0.1'
    implementation 'io.reactivex.rxjava2:rxjava:2.0.1'
    implementation 'com.squareup.okhttp3:okhttp:3.12.1'

    implementation fileTree(include: ["*.jar", '*.aar'], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/meishu')
    implementation 'com.squareup.okhttp3:okhttp:3.12.1'
    implementation 'com.google.code.gson:gson:2.8.5'
    implementation 'com.googlecode.android-query:android-query:0.25.9'
    implementation 'androidx.cardview:cardview:1.0.0'

    implementation fileTree(include: ["*.jar", '*.aar'], dir: '../../plugins/windmill_ad_plugin/android/libs/AdNetworks/oppoadn')
    implementation 'com.squareup.okio:okio:2.5.0'
    implementation 'org.jetbrains.kotlin:kotlin-android-extensions-runtime:1.3.72'
    implementation 'android.arch.persistence:db-framework:1.1.1'//410版本新增
    implementation 'androidx.palette:palette:1.0.0'//490版本新增

}
```