import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/utils/responsive.dart';
import 'package:lighthouse_/core/utils/shared_prefrences.dart';
import 'package:lighthouse_/features/packages/presentation/view/packages_page.dart';
import 'package:lighthouse_/features/premium_client/presentation/view/premium_clients_page.dart';
import 'package:lighthouse_/features/admin_managment/presentation/view/admin_managment.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';
import 'package:lighthouse_/features/mian_screen/presentation/view/empty_screen.dart';
import 'package:lighthouse_/features/mian_screen/presentation/widget/side_menu_bar.dart';
import 'package:lighthouse_/features/mian_screen/presentation/widget/summary.dart';
import 'package:lighthouse_/features/presentation/view/qr_generator.dart';
import 'package:lighthouse_/features/setting/presentation/view/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static List<Widget> selectedContent = [
    const EmptyWidget(),
    const EmptyWidget(),
    const QrGenerator(
        data:
            "193e0a0b-720a-4e3d-a280-4bcdc2846462-fCataTup3CG9cC04-0987654321-Premium_User-8bb0ba33-e53c-44f3-9f18-2c7e26796ce5"),
    const PremiumClientsPage(),
    const PackagesPage(),
    const EmptyWidget(),
    const EmptyWidget(),
    const EmptyWidget(),
    const AdminManagment(),
    const SettingsPage()
  ];

  int selectedIndex = 1;

  void _onMenuItemSelected(int index) {
    if (index == 10) {
      storage.get<SharedPreferences>().setBool("auth", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginWindows(),
        ),
      );
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      floatingActionButtonLocation: isDesktop
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.login),
        label:  Text('add_session'.tr()),
      ),
      drawer: !isDesktop
          ? SizedBox(
              width: 250,
              child: SideMenuWidget(changeindex: _onMenuItemSelected),
            )
          : null,
      endDrawer: Responsive.isMobile(context)
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const SummaryWidget(),
            )
          : null,
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: SideMenuWidget(changeindex: _onMenuItemSelected),
                ),
              ),
            Expanded(
              flex: 7,
              child: selectedContent[selectedIndex],
            ),
            if (isDesktop)
              const Expanded(
                flex: 3,
                child: SummaryWidget(),
              ),
          ],
        ),
      ),
    );
  }
}
