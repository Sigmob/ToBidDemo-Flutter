import 'package:flutter/material.dart';

class ZPBottomBarItem extends BottomNavigationBarItem {
  ZPBottomBarItem(String title, IconData iconData)
      : super(
    label: title,
    icon: Icon(iconData, size: 32, color: Colors.grey,),
    activeIcon: Icon(iconData, size: 32, color: Colors.blue)
  );
}