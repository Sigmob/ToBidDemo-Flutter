import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'sdk_params_page.dart';
import 'test_id.dart';


class SettingPage extends StatelessWidget {

  final List _items = [
    {'icon': Icons.ad_units, 'title': '广告位参数'},
    {'icon': Icons.settings, 'title': 'SDK参数设置'},
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
      onTap: ()=>_itemOnTap(index),
    );
  }

  Widget _separatorBuilder(BuildContext ctx, int index) {
    return Divider(
      indent: 20,
    );
  }

  void _itemOnTap(int index) {
    if(index == 0) {
      Get.to(() => TestIdPage());
    }else if(index == 1) {
      Get.to(() => SDKPages());
    }
  }
}
