import 'package:flutter/material.dart';
import 'package:light_house/core/utils/responsive.dart';
import 'package:light_house/features/qr_generate/presentation/view/qr_generator.dart';
import 'package:light_house/features/to_do_task/presentation/view/to_do_tasks.dart';
import 'package:light_house/features/mian_screen/presentation/view/empty_screen.dart';
import 'package:light_house/features/mian_screen/presentation/widget/side_menu_bar.dart';
import 'package:light_house/features/mian_screen/presentation/widget/summary.dart';

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
    const EmptyWidget(),
    const EmptyWidget(),
    const EmptyWidget(),
    const ToDoTasks(),
    const EmptyWidget(),
    const EmptyWidget(),
  ];

  int selectedIndex = 1;

  void _onMenuItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
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
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Customer'),
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
