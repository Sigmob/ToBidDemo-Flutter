import 'dart:ffi';
import 'dart:math';

// import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:windmill_ad_plugin/windmill_ad_plugin.dart';
import 'package:windmill_ad_plugin_example/controller/controller.dart';
import 'package:windmill_ad_plugin_example/models/ad_setting.dart';


class ItemModel {
  String name;
  String value;
  ItemModel({
    required this.name,
    required this.value
  });
}


class ChannelModel {
   int id;
   String name;
  ChannelModel({
    required this.id,
    required this.name
  });
}

class bidTypeModel {
  int id;
  String name;
  bidTypeModel({
    required this.id,
    required this.name,
  });
}

class FilterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FilterPageState();
  }
}

class _FilterPageState extends State<FilterPage> {

List<WindMillFilterModel> _filterModelList = [];


final _items = [
  ItemModel(name: "渠道id", value: ''),
  ItemModel(name: '渠道广告位id', value: ''),
  ItemModel(name: '竞价类型', value: ''),
  ItemModel(name: '价格', value: '')
];


static final  List<ChannelModel> _channels = [
    ChannelModel(id: 1, name: 'Mintegral'),
    ChannelModel(id: 4, name: 'Vungle'),
    ChannelModel(id: 5, name: 'Applovin'),
    ChannelModel(id: 6, name: 'UnityAds'),
    ChannelModel(id: 7, name: 'Ironsource'),
    ChannelModel(id: 9, name: 'Sigmob'),
    ChannelModel(id: 11, name: 'Admob'),
    ChannelModel(id: 13, name: 'CSJ'),
    ChannelModel(id: 16, name: 'GDT'),
    ChannelModel(id: 19, name: 'KuaiShou'),
    ChannelModel(id: 20, name: 'Klevin'),
    ChannelModel(id: 21, name: 'Baidu'),
    ChannelModel(id: 22, name: 'GroMore'),
    ChannelModel(id: 23, name: 'Oppo'),
    ChannelModel(id: 24, name: 'Vivo'),
    ChannelModel(id: 25, name: 'HuaWei'),
    ChannelModel(id: 26, name: 'Mimo'),
    ChannelModel(id: 27, name: 'Adscope'),
    ChannelModel(id: 28, name: 'Qumeng'),
    ChannelModel(id: 29, name: 'Taptap'),
    ChannelModel(id: 30, name: 'Pangle'),
    ChannelModel(id: 31, name: 'Max'),
    ChannelModel(id: 33, name: 'REKLAMUP'),
    ChannelModel(id: 35, name: 'ADMATE'),
    ChannelModel(id: 36, name: 'HONOR'),
    ChannelModel(id: 37, name: 'INMOBI')
];
final _channelItems = _channels.map((channelModel) => MultiSelectItem(channelModel, channelModel.name)).toList();
List<ChannelModel> _selectChannel = [];
String _selectChannelStr = '';

String _selectAdnId = '';

static final _bidTypes = [
  bidTypeModel(id: 0, name: 's2s'),
  bidTypeModel(id: 1, name: 'c2s'),
  bidTypeModel(id: 2, name: 'normal')

];
final _bidTypeItems = _bidTypes.map((bidType) => MultiSelectItem(bidType, bidType.name)).toList();
List<bidTypeModel> _selectBidType = [];
String _selectBidtypeStr = '';

String _selectOperator = '';
String _selectEcpm = '';

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Controller c = Get.find();
    _filterModelList.addAll(c.adSetting.value.filterModelList ?? []);
    for (var model in _filterModelList) {
       int itemCount = _items.length;
        int filterIndex = itemCount - 3;
        String name = '规则$filterIndex';
        String channelStr = (model.channelIdList ?? []).join(',');
        String adnIdStr = (model.adnIdList ?? []).join(',');
        String bidTypeStr = (model.bidTypeList ?? []).join(',');
        String ecpmStr = '';
        List<WindMillFilterEcpmModel> ecpmList = model.ecpmList ?? [];
        for (int i = 0; i < ecpmList.length; i++) {
          WindMillFilterEcpmModel ecpmModel = ecpmList[i];
          ecpmStr += ecpmModel.operatorType?.operator ?? '';
          ecpmStr += ecpmModel.ecpm.toString();
          if (i != ecpmList.length - 1) {
            ecpmStr += ',';
          }
        }
        String value = '渠道:$channelStr 广告位id:$adnIdStr 类型:$bidTypeStr ecpm:$ecpmStr';
        _items.add(ItemModel(name: name, value: value));
    }
    
    
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('过滤工具'),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () => {
          _saveFilterModel()
        }
      ),
    );
  }

  Widget _buildBody() {
   return ListView.separated(
    itemBuilder: _itemBuilder,
    separatorBuilder: _separatorBuilder,
    itemCount: _items.length,
   );
  }

  Widget _itemBuilder(BuildContext context, int index) {
     ItemModel model = _items[index];
     if (index > 3) {
       return Dismissible(
        key: ValueKey(_items[index]), 
        direction: DismissDirection.horizontal,
        child: ListTile(
        leading: Text(model.name + ':', style: const TextStyle(fontSize: 18),),
        title: Text(model.value, style: const TextStyle(fontSize: 16),),
        onTap: () => _onTapItem(context, index),
      ),
      background: Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      color: Colors.redAccent,
      child: Icon(Icons.delete, color: Colors.white),
    ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Text('删除'),
      ),
      onDismissed: (direction) {
        setState(() {
          _items.removeAt(index);
          for (int i = 0; i < _items.length; i++) {
            if (i > 3) {
              int filterIndex = i - 3;
              String name = '规则$filterIndex';
              _items[i].name = name;
            }
          }
          _filterModelList.removeAt(index - 4);
          Controller c = Get.find();
          c.adSetting.update((val) {
            val?.filterModelList = _filterModelList;
            val?.saveToFile();
          });
        });
      },
      );
     }
     return ListTile(
      leading: Text(model.name + ':', style: const TextStyle(fontSize: 18),),
      title: Text(model.value, style: const TextStyle(fontSize: 16),),
      onTap: () => _onTapItem(context, index),
    );
    
  
  }

  Widget _separatorBuilder(BuildContext context, int index) {
    return const Divider();
  }

  void _onTapItem(BuildContext context, int index) {
    if (index == 0) {
       _showChannelMultiSelect(context);
    } else if (index == 1) {
      // _showAdnId(context);
    } else if (index == 2) {
      _showBidTypeMultiSelect(context);
    } else if (index == 3) {
      // _showEcpm(context);
    }
   
  }

  void _showChannelMultiSelect(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (context) {
        return MultiSelectDialog(
          title: const Text('渠道'),
          cancelText: const Text('取消'),
          confirmText: const Text('确定'),
          items: _channelItems, 
          initialValue: _selectChannel,
          onConfirm: (List<ChannelModel> list) {
            _selectChannel = list;
            setState(() {
              String channelId = '';
              for (int i = 0; i < _selectChannel.length; i++) {
                var model = _selectChannel[i];
                channelId += model.id.toString();
                if (i != _selectChannel.length - 1) {
                   channelId += ',';
                }
              }
              _items.first.value = channelId;
              _selectChannelStr =channelId;
            });
          },
        );
      }
    );
  }

  // void _showAdnId(BuildContext context) async {
  //   await showTextInputDialog(
  //     context: context,
  //     title: '请输入渠道广告位id',
  //     okLabel: '确定',
  //     cancelLabel: '取消',
  //     textFields: [
  //        DialogTextField(
  //         hintText: '多个id请以，隔开',
  //         initialText: _selectAdnId,
  //       )
  //     ],
  //     onPopInvoked: (didPop,
  //         // result
  //         ) {
  //       setState(() {
  //         // _selectAdnId = result?.first ?? '';
  //         _selectAdnId =  '_selectAdnId';
  //         _items[1].value = _selectAdnId;
  //       });
  //     },
  //   );
  // }

  void _showBidTypeMultiSelect(BuildContext context) async {
    await showDialog(
      context: context, 
      builder: (context) {
        return MultiSelectDialog(
          title: const Text('bid类型'),
          cancelText: const Text('取消'),
          confirmText: const Text('确定'),
          items: _bidTypeItems, 
          initialValue: _selectBidType,
          onConfirm: (List<bidTypeModel> list) {
            _selectBidType = list;
            setState(() {
              String bidType = '';
              for (int i = 0; i < _selectBidType.length; i++) {
                var model = _selectBidType[i];
                bidType += model.id.toString();
                if (i != _selectBidType.length - 1) {
                   bidType += ',';
                }
              }
              _items[2].value = bidType;
              _selectBidtypeStr = bidType;
            });
          },
        );
      }
    );
  }

  // void _showEcpm(BuildContext context) async {
  //   await showTextInputDialog(
  //     context: context,
  //     title: '请输入价格',
  //     okLabel: '确定',
  //     cancelLabel: '取消',
  //     textFields: [
  //        DialogTextField(
  //         hintText: '多个操作符请以，隔开',
  //         initialText: _selectOperator,
  //       ),
  //        DialogTextField(
  //         hintText: '多个数值请以，隔开',
  //         initialText: _selectEcpm,
  //       ),
  //     ],
  //     onPopInvoked:
  //         (didPop,
  //         // result
  //         )
  //     {
  //       setState(() {
  //         // _selectOperator = result?.first ?? '';
  //         _selectOperator = '_selectOperator';
  //         // _selectEcpm = result?[1] ?? '';
  //         _selectEcpm =  '_selectEcpm';
  //         String value = '';
  //         List<String> operatorList = _selectOperator.split(',');
  //         List<String> ecpmList = _selectEcpm.split(',');
  //         int count = min(operatorList.length, ecpmList.length);
  //         for (var i = 0; i < count; i++) {
  //           String operator = operatorList[i];
  //           String ecpm = ecpmList[i];
  //           value += operator;
  //           value += ecpm;
  //           if (i != count - 1) {
  //             value += ',';
  //           }
  //         }
  //         _items[3].value = value;
  //       });
  //     },
  //   );
  // }

  void _saveFilterModel() {
    if (_selectChannelStr.isEmpty && _selectAdnId.isEmpty && _selectBidtypeStr.isEmpty && _selectOperator.isEmpty && _selectEcpm.isEmpty) {
      Fluttertoast.showToast(msg: '规则不存在', gravity: ToastGravity.CENTER);
      return;
    }
    List<int> channels = _selectChannelStr.isEmpty ? [] : _selectChannelStr.split(',').map((value) => int.parse(value)).toList();
    List<String> adnIds = _selectAdnId.isEmpty ? [] : _selectAdnId.split(',');
    List<int> bidTypes = _selectBidtypeStr.isEmpty ? [] : _selectBidtypeStr.split(',').map((value) => int.parse(value)).toList();
    List<WindMillFilterEcpmModel> ecpms = [];
    List<String> operatorList = _selectOperator.isEmpty ? [] : _selectOperator.split(',');
    List<String> ecpmList = _selectEcpm.isEmpty ? [] : _selectEcpm.split(',');
    int count = min(operatorList.length, ecpmList.length);
    for (var i = 0; i < count; i++) {
      String operator = operatorList[i];
      String ecpmStr = ecpmList[i];
      double ecpm = 0;
      if (ecpmStr.isNotEmpty) {
        ecpm = double.parse(ecpmStr);
      }
      WindMillFilterEcpmModel? ecpmModel;
      if (ecpm <= 0) continue;
      if (operator == '>') {
       ecpmModel = WindMillFilterEcpmModel(ecpm: ecpm, operatorType:OperatorType.greaterThan);
      } else if (operator == '>=') {
        ecpmModel = WindMillFilterEcpmModel(ecpm: ecpm, operatorType: OperatorType.greaterThanOrEqual);
      } else if (operator == '<') {
        ecpmModel = WindMillFilterEcpmModel(ecpm: ecpm, operatorType: OperatorType.lessThan);
      } else if (operator == '<=') {
        ecpmModel = WindMillFilterEcpmModel(ecpm: ecpm, operatorType: OperatorType.lessThanOrEqual); 
      }
      if (ecpmModel != null) {
        ecpms.add(ecpmModel);
      }
    }
   
    _filterModelList.add(WindMillFilterModel(
      channelIdList: channels,
      adnIdList: adnIds,
      bidTypeList: bidTypes,
      ecpmList: ecpms
    ));


    // 展示过滤数据，清空输入
    int itemCount = _items.length;
    int filterIndex = itemCount - 3;
    String name = '规则$filterIndex';
    String value = '渠道:$_selectChannelStr 广告位id:$_selectAdnId 类型:$_selectBidtypeStr ecpm:${_items[3].value}';
    for (int i = 0; i < _items.length; i++) {
      if (i < 4) {
        _items[i].value = '';
      }
    }
    _selectChannel = [];
    _selectChannelStr = '';
    _selectAdnId = '';
    _selectBidType = [];
    _selectBidtypeStr = '';
    _selectOperator = '';
    _selectEcpm = '';
    setState(() {
      _items.add(ItemModel(name: name, value: value));
    });
    
    Controller c = Get.find();
    c.adSetting.update((val) {
      val?.filterModelList = _filterModelList;
      val?.saveToFile();
    });
  }
}
