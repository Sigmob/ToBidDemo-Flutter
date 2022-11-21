import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windmill_ad_plugin/src/ads/native/native_listener.dart';
import 'package:windmill_ad_plugin/src/core/windmill_event_handler.dart';
import 'package:windmill_ad_plugin/src/models/ad_request.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';

class WindmillNativeAd with WindmillEventHandler{

  static const MethodChannel _channel =  MethodChannel('com.windmill/native');


  final double width; //广告宽度
  final double height; //广告高度，设置为0表示根据width自适应，通过adSize.height获取自适应后的高度
  late Size? adSize; // 广告渲染成功后，返回广告实际大小
  late final ValueNotifier<Size> sizeNotify;

  final AdRequest request;
  late String _uniqId;
  late MethodChannel _adChannel;
  late final WindmillNativeListener<WindmillNativeAd> _listener;
  WindmillNativeAd({
    Key? key,
    required this.request,
    required this.width,
    required this.height,
    required WindmillNativeListener<WindmillNativeAd> listener,

  }):super() {
    _uniqId = hashCode.toString();
    _listener = listener;
    delegate = IWindmillNativeListener(this, _listener);
    _adChannel = MethodChannel('com.windmill/native.$_uniqId');
    _adChannel.setMethodCallHandler(handleEvent);
  }


  void updateAdSize(Size size) {
    adSize = size;
  }

  Size? getAdSize(){
    return adSize;
  }

  Future<bool> isReady() async {
    bool isReady = await _channel.invokeMethod('isReady', {
      "uniqId": _uniqId
    });
    return isReady;
  }

  Future<void> loadAd() async {
    await _channel.invokeMethod('load', {
      "uniqId": _uniqId,
      "width":  width,
      "height": height,
      'request': request.toJson()
    });
  }



  Future<AdInfo> getAdInfo() async {
    String adinfoStr = await _channel.invokeMethod("getAdInfo",{
      "uniqId":_uniqId 
    });
    final adInfoJson = json.decode(adinfoStr);
    return AdInfo.fromJson(adInfoJson); 
  }
  



  Future<void> destory() async {
    await _channel.invokeMethod('destory', {
      "uniqId": _uniqId
    });
  }
}


class CustomNativeAdConfig {
  
  static String rootView() {
    return 'rootView';
  }

static String iconView() {
    return 'iconView';
  }

 static String mainAdView() {
    return 'mainAdView';
  }

  static String titleView() {
    return 'titleView';
  }

  static String descriptView() {
    return 'descriptView';
  }

  static String adLogoView() {
    return 'adLogoView';
  }

  static String ctaButton() {
    return 'ctaButton';
  }

  static String dislikeButton() {
    return 'dislikeButton';
  }


static Map createNativeSubViewAttribute(double width, double height,
      {double x = 0,
      double y = 0,
      String backgroundColor = '#FFFFFF',
      String textColor = '#000000',
      int fontSize = 0,
      int scaleType = 0,
      int textAlignment = 0,
      bool isCtaClick = false,
      bool pixel = false}) {
    return {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      "fontSize":fontSize,
      'backgroundColor': backgroundColor,
      'scaleType':scaleType,
      'textAlignment':textAlignment,
      'textColor': textColor,
      'isCtaClick': isCtaClick,
      'pixel':pixel
    };
  }
}
class NativeAdWidget extends StatefulWidget {
  @override
  NativeAdWidgetState createState() => NativeAdWidgetState();

  final double width; //广告宽度
  final double height; 
  final WindmillNativeAd nativeAd;
  Map? nativeCustomViewConfig;
  late final ValueNotifier<Size> sizeNotify;


  NativeAdWidget({
    Key? key,
    required this.nativeAd,
    required this.width,
    required this.height,
    this.nativeCustomViewConfig,
  }) : super(key: key) {
    sizeNotify = ValueNotifier<Size>(Size(width, height));
  }




  void updateAdSize(Size size) {

      if(size.height>0 && size.width>0){
        sizeNotify.value = size;
      }
  }
}

class NativeAdWidgetState extends State<NativeAdWidget>
    with AutomaticKeepAliveClientMixin, WindmillEventHandler {
  // View 类型
  final String viewType = 'flutter_windmill_ads_native';
  // 创建参数
  late Map<String, dynamic> creationParams;
  NativeAdWidgetState() : super() {
   
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (Platform.isIOS) {
      return _buildIOSWidget();
    } else {
      return _buildAndroidWidget();
    }
  }

  Widget _buildIOSWidget() {
    return ValueListenableBuilder<Size>(
      valueListenable: widget.sizeNotify,
      child: _buildUIKitView(),
      builder: (ctx, size, child) {
        return SizedBox.fromSize(size: size, child: child);
      },
    );
  }

  Widget _buildAndroidWidget() {

 return ValueListenableBuilder<Size>(
      builder: (ctx, size, child) {

         Size optSize = size;
         
        if(optSize.height < 1){
           optSize = Size(size.width, 1);
        }
        return SizedBox.fromSize(
              size: optSize,
              child: child,
          ); 
      },
      valueListenable: widget.sizeNotify,
      child: _buildAndroidView(),
    );
  }
  
  _buildAndroidView() {
    return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
  }
  Widget _buildUIKitView() {
    return UiKitView(
      viewType: viewType,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  @override
  void initState() {
    super.initState();
    creationParams = <String, dynamic>{
      "uniqId": widget.nativeAd.hashCode.toString(),
      "nativeCustomViewConfig":widget.nativeCustomViewConfig,
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
