import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import '../../models/ad_setting.dart';
import '../../service/http_request.dart';


class TestIdPage extends StatefulWidget {
  const TestIdPage({Key? key}) : super(key: key);

  @override
  TestIdPageState createState() => new TestIdPageState();
}

class TestIdPageState extends State<TestIdPage> {
  List _items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('广告位参数'),
       
      ),
      body: _builderBody(),
    );
  }


 
  
  Widget _builderBody() {
    return ListView.separated(
        itemBuilder: _itemBuilder,
        separatorBuilder: _separatorBuilder,
        itemCount: _items.length
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var item = _items[index];
    return ListTile(
      title: Text(item['title']),
      trailing: item['subTitle'] == null ? null : Text('${item['subTitle']}'),
      subtitle: item['type'] == null ? null : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate((item['slots'] as List).length, (index) {
          var slot = (item['slots'] as List)[index] as SlotId;
          return Text('${slot.adSlotId}');
        }),
      ),
    );
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return Divider(
      indent: 20,
    );
  }

  void _initItem(AdSetting adSetting) {
    _items = [
      {'title': 'AppId', 'subTitle': adSetting.appId},
      {'title': '激励视频广告位', 'type': 1, 'slots': adSetting.slotIds!.where((e) => e.adType == 1).toList()},
      {'title': '开屏广告位', 'type': 1, 'slots': adSetting.slotIds!.where((e) => e.adType == 2).toList()},
      {'title': '插屏广告位', 'type': 1, 'slots': adSetting.slotIds!.where((e) => e.adType == 4).toList()},
      {'title': '原生广告位', 'type': 1, 'slots': adSetting.slotIds!.where((e) => e.adType == 5).toList()},
      {'title': '横幅广告位', 'type': 1, 'slots': adSetting.slotIds!.where((e) => e.adType == 7).toList()},
    ];
  }



  @override
  void initState() {
    super.initState();
    Controller c = Get.find();
    print(c.adSetting.value.toJson());
    print(c.adSetting.value.slotIds);
    print(c.adSetting.value.slotIds!.where((e) => e.adType == 1));
    setState(() {
      _initItem(c.adSetting.value);
    });
  }
}

