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
import 'package:lighthouse/features/home/presentation/widget/print_invoice.dart';
import 'package:lighthouse/features/home/data/repository/start_express_session_repo.dart';
import 'package:lighthouse/features/home/data/source/remote/start_express_session_service.dart';
import 'package:lighthouse/features/home/domain/usecase/start_express_session_usecase.dart';
import 'package:lighthouse/features/home/presentation/bloc/start_express_session_bloc.dart';
import 'package:lighthouse/features/home/presentation/widget/express_sessions_dialog.dart';
import 'package:lighthouse/features/home/presentation/widget/print_express_qr.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

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

  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

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
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),

                    ],
                  ),
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
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        BlocListener<FinishExpressSessionBloc, FinishExpressSessionState>(
          listener: (context, state) {
            if (state is SuccessFinishExpressSession) {
              printInvoice(
                  false, printerAddress, printerName, state.response.body);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[800],   
                  content: Text(state.response.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenFinishExpressSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
                  internetConnectionChecker:
                      InternetConnectionChecker.createInstance(
                    addresses: [
                      AddressCheckOption(
                        uri: Uri.parse("https://www.google.com"),
                        timeout: Duration(seconds: 3),
                      ),
                      AddressCheckOption(
                        uri: Uri.parse("https://1.1.1.1"),
                        timeout: Duration(seconds: 3),
                      ),
                    ],
                  ),
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
              print(state.response);
              printInvoice(
                  true, printerAddress, printerName, state.response.body);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[800],
                  content: Text(
                    state.response.message,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              );
              memory.get<SharedPreferences>().setInt("index", 1);
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
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenFinishPremiumSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
                internetConnectionChecker:
                    InternetConnectionChecker.createInstance(
                  addresses: [
                    AddressCheckOption(
                      uri: Uri.parse("https://www.google.com"),
                      timeout: Duration(seconds: 3),
                    ),
                    AddressCheckOption(
                      uri: Uri.parse("https://1.1.1.1"),
                      timeout: Duration(seconds: 3),
                    ),
                  ],
                ),
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
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenGettingSessionById) {
              print("if (state is ForbiddenGettingSessionById) {");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
              getExpressSessionByIdService:
                  GetExpressSessionByIdService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker:
                    InternetConnectionChecker.createInstance(
                  addresses: [
                    AddressCheckOption(
                      uri: Uri.parse("https://www.google.com"),
                      timeout: Duration(seconds: 3),
                    ),
                    AddressCheckOption(
                      uri: Uri.parse("https://1.1.1.1"),
                      timeout: Duration(seconds: 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        BlocListener<GetExpressSessionBloc, GetExpressSessionState>(
          listener: (context, state) {
            if (state is SuccessGettingExpressSession) {
              expressSessionDialog(context, state.response.body, () {
                message(
                  context,
                  "end_session".tr(),
                  [
                    "end_session_message".tr(),
                  ],
                  () {
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
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenGettingExpressSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
          create: (context) => StartExpressSessionBloc(
              StartExpressSessionUsecase(
                  startExpressSessionRepo: StartExpressSessionRepo(
                      startExpressSessionService:
                          StartExpressSessionService(dio: Dio()),
                      networkConnection: NetworkConnection(
                        internetConnectionChecker:
                            InternetConnectionChecker.createInstance(
                                addresses: [
                              AddressCheckOption(
                                uri: Uri.parse("https://www.google.com"),
                                timeout: Duration(seconds: 3),
                              ),
                              AddressCheckOption(
                                uri: Uri.parse("https://1.1.1.1"),
                                timeout: Duration(seconds: 3),
                              ),
                            ]),
                      )))),
        ),
        BlocListener<StartExpressSessionBloc, StartExpressSessionState>(
          listener: (context, state) {
            if (state is SessionStarted) {
              printExpressQr(printerAddress, printerName, state.response.body);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenSessionStarted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.redAccent[700],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
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
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    HeaderWidget(title: "home".tr()),
                    const SizedBox(height: 25),
                    if (Responsive.isDesktop(context))
                      Text(
                        "home".tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    if (Responsive.isDesktop(context))
                      const SizedBox(height: 40),
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
                                  width: 140,
                                  child: Text(
                                    "express_clients".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.white),
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
                                  width: 140,
                                  child: Text(
                                    "premium_clients".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned.directional(
                          end: selectText ? 0 : null,
                          start: selectText ? null : 0,
                          textDirection: context.locale.languageCode == "ar"
                              ? ui.TextDirection.rtl
                              : ui.TextDirection.ltr,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: Colors.white),
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
                              backgroundColor: Colors.redAccent[700],
                              content: Text(state.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white)),
                            ),
                          );
                        } else if (state is ForbiddenGettingSessions) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.redAccent[700],
                              content: Text(state.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white)),
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
                                      : MediaQuery.of(context).size.height -
                                          265,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: state.response.body
                                          .activePremiumSessions.isEmpty
                                      ? const Text("There is no data")
                                      : GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: Responsive
                                                    .isDesktop(context)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1806
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            1383
                                                        ? 3
                                                        : 2)
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1000
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            750
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                520
                                                            ? 2
                                                            : 1),
                                            crossAxisSpacing: 12.0,
                                            mainAxisSpacing: 16.0,
                                            mainAxisExtent: 135,
                                          ),
                                          itemCount: state.response.body
                                              .activePremiumSessions.length,
                                          itemBuilder: (context, index) {
                                            ActivePremiumSession
                                                premiumSession = state
                                                        .response
                                                        .body
                                                        .activePremiumSessions[
                                                    index];
                                            return PremiumClientCardWidget(
                                              context: context,
                                              premiumSession: premiumSession,
                                              onTap: () => context
                                                  .read<GetPremiumSessionBloc>()
                                                  .add(
                                                    GetPremiumSession(
                                                      id: premiumSession.id,
                                                    ),
                                                  ),
                                              onPressed: () {
                                                message(
                                                  context,
                                                  "end_session".tr(),
                                                  [
                                                    "end_session_message".tr(),
                                                  ],
                                                  () {
                                                    context
                                                        .read<
                                                            FinishPremiumSessionBloc>()
                                                        .add(
                                                          FinishPreSession(
                                                              id: premiumSession
                                                                  .id),
                                                        );
                                                  },
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
                                      : MediaQuery.of(context).size.height -
                                          265,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: state.response.body
                                          .activeExpressSessions.isEmpty
                                      ? const Text("There is no data")
                                      : GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: Responsive
                                                    .isDesktop(context)
                                                ? (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1806
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            1383
                                                        ? 3
                                                        : 2)
                                                : (MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        1053
                                                    ? 4
                                                    : MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            807
                                                        ? 3
                                                        : MediaQuery.of(context)
                                                                    .size
                                                                    .width >
                                                                560
                                                            ? 2
                                                            : 1),
                                            crossAxisSpacing: 12.0,
                                            mainAxisSpacing: 16.0,
                                            mainAxisExtent: 135,
                                          ),
                                          itemCount: state.response.body
                                              .activeExpressSessions.length,
                                          itemBuilder: (context, index) {
                                            ActiveExpressSession
                                                expressSession = state
                                                        .response
                                                        .body
                                                        .activeExpressSessions[
                                                    index];
                                            return ExpressClientCardWidget(
                                              context: context,
                                              expressSession: expressSession,
                                              onTap: () => context
                                                  .read<GetExpressSessionBloc>()
                                                  .add(GetExpressSession(
                                                      id: expressSession.id)),
                                              onPressed: () {
                                                message(
                                                  context,
                                                  "end_session".tr(),
                                                  [
                                                    "end_session_message".tr(),
                                                  ],
                                                  () {
                                                    context
                                                        .read<
                                                            FinishExpressSessionBloc>()
                                                        .add(FinishExpSession(
                                                            id: expressSession
                                                                .id));
                                                  },
                                                );
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
              ),
              Positioned.directional(
                textDirection: context.locale.countryCode == 'en'
                    ? ui.TextDirection.ltr
                    : ui.TextDirection.rtl,
                bottom: 30,
                start: 30,
                child: FloatingActionButton.extended(
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
              ),
            ],
          );
        },
      ),
    );
  }
}
