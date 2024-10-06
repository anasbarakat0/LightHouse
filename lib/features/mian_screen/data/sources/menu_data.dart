import 'package:flutter/material.dart';
import 'package:light_house/features/mian_screen/data/models/menu_model.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(
      icon: Icons.dashboard,
      title: 'Dashboard',
    ),
    MenuModel(
      icon: Icons.home,
      title: 'Home',
    ),
    MenuModel(
      icon: Icons.control_camera,
      title: 'Overview',
    ),
    MenuModel(
      icon: Icons.people_sharp,
      title: 'Premium Clients',
    ),
    MenuModel(
      icon: Icons.discount,
      title: 'Special Deals',
    ),
    MenuModel(
      icon: Icons.storefront,
      title: 'Buffet',
    ),
    MenuModel(
      icon: Icons.task_alt_outlined,
      title: 'To Do Tasks',
    ),
    MenuModel(
      icon: Icons.bar_chart_sharp,
      title: 'Statistics',
    ),
    MenuModel(
      icon: Icons.logout,
      title: 'SignOut',
    ),
  ];
}
