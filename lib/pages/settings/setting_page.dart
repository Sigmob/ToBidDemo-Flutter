import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'sdk_params_page.dart';
import 'test_id.dart';
import '../../service/http_request.dart';
import 'package:windmill_ad_plugin_example/pages/settings/filter_page.dart';

class SettingPage extends StatelessWidget {

  final List _items = [
    {'icon': Icons.ad_units, 'title': '广告位参数'},
    {'icon': Icons.settings, 'title': 'SDK参数设置'},
    {'icon': Icons.construction, 'title': '快手调试工具'},
    {'icon': Icons.construction, 'title': '代理设置'},
    {'icon': Icons.filter, 'title': '过滤工具'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: ListView.separated(
          itemBuilder: _itemBuilder,
          separatorBuilder: _separatorBuilder,
          itemCount: _items.length),
    );
  }

  Widget _itemBuilder(BuildContext ctx, int index) {
    return ListTile(
      leading: Icon(_items[index]['icon'], size: 30, color: Colors.redAccent),
      title: Text(_items[index]['title'], style: TextStyle(fontSize: 18),),
      trailing: null,
      onTap: ()=>_itemOnTap(ctx,index),
    );
  }

  Widget _separatorBuilder(BuildContext ctx, int index) {
    return Divider(
      indent: 20,
    );
  }

  void _initProxy(BuildContext ctx)  {
    showTextInputDialog(
       context: ctx,
       textFields: [
         DialogTextField(),
       ],
     title: '请输入代理地址: IP:PORT',
   ).then((value){
        HttpRequest.initporxy(value![0]);
   });
  }

  void _itemOnTap(BuildContext ctx,int index) {
    if(index == 0) {
      Get.to(() => TestIdPage());
    }else if(index == 1) {
      Get.to(() => SDKPages());
    }else if(index == 2){
      // WindmillAd.showKSDebug();
    }else if(index == 3){
      _initProxy(ctx);
    }else if (index == 4) {
      Get.to(() => FilterPage());
    }
  }
}
