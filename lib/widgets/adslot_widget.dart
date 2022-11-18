import 'package:flutter/material.dart';

import '../models/ad_setting.dart';


typedef StringCallback = void Function(String);

class AdSlotWidget extends StatelessWidget {
  final List<SlotId> items;
  final StringCallback? onLoad;
  final StringCallback? onPlay;
  final bool hasPlay;

  AdSlotWidget(this.items,{this.hasPlay = true, this.onLoad, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(items.length, (index) => _buildSlotWidget(index)),
        ),
      ),
    );
  }

  Widget _buildSlotWidget(int index) {
    var item = items[index];
    return  Wrap(
      children: [
        _buildLoadWidget(item),
        _buildPlayWidget(item),
      ],
    );
  }
  Widget _buildLoadWidget(SlotId item) {
    return ElevatedButton(
      onPressed: (){
        if(onLoad != null) {
          onLoad!(item.adSlotId!);
        }
      },
      child: Row(
        children: [
          Icon(Icons.hd_outlined, size: 32,),
          SizedBox(width: 10,),
          Text("加载 ${item.adSlotId}", style: TextStyle(fontSize: 16)),

        ],
      ),
    );
  }
  Widget _buildPlayWidget(SlotId item) {
    if(!hasPlay) {
      return SizedBox();
    }
    return ElevatedButton(
      onPressed: (){
        if(onPlay != null) {
          onPlay!(item.adSlotId!);
        }
      },
      child: Row(
        children: [
          Icon(Icons.play_circle_outline_sharp, size: 32,),
          SizedBox(width: 10,),
          Text("播放 ${item.adSlotId}" , style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

}