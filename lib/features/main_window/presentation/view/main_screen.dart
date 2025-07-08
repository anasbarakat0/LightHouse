import 'package:flutter/material.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/buffet/presentation/view/buffet_page.dart';
import 'package:lighthouse/features/home/presentation/view/home_screen.dart';
import 'package:lighthouse/features/packages/presentation/view/packages_page.dart';
import 'package:lighthouse/features/premium_client/presentation/view/premium_clients_page.dart';
import 'package:lighthouse/features/admin_management/presentation/view/admin_management.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/empty_screen.dart';
import 'package:lighthouse/features/main_window/presentation/widget/side_menu_bar.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary.dart';
import 'package:lighthouse/features/setting/presentation/view/settings_page.dart';
import 'package:lighthouse/features/tasks/presentation/view/to_do_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static List<Widget> selectedContent = [
    const EmptyWidget(),
    const HomeScreen(),
    const EmptyWidget(),
    const PremiumClientsPage(),
    const PackagesPage(),
    const BuffetPage(),
    const ToDoTasks(),
    const EmptyWidget(),
    const AdminManagement(),
    const SettingsPage()
  ];

  int selectedIndex = 1;

  @override
  void initState() {
    memory.get<SharedPreferences>().setInt("index", 1);
    super.initState();
  }

  void callFunction(int index) {
    onMenuItemSelected(index);
  }

  void onMenuItemSelected(int index) {
    if (index == 10) {
      memory.get<SharedPreferences>().setBool("auth", false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginWindows(),
        ),
      );
    }
    if (memory.get<SharedPreferences>().getBool("MANAGER") ?? true) {
      memory.get<SharedPreferences>().setInt("index", index);
      setState(() {
        selectedIndex = index;
      });
    } else {
      if ([0, 2, 4, 5, 7, 8, 9].contains(index)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent[700],
            content: Text(
              "Only Manager Allowed",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white),
            ),
          ),
        );
        memory.get<SharedPreferences>().setInt("index", selectedIndex);
      } else {
        memory.get<SharedPreferences>().setInt("index", index);
        setState(() {
          selectedIndex = index;
        });
      }
    }
    print("memory.get<SharedPreferences>().getInt('index')");
    print(memory.get<SharedPreferences>().getInt("index"));
    setState(() {
          selectedIndex = memory.get<SharedPreferences>().getInt("index")??1;
        });
  }

  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Builder(builder: (context) {
      return Scaffold(
        drawer: !isDesktop
            ? SizedBox(
                width: 250,
                child: SideMenuWidget(changeindex: onMenuItemSelected),
              )
            : null,
        endDrawer: !Responsive.isDesktop(context)
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SummaryWidget(),
              )
            : null,
        body: SafeArea(
          child: Row(
            children: [
              if (isDesktop)
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    child: SideMenuWidget(changeindex: onMenuItemSelected),
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
    });
  }
}
