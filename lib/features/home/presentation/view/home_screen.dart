import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/common/widget/message_dialog.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse/features/home/data/repository/finish_express_sessions_repo.dart';
import 'package:lighthouse/features/home/data/repository/finish_premium_session_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_all_active_sessions_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_express_session_by_id_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_premium_session_by_id_repo.dart';
import 'package:lighthouse/features/home/data/source/remote/finish_express_sessions_service.dart';
import 'package:lighthouse/features/home/data/source/remote/finish_premium_session_service.dart';
import 'package:lighthouse/features/home/data/source/remote/get_all_active_sessions_service.dart';
import 'package:lighthouse/features/home/data/source/remote/get_express_session_by_id_service.dart';
import 'package:lighthouse/features/home/data/source/remote/get_premium_session_by_id_service.dart';
import 'package:lighthouse/features/home/domain/usecase/finish_express_session_usecase.dart';
import 'package:lighthouse/features/home/domain/usecase/finish_premium_session_usecase.dart';
import 'package:lighthouse/features/home/domain/usecase/get_all_active_sessions_usecase.dart';
import 'package:lighthouse/features/home/presentation/bloc/finish_express_session_bloc.dart';
import 'package:lighthouse/features/home/presentation/bloc/finish_premium_session_bloc.dart';
import 'package:lighthouse/features/home/presentation/bloc/get_all_active_sessions_bloc.dart';
import 'package:lighthouse/features/home/presentation/bloc/get_express_session_bloc.dart';
import 'package:lighthouse/features/home/presentation/bloc/get_premium_session_bloc.dart';
import 'package:lighthouse/features/home/presentation/widget/end_premium_session_dialog.dart';
import 'package:lighthouse/features/home/presentation/widget/express_client_card_widget.dart';
import 'package:lighthouse/features/home/presentation/widget/express_session_dialog.dart';
import 'package:lighthouse/features/home/presentation/widget/premium_client_card_widget.dart';
import 'package:lighthouse/features/home/presentation/widget/premium_session_dialog.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool selectText = true;

  final contentController = TextEditingController();

  // ignore: unused_field
  final bool _isConnected = false;



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllActiveSessionsBloc(
            GetAllActiveSessionsUsecase(
              getAllActiveSessionsRepo: GetAllActiveSessionsRepo(
                getAllActiveSessionsService: GetAllActiveSessionsService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
              ),
            ),
          )..add(GetActiveSessions()),
        ),
        BlocProvider(
          create: (context) => FinishExpressSessionBloc(
            FinishExpressSessionUsecase(
              finishExpressSessionsRepo: FinishExpressSessionsRepo(
                finishExpressSessionsService:
                    FinishExpressSessionsService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
              ),
            ),
          ),
        ),
        BlocListener<FinishExpressSessionBloc, FinishExpressSessionState>(
          listener: (context, state) {
            if (state is SuccessFinishExpressSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[800],
                  content: Text(state.response.message),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            } else if (state is ExceptionFinishExpressSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
                ),
              );
            } else if (state is ForbiddenFinishExpressSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
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
        ),
        BlocProvider(
          create: (context) => FinishPremiumSessionBloc(
            FinishPremiumSessionUsecase(
              finishPremiumSessionRepo: FinishPremiumSessionRepo(
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
                finishPremiumSessionService:
                    FinishPremiumSessionService(dio: Dio()),
              ),
            ),
          ),
        ),
        BlocListener<FinishPremiumSessionBloc, FinishPremiumSessionState>(
          listener: (context, state) {
            if (state is SuccessFinishPremiumSession) {
              storage.get<SharedPreferences>().setInt("index", 1);
              
             
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[800],
                  content: Text(state.response.message),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
              endSessionDialog(context, state.response.body);
            } else if (state is ExceptionFinishPremiumSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
                ),
              );
            } else if (state is ForbiddenFinishPremiumSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
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
        ),
        BlocProvider(
          create: (context) => GetPremiumSessionBloc(
            GetPremiumSessionByIdRepo(
              getPremiumSessionByIdService:
                  GetPremiumSessionByIdService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker.instance,
              ),
            ),
          ),
        ),
        BlocListener<GetPremiumSessionBloc, GetPremiumSessionState>(
          listener: (context, state) {
            if (state is SuccessGettingSessionById) {
              premiumSessionDialog(context, state.response.body, () {
                message(
                  context,
                  "end_session".tr(),
                  [
                    "end_session_message".tr(),
                  ],
                  () {
                    context.read<FinishPremiumSessionBloc>().add(
                          FinishPreSession(id: state.response.body.id),
                        );
                        Navigator.of(context).pop();
                  },
                );
              });
            } else if (state is ExceptionGettingSessionById) {
              print("if (state is ExceptionGettingSessionById) {");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
                ),
              );
            } else if (state is ForbiddenGettingSessionById) {
              print("if (state is ForbiddenGettingSessionById) {");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message),
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
        ),
        BlocProvider(
  create: (context) => GetExpressSessionBloc(
    GetExpressSessionByIdRepo(
      getExpressSessionByIdService: GetExpressSessionByIdService(dio: Dio()),
      networkConnection: NetworkConnection(
        internetConnectionChecker: InternetConnectionChecker.instance,
      ),
    ),
  ),
),
BlocListener<GetExpressSessionBloc, GetExpressSessionState>(
  listener: (context, state) {
    if (state is SuccessGettingExpressSession) {
      // عند نجاح جلب البيانات يمكنك عرض الديالوج أو أي إجراء آخر
      expressSessionDialog(context, state.response.body, () {
        message(
          context,
          "end_session".tr(),
          [
            "end_session_message".tr(),
          ],
          () {
            // مثال على إنهاء الجلسة (يفترض وجود بلوك FinishExpressSessionBloc)
            context.read<FinishExpressSessionBloc>().add(
                  FinishExpSession(id: state.response.body.id),
                );
            Navigator.of(context).pop();
          },
        );
      });
    } else if (state is ExceptionGettingExpressSession) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[800],
          content: Text(state.message),
        ),
      );
    } else if (state is ForbiddenGettingExpressSession) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[800],
          content: Text(state.message),
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
      child: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                HeaderWidget(title: "home".tr()),
                const SizedBox(height: 25),
                if (Responsive.isDesktop(context))
                  Text(
                    "home".tr(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                if (Responsive.isDesktop(context)) const SizedBox(height: 40),
                Stack(
                  children: [
                    Container(
                      height: 48,
                      width: 400,
                      decoration: BoxDecoration(
                        color: navy,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectText = false;
                                print("selectText");
                                print(selectText);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 120,
                              child: Text(
                                "express_clients".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectText = true;
                                print("selectText");
                                print(selectText);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 120,
                              child: Text(
                                "premium_clients".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: selectText ? 0 : null,
                      right: selectText ? null : 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 48,
                        width: 200,
                        decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          selectText
                              ? "premium_clients".tr()
                              : "express_clients".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                BlocConsumer<GetAllActiveSessionsBloc,
                    GetAllActiveSessionsState>(
                  listener: (context, state) {
                    if (state is ExceptionGettingSessions) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[800],
                          content: Text(state.message),
                        ),
                      );
                    } else if (state is ForbiddenGettingSessions) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red[800],
                          content: Text(state.message),
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
                  builder: (context, state) {
                    if (state is SuccessGettingSessions) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          if (selectText)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: navy,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: !Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 225
                                  : MediaQuery.of(context).size.height - 265,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: state.response.body.activePremiumSessions
                                      .isEmpty
                                  ? const Text("There is no data")
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            Responsive.isDesktop(context)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1620
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            1250
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                480
                                                            ? 2
                                                            : 1)
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1000
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            730
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                510
                                                            ? 2
                                                            : 1),
                                        crossAxisSpacing: 12.0,
                                        mainAxisSpacing: 16.0,
                                        mainAxisExtent: 135,
                                      ),
                                      itemCount: state.response.body
                                          .activePremiumSessions.length,
                                      itemBuilder: (context, index) {
                                        ActivePremiumSession premiumSession =
                                            state.response.body
                                                .activePremiumSessions[index];
                                        return PremiumClientCardWidget(
                                          context: context,
                                          premiumSession: premiumSession,
                                          onPressed: () {
                                            context
                                                .read<GetPremiumSessionBloc>()
                                                .add(
                                                  GetPremiumSession(
                                                    id: premiumSession.id,
                                                  ),
                                                );
                                            // todo
                                            // todo
                                            // todo
                                            // todo
                                            // todo
                                            // todo
                                          },
                                        );
                                      },
                                    ),
                            ),
                          if (!selectText)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: navy,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              height: !Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.height - 225
                                  : MediaQuery.of(context).size.height - 265,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: state.response.body.activeExpressSessions
                                      .isEmpty
                                  ? const Text("There is no data")
                                  : GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            Responsive.isDesktop(context)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1620
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            1250
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                480
                                                            ? 2
                                                            : 1)
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1000
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            730
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                510
                                                            ? 2
                                                            : 1),
                                        crossAxisSpacing: 12.0,
                                        mainAxisSpacing: 16.0,
                                        mainAxisExtent: 135,
                                      ),
                                      itemCount: state.response.body
                                          .activeExpressSessions.length,
                                      itemBuilder: (context, index) {
                                        ActiveExpressSession expressSession =
                                            state.response.body
                                                .activeExpressSessions[index];
                                        return ExpressClientCardWidget(
                                          context: context,
                                          expressSession: expressSession,
                                          onPressed: () {
                                           context.read<GetExpressSessionBloc>().add(GetExpressSession(id: expressSession.id));
                                          },
                                        );
                                      },
                                    ),
                            ),
                        ],
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
