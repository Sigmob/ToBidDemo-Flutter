import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';
import '../pages/settings/setting_page.dart';
import 'bottom_bar_item.dart';


List<ZPBottomBarItem> items = [
  ZPBottomBarItem("home", Icons.home),
  ZPBottomBarItem("setting", Icons.settings),
];

List<Widget> pages = [
  HomePage(),
  SettingPage(),
];
