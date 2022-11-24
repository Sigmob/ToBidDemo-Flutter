import 'package:flutter/material.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:get/get.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import '../../utils/device_util.dart';


class SDKPages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('参数设置'),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: ElevatedButton(
              onPressed: () {
                Controller c = Get.find();
                c.adSetting.value.saveToFile();
              },
              child: Text('保存'),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0)
              ),
            ),

          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Controller c = Get.find();
    return ListView(
      children: [

        Obx(() => _leftTitleAndRightSubTitle(title: '场景描述：', text: c.adSetting.value.otherSetting!.adSceneDesc, keyboardType: TextInputType.text,onSubmit: (text){
          c.adSetting.update((val) {
            val?.otherSetting?.adSceneDesc = text;
          });
        })),
        Obx(() => _leftTitleAndRightSubTitle(title: '场景Id：', text: c.adSetting.value.otherSetting!.adSceneId, onSubmit: (text){
          c.adSetting.update((val) {
            val?.otherSetting?.adSceneId = text;
          });
        })),
        Obx(() => _leftTitleAndRightSubTitle(title: 'User-Age：', text: c.adSetting.value.otherSetting!.age.toString(), onSubmit: (text){
          c.adSetting.update((val) {
            val?.otherSetting?.age = int.parse(text);
          });
        })),
        Obx(() => _leftTitleAndRightSubTitle(title: 'User-Id：', text: c.adSetting.value.otherSetting!.userId, keyboardType: TextInputType.text, onSubmit: (text){
          c.adSetting.update((val) {
            val?.otherSetting?.userId = text;
          });
        })),
        const SizedBox(height: 10,),
        Obx(() => _leftTitleAndRightSeg(
            title: 'COPPA',
            value: c.adSetting.value.otherSetting!.coppaIndex,
            segments: {'0': '未知', '1': '限制', '2': '不限制'},
            onChange: (value) {
              c.adSetting.update((val) {
                val?.otherSetting?.coppaIndex = int.parse(value);
              });
            }
        )),
        Obx(() => _leftTitleAndRightSeg(
            title: 'GDPR',
            value: c.adSetting.value.otherSetting!.gdprIndex,
            segments: {'0': '未知', '1': '同意', '2': '拒绝'},
            onChange: (value) {
              c.adSetting.update((val) {
                val?.otherSetting?.gdprIndex = int.parse(value);
              });
            }
        )),
        Obx(() => _leftTitleAndRightSeg(
            title: '成年',
            value: c.adSetting.value.otherSetting!.adultState,
            segments: {'0': '成年人', '1': '未成年人'},
            onChange: (value) {
              c.adSetting.update((val) {
                val?.otherSetting?.adultState = int.parse(value);
              });
            }
        )),
        Obx(() => _leftTitleAndRightSeg(
            title: '个性化推荐',
            value: c.adSetting.value.otherSetting!.personalizedAdvertisingState,
            segments: {'0': '开启', '1': '关闭'},
            onChange: (value) {
              c.adSetting.update((val) {
                val?.otherSetting?.personalizedAdvertisingState = int.parse(value);
              });
            }
        )),
      ],
    );
  }


  Widget _leftTitleAndRightSwitch({required String title, required bool value, required ValueChanged<bool> onChanged}){
    return Container(
        width: DeviceUtil.screenWidth,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
              width: 1
            )
          )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20,
              child: Text('$title'),
            ),
            Positioned(
              right: 20,
              child: Switch(
                value: value,
                onChanged: onChanged,
              )
            )
          ],
        )
    );
  }

  Widget _leftTitleAndRightSubTitle({
    required String title,
    String? text,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onSubmit
  }){
    return Container(
        width: DeviceUtil.screenWidth,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade100,
                    width: 1
                )
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20,
              child: Text('$title'),
            ),
            Positioned(
              right: 20,
              child: Container(
                width: 200,
                height: 40,
                alignment: Alignment.center,
                child: TextField(
                  controller: TextEditingController(
                    text: text
                  ),
                  keyboardType: keyboardType,
                  textAlign: TextAlign.end,
                  decoration: _normalDecoration(),
                  onSubmitted: onSubmit,
                ),
              ),
            ),

          ],
        )
    );
  }

  Widget _leftTitleAndRightSeg({
    required String title,
    int value = 0,
    required ValueChanged<String> onChange,
    required Map<String, String> segments
  }){
    // Create a controller
    final _segController = ValueNotifier('$value');
    _segController.addListener(() {
      print(_segController.value);
      onChange(_segController.value);
    });
    return Container(
        width: DeviceUtil.screenWidth,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.shade100,
                    width: 1
                )
            )
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 20,
              child: Text('$title'),
            ),
            Positioned(
              right: 20,
              child: Container(
                height: 35,
                child: AdvancedSegment(
                  controller: _segController,
                  segments: segments,
                ),
              )
            ),
          ],
        )
    );
  }

  InputDecoration _normalDecoration(){
    return const InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixStyle: TextStyle(color: Colors.orange, fontSize:  18),
      hintText: "请输入内容",
      border: InputBorder.none
    );
  }
}