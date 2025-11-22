import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/app_shortcuts.dart';
import 'package:lighthouse/features/buffet/presentation/view/buffet_page.dart';
import 'package:lighthouse/features/coupons/presentation/view/coupons_page.dart';
import 'package:lighthouse/features/home/presentation/view/home_screen.dart';
import 'package:lighthouse/features/packages/presentation/view/packages_page.dart';
import 'package:lighthouse/features/premium_client/presentation/view/premium_clients_page.dart';
import 'package:lighthouse/features/admin_management/presentation/view/admin_management.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/empty_screen.dart';
import 'package:lighthouse/features/main_window/presentation/widget/side_menu_bar.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary.dart';
import 'package:lighthouse/features/setting/presentation/view/settings_page.dart';
import 'package:lighthouse/features/statistics/presentation/view/statistics_page.dart';
import 'package:lighthouse/features/tasks/presentation/view/to_do_tasks.dart';
import 'package:lighthouse/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:lighthouse/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // GlobalKey to access HomeScreen's context
  final GlobalKey homeScreenKey = GlobalKey();
  // GlobalKey to access PremiumClientsPage's context
  final GlobalKey premiumClientsPageKey = GlobalKey();

  List<Widget> get selectedContentList => [
        const DashboardPage(),
        HomeScreen(key: homeScreenKey),
        const StatisticsPage(),
        PremiumClientsPage(key: premiumClientsPageKey),
        const PackagesPage(),
        const CouponsPage(),
        const BuffetPage(),
        const ToDoTasks(),
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
      // Show confirmation dialog before signing out
      _showSignOutConfirmationDialog();
      return;
    }
    if (memory.get<SharedPreferences>().getBool("MANAGER") ?? true) {
      memory.get<SharedPreferences>().setInt("index", index);
      setState(() {
        selectedIndex = index;
      });
    } else {
      if ([0, 2, 4, 5, 6, 8, 9].contains(index)) {
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
      selectedIndex = memory.get<SharedPreferences>().getInt("index") ?? 1;
    });
  }

  // Method to navigate to Home page (index 1)
  void navigateToHome() {
    onMenuItemSelected(1);
  }

  // Method to navigate to Clients page (index 3)
  void navigateToClients() {
    onMenuItemSelected(3);
  }

  // Check if currently on Home page
  bool isOnHomePage() {
    return selectedIndex == 1;
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade800],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Sign Out".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Message
                Text(
                  "Are you sure you want to sign out?".tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: darkNavy,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: grey.withOpacity(0.5), width: 2),
                          ),
                        ),
                        child: Text(
                          "Cancel".tr(),
                          style: TextStyle(
                            color: grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          memory
                              .get<SharedPreferences>()
                              .setBool("auth", false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginWindows(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Sign Out".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Builder(builder: (context) {
      return Shortcuts(
        shortcuts: getGlobalShortcuts(),
        child: Actions(
          actions: {
            NavigateToHomeIntent: CallbackAction<NavigateToHomeIntent>(
              onInvoke: (intent) {
                final mainScreenState =
                    mainScreenKey.currentState as _MainScreenState?;
                if (mainScreenState != null) {
                  mainScreenState.navigateToHome();
                }
                return null;
              },
            ),
            NavigateToClientsIntent: CallbackAction<NavigateToClientsIntent>(
              onInvoke: (intent) {
                final mainScreenState =
                    mainScreenKey.currentState as _MainScreenState?;
                if (mainScreenState != null) {
                  mainScreenState.navigateToClients();
                  // Wait for navigation and then focus on search field
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      final premiumClientsPageState =
                          mainScreenState.premiumClientsPageKey.currentState;
                      if (premiumClientsPageState != null) {
                        (premiumClientsPageState as dynamic).focusOnSearch();
                      }
                    });
                  });
                }
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
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
                          child:
                              SideMenuWidget(changeindex: onMenuItemSelected),
                        ),
                      ),
                    Expanded(
                      flex: 7,
                      child: selectedContentList[selectedIndex],
                    ),
                    if (isDesktop)
                      const Expanded(
                        flex: 3,
                        child: SummaryWidget(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
