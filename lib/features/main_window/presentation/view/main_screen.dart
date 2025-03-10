import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/buffet/presentation/view/buffet_page.dart';
import 'package:lighthouse/features/home/presentation/view/home_screen.dart';
import 'package:lighthouse/features/main_window/data/repository/start_express_session_repo.dart';
import 'package:lighthouse/features/main_window/data/sources/start_express_session_service.dart';
import 'package:lighthouse/features/main_window/domain/usecase/start_express_session_usecase.dart';
import 'package:lighthouse/features/main_window/presentation/bloc/start_express_session_bloc.dart';
import 'package:lighthouse/features/main_window/presentation/widget/express_sessions_dialog.dart';
import 'package:lighthouse/features/main_window/presentation/widget/print_express_qr.dart';
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
    } else {
      memory.get<SharedPreferences>().setInt("index", index);
      setState(() {
        selectedIndex = index;
      });
    }
  }
 
   late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StartExpressSessionBloc(
              StartExpressSessionUsecase(
                  startExpressSessionRepo: StartExpressSessionRepo(
                      startExpressSessionService:
                          StartExpressSessionService(dio: Dio()),
                      networkConnection: NetworkConnection(
                          internetConnectionChecker:
                              InternetConnectionChecker.instance)))),
        ),
        BlocListener<StartExpressSessionBloc, StartExpressSessionState>(
          listener: (context, state) {
            if (state is SessionStarted) {
              printExpressQr(printerAddress,printerName,state.response.body); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response.message),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            } else if (state is ExceptionSessionStarted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenSessionStarted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginWindows(),
                ),
              );
            }
          },
        )
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          floatingActionButtonLocation: isDesktop
              ? FloatingActionButtonLocation.startFloat
              : FloatingActionButtonLocation.endFloat,
          floatingActionButton: Responsive.isMobile(context)? null: FloatingActionButton.extended(
            onPressed: () {
              startExpressSession(context, (fullName) {
                context
                    .read<StartExpressSessionBloc>()
                    .add(StartExpressSession(fullName: fullName));
              });
            },
            icon: const Icon(
              Icons.rocket_launch,
              color: orange,
            ),
            label: Text(
              'add_session'.tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
            backgroundColor: lightGrey,
          ),
          drawer: !isDesktop
              ? SizedBox(
                  width: 250,
                  child: SideMenuWidget(changeindex: onMenuItemSelected),
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
      }),
    );
  }
}
