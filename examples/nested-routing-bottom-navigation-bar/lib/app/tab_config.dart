import 'package:flutter/material.dart';

enum AppTab { home, business, school, flight }

class TabConfig {
  const TabConfig(this.tab, this.path, this.title, this.icon, this.color, this.size);

  final AppTab tab;
  final String title;
  final String path;
  final IconData icon;
  final MaterialColor color;
  final int size;
}

Map<AppTab, TabConfig> tabConfigs = const {
  AppTab.home: TabConfig(
    AppTab.home,
    'home',
    'Home',
    Icons.home,
    Colors.teal,
    50,
  ),
  AppTab.business: TabConfig(
    AppTab.business,
    'business',
    'Business',
    Icons.business,
    Colors.purple,
    50,
  ),
  AppTab.school: TabConfig(
    AppTab.school,
    'school',
    'School',
    Icons.school,
    Colors.orange,
    50,
  ),
  AppTab.flight: TabConfig(
    AppTab.flight,
    'flight',
    'Flight',
    Icons.flight,
    Colors.blue,
    50,
  )
};