import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/features/mian_window/data/models/menu_model.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(
      icon: Icons.dashboard,
      title: 'dashboard'.tr(),
    ),
    MenuModel(
      icon: Icons.home,
      title: 'home'.tr(),
    ),
    MenuModel(
      icon: Icons.control_camera,
      title: 'summary'.tr(),
    ),
    MenuModel(
      icon: Icons.people_sharp,
      title: 'clients'.tr(),
    ),
    MenuModel(
      icon: Icons.discount,
      title: 'Packages'.tr(),
    ),
    MenuModel(
      icon: Icons.storefront,
      title: 'buffet'.tr(),
    ),
    MenuModel(
      icon: Icons.task_alt_outlined,
      title: 'to_do_task'.tr(),
    ),
    MenuModel(
      icon: Icons.bar_chart_sharp,
      title: 'Statistics'.tr(),
    ),
    MenuModel(
      icon: Icons.manage_accounts,
      title: 'admin_management'.tr(),
    ),
    MenuModel(
      icon: Icons.settings,
      title: 'settings'.tr(),
    ),
    MenuModel(
      icon: Icons.logout,
      title: 'sign_out'.tr(),
    ),
  ];
}
