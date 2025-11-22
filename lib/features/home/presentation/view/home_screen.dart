import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/features/home/presentation/widget/end_session_with_coupon_dialog.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse/features/home/data/repository/finish_express_sessions_repo.dart';
import 'package:lighthouse/features/home/data/repository/finish_premium_session_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_all_active_sessions_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_express_session_by_id_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_express_session_by_qr_code_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_premium_session_by_id_repo.dart';
import 'package:lighthouse/features/home/data/repository/get_premium_session_by_qr_code_repo.dart';
import 'package:lighthouse/features/home/data/source/remote/get_express_session_by_qr_code_service.dart';
import 'package:lighthouse/features/home/data/source/remote/get_premium_session_by_qr_code_service.dart';
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
import 'package:lighthouse/features/home/presentation/bloc/verify_qr_code_bloc.dart';
import 'package:lighthouse/features/home/data/repository/verify_qr_code_repo.dart';
import 'package:lighthouse/features/home/data/source/remote/verify_qr_code_service.dart';
import 'package:lighthouse/features/home/domain/usecase/verify_qr_code_usecase.dart';
import 'package:lighthouse/features/home/presentation/widget/end_premium_session_dialog.dart';
import 'package:lighthouse/features/home/presentation/widget/end_express_session_dialog.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart'
    as finish_model;
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
import 'package:lighthouse/features/home/presentation/widget/qr_scanner_dialog.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';
import 'package:lighthouse/common/widget/speed_dial_fab.dart';
import 'package:lighthouse/features/premium_client/data/repository/close_premium_session_by_qr_code_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/close_premium_session_by_qr_code_service.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/close_premium_session_by_qr_code_bloc.dart';
import 'package:lighthouse/features/home/data/repository/close_express_session_by_qr_code_repo.dart';
import 'package:lighthouse/features/home/data/source/remote/close_express_session_by_qr_code_service.dart';
import 'package:lighthouse/features/home/presentation/bloc/close_express_session_by_qr_code_bloc.dart';
import 'package:lighthouse/features/home/data/models/finish_express_session_response_model.dart'
    as finish_express_model;
import 'package:lighthouse/core/utils/app_shortcuts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool selectText = false;
  bool _isVerifyingQr = false;

  final contentController = TextEditingController();
  final qrScannerController = TextEditingController();
  final FocusNode _qrFocusNode = FocusNode();

  // ignore: unused_field
  final bool _isConnected = false;

  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Keep QR scanner focused and ready when Home screen is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestQrFocusIfReady();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    contentController.dispose();
    qrScannerController.dispose();
    _qrFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // When app comes back to foreground, check if we should focus QR scanner
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestQrFocusIfReady();
      });
    } else {
      // When app goes to background, unfocus QR scanner
      if (_qrFocusNode.hasFocus) {
        _qrFocusNode.unfocus();
      }
    }
  }

  bool _hasDialogOpen() {
    if (!mounted) return false;
    try {
      // Check if Navigator has any routes (dialogs) on top
      final navigator = Navigator.of(context, rootNavigator: false);
      // If we can pop, it means there's a route (dialog) on top
      return navigator.canPop();
    } catch (e) {
      return false;
    }
  }

  bool _isHomeScreenVisible() {
    if (!mounted) return false;
    try {
      final route = ModalRoute.of(context);
      if (route == null) return false;

      // Check if route is current (we're on this screen)
      if (!route.isCurrent) return false;

      // Check if there's a dialog open
      if (_hasDialogOpen()) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  void _requestQrFocusIfReady() {
    if (!mounted) return;

    // Only focus if we're in Home screen and no dialog is open
    if (_isHomeScreenVisible()) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _isHomeScreenVisible()) {
          if (!_qrFocusNode.hasFocus) {
            _qrFocusNode.requestFocus();
            print("🔹 QR Scanner field focused and ready");
          }
        }
      });
    } else {
      // If dialog is open or not in Home screen, unfocus
      if (_qrFocusNode.hasFocus) {
        _qrFocusNode.unfocus();
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check focus when dependencies change (e.g., after navigation or dialog close)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestQrFocusIfReady();
    });
  }

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
            getPremiumSessionByQrCodeRepo: GetPremiumSessionByQrCodeRepo(
              getPremiumSessionByQrCodeService:
                  GetPremiumSessionByQrCodeService(dio: Dio()),
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
            getExpressSessionByQrCodeRepo: GetExpressSessionByQrCodeRepo(
              getExpressSessionByQrCodeService:
                  GetExpressSessionByQrCodeService(dio: Dio()),
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
        BlocProvider(
          create: (context) => ClosePremiumSessionByQrCodeBloc(
            ClosePremiumSessionByQrCodeRepo(
              closePremiumSessionByQrCodeService:
                  ClosePremiumSessionByQrCodeService(dio: Dio()),
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
        BlocProvider(
          create: (context) => CloseExpressSessionByQrCodeBloc(
            CloseExpressSessionByQrCodeRepo(
              closeExpressSessionByQrCodeService:
                  CloseExpressSessionByQrCodeService(dio: Dio()),
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
        BlocProvider(
          create: (context) => VerifyQrCodeBloc(
            VerifyQrCodeUsecase(
              verifyQrCodeRepo: VerifyQrCodeRepo(
                verifyQrCodeService: VerifyQrCodeService(dio: Dio()),
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
      ],
      child: MultiBlocListener(
        listeners: [
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
                endExpressSessionDialog(context, state.response.body);
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
          BlocListener<GetPremiumSessionBloc, GetPremiumSessionState>(
            listener: (context, state) {
              if (state is SuccessGettingSessionById) {
                premiumSessionDialog(context, state.response.body, () {
                  showEndSessionWithCouponDialog(
                    context,
                    state.response.body.id,
                    (sessionId, discountCode, manualDiscountAmount,
                        manualDiscountNote) {
                      context.read<FinishPremiumSessionBloc>().add(
                            FinishPreSession(
                              id: sessionId,
                              discountCode: discountCode,
                              manualDiscountAmount: manualDiscountAmount,
                              manualDiscountNote: manualDiscountNote,
                            ),
                          );
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
          BlocListener<GetExpressSessionBloc, GetExpressSessionState>(
            listener: (context, state) {
              if (state is SuccessGettingExpressSession) {
                expressSessionDialog(context, state.response.body, () {
                  showEndSessionWithCouponDialog(
                    context,
                    state.response.body.id,
                    (sessionId, discountCode, manualDiscountAmount,
                        manualDiscountNote) {
                      context.read<FinishExpressSessionBloc>().add(
                            FinishExpSession(
                              id: sessionId,
                              discountCode: discountCode,
                              manualDiscountAmount: manualDiscountAmount,
                              manualDiscountNote: manualDiscountNote,
                            ),
                          );
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
          BlocListener<StartExpressSessionBloc, StartExpressSessionState>(
            listener: (context, state) {
              if (state is SessionStarted) {
                printExpressQr(
                    printerAddress, printerName, state.response.body);
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
          ),
          BlocListener<ClosePremiumSessionByQrCodeBloc,
              ClosePremiumSessionByQrCodeState>(
            listener: (context, state) {
              if (state is SuccessClosingPremiumSessionByQrCode) {
                try {
                  final bodyMap = state.response.body.toMap();
                  final finishBody = finish_model.Body.fromMap(bodyMap);
                  printInvoice(true, printerAddress, printerName, finishBody);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[800],
                      content: Text(
                        state.response.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      endSessionDialog(context, finishBody);
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(
                        "Error: $e",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }
              } else if (state is ExceptionClosingPremiumSessionByQrCode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is ForbiddenClosingPremiumSessionByQrCode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
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
          BlocListener<CloseExpressSessionByQrCodeBloc,
              CloseExpressSessionByQrCodeState>(
            listener: (context, state) {
              if (state is SuccessClosingExpressSessionByQrCode) {
                try {
                  final bodyMap = state.response.body.toMap();
                  final finishBody = finish_express_model.Body.fromMap(bodyMap);
                  printExpressQr(printerAddress, printerName, finishBody);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green[800],
                      content: Text(
                        state.response.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
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
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      endExpressSessionDialog(context, finishBody);
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(
                        "Error: $e",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }
              } else if (state is ExceptionClosingExpressSessionByQrCode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is ForbiddenClosingExpressSessionByQrCode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
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
          BlocListener<VerifyQrCodeBloc, VerifyQrCodeState>(
            listener: (context, state) {
              if (state is VerifyQrCodeLoading) {
                setState(() {
                  _isVerifyingQr = true;
                });
              } else if (state is VerifyQrCodeSuccess) {
                setState(() {
                  _isVerifyingQr = false;
                });
                final qrCodeType = state.response.body.qrCodeType;
                final qrCode = state.response.body.qrCode;

                if (qrCodeType == "Premium_User") {
                  // Get premium session
                  context.read<GetPremiumSessionBloc>().add(
                        GetPremiumSessionByQrCode(qrCode: qrCode),
                      );
                } else if (qrCodeType == "Session") {
                  // Get express session
                  context.read<GetExpressSessionBloc>().add(
                        GetExpressSessionByQrCode(qrCode: qrCode),
                      );
                }
              } else if (state is VerifyQrCodeException) {
                setState(() {
                  _isVerifyingQr = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is VerifyQrCodeForbidden) {
                setState(() {
                  _isVerifyingQr = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    content: Text(
                      state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
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
        ],
        child: Builder(
          builder: (context) {
            return Shortcuts(
              shortcuts: getHomeScreenShortcuts(),
              child: Actions(
                actions: {
                  StartExpressSessionIntent:
                      CallbackAction<StartExpressSessionIntent>(
                    onInvoke: (intent) {
                      startExpressSession(context, (fullName) {
                        context
                            .read<StartExpressSessionBloc>()
                            .add(StartExpressSession(fullName: fullName));
                      });
                      return null;
                    },
                  ),
                },
                child: FocusScope(
                  autofocus: false,
                  child: Stack(
                    children: [
                      // Loading overlay when verifying QR code
                      if (_isVerifyingQr)
                        Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(orange),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Verifying QR Code...".tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: navy,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      // Hidden QR Scanner Field - Always ready to read QR codes
                      Positioned(
                        left: -1000,
                        top: -1000,
                        child: SizedBox(
                          width: 1,
                          height: 1,
                          child: TextField(
                            controller: qrScannerController,
                            focusNode: _qrFocusNode,
                            autofocus: true,
                            style: const TextStyle(
                                fontSize: 1, color: Colors.transparent),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                            ),
                            onChanged: (value) {
                              // Auto-submit when QR code is detected (usually ends with newline or Enter)
                              if (value.isNotEmpty) {
                                // Check if QR code is complete (ends with newline or Enter key)
                                if (value.contains('\n') ||
                                    value.contains('\r')) {
                                  final cleanedQrCode = value
                                      .trim()
                                      .replaceAll('\n', '')
                                      .replaceAll('\r', '');
                                  if (cleanedQrCode.isNotEmpty) {
                                    print(
                                        "🔹 QR Code detected in onChanged: $cleanedQrCode");
                                    qrScannerController.clear();
                                    context.read<VerifyQrCodeBloc>().add(
                                          VerifyQrCode(qrCode: cleanedQrCode),
                                        );
                                    // Re-focus after processing only if still in Home screen
                                    Future.delayed(
                                        const Duration(milliseconds: 300), () {
                                      if (mounted && _isHomeScreenVisible()) {
                                        _requestQrFocusIfReady();
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            onSubmitted: (qrCode) {
                              if (qrCode.isNotEmpty) {
                                final cleanedQrCode = qrCode
                                    .trim()
                                    .replaceAll('\n', '')
                                    .replaceAll('\r', '');
                                print("🔹 QR Code submitted: $cleanedQrCode");
                                qrScannerController.clear();
                                context.read<VerifyQrCodeBloc>().add(
                                      VerifyQrCode(qrCode: cleanedQrCode),
                                    );
                              }
                              // Re-focus after submission only if still in Home screen
                              Future.delayed(const Duration(milliseconds: 200),
                                  () {
                                if (mounted && _isHomeScreenVisible()) {
                                  _requestQrFocusIfReady();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            Responsive.isMobile(context) ? 16 : 24),
                        child: Column(
                          children: [
                            // Desktop Title
                            if (Responsive.isDesktop(context))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            orange.withOpacity(0.25),
                                            orange.withOpacity(0.15),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: orange.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.home_rounded,
                                        color: orange,
                                        size: 32,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "home".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Mobile Header
                            if (Responsive.isMobile(context))
                              HeaderWidget(title: "home".tr()),
                            if (Responsive.isMobile(context))
                              const SizedBox(height: 24),
                            // Toggle between Premium and Express
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final containerWidth = constraints.maxWidth;
                                final halfWidth = containerWidth / 2;
                                final isRTL =
                                    context.locale.languageCode != 'en';

                                // Row order: Express (first), Premium (second)
                                // In LTR: Express on left (0), Premium on right (halfWidth)
                                // In RTL: Express on right (0), Premium on left (halfWidth)
                                // selectText = true means Premium selected
                                // selectText = false means Express selected

                                double? leftPosition;
                                double? rightPosition;

                                if (isRTL) {
                                  // RTL: Express on right, Premium on left
                                  if (selectText) {
                                    // Premium selected - on left
                                    leftPosition = 0.0;
                                    rightPosition = null;
                                  } else {
                                    // Express selected - on right
                                    leftPosition = null;
                                    rightPosition = 0.0;
                                  }
                                } else {
                                  // LTR: Express on left, Premium on right
                                  if (selectText) {
                                    // Premium selected - on right
                                    leftPosition = halfWidth - 1.5;
                                    rightPosition = null;
                                  } else {
                                    // Express selected - on left
                                    leftPosition = -0.5;
                                    rightPosition = null;
                                  }
                                }

                                return Container(
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A2F4A),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectText = false;
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.zero,
                                                child: Text(
                                                  "express_clients".tr(),
                                                  style: TextStyle(
                                                    color: !selectText
                                                        ? Colors.white
                                                        : Colors.white
                                                            .withOpacity(0.6),
                                                    fontSize: 15,
                                                    fontWeight: !selectText
                                                        ? FontWeight.w700
                                                        : FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectText = true;
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.zero,
                                                child: Text(
                                                  "premium_clients".tr(),
                                                  style: TextStyle(
                                                    color: selectText
                                                        ? Colors.white
                                                        : Colors.white
                                                            .withOpacity(0.6),
                                                    fontSize: 15,
                                                    fontWeight: selectText
                                                        ? FontWeight.w700
                                                        : FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      AnimatedPositioned(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                        left: leftPosition,
                                        right: rightPosition,
                                        top: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: halfWidth,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                orange.withOpacity(0.3),
                                                orange.withOpacity(0.2),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: orange.withOpacity(0.4),
                                              width: 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: orange.withOpacity(0.2),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            selectText
                                                ? "premium_clients".tr()
                                                : "express_clients".tr(),
                                            style: const TextStyle(
                                              color: orange,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Expanded(
                              child: BlocConsumer<GetAllActiveSessionsBloc,
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
                                                ?.copyWith(
                                                    color: Colors.white)),
                                      ),
                                    );
                                  } else if (state
                                      is ForbiddenGettingSessions) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.redAccent[700],
                                        content: Text(state.message,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Colors.white)),
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginWindows(),
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is SuccessGettingSessions) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(height: 24),
                                        if (selectText)
                                          Expanded(
                                            child: state
                                                    .response
                                                    .body
                                                    .activePremiumSessions
                                                    .isEmpty
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.inbox_outlined,
                                                          size: 64,
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          "No premium sessions"
                                                              .tr(),
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.6),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: Responsive
                                                              .isDesktop(
                                                                  context)
                                                          ? (MediaQuery.of(
                                                                          context)
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
                                                          : (MediaQuery.of(
                                                                          context)
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
                                                      crossAxisSpacing: 16.0,
                                                      mainAxisSpacing: 16.0,
                                                      mainAxisExtent: 160,
                                                    ),
                                                    itemCount: state
                                                        .response
                                                        .body
                                                        .activePremiumSessions
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      ActivePremiumSession
                                                          premiumSession = state
                                                                  .response
                                                                  .body
                                                                  .activePremiumSessions[
                                                              index];
                                                      return PremiumClientCardWidget(
                                                        context: context,
                                                        premiumSession:
                                                            premiumSession,
                                                        onTap: () => context
                                                            .read<
                                                                GetPremiumSessionBloc>()
                                                            .add(
                                                              GetPremiumSession(
                                                                id: premiumSession
                                                                    .id,
                                                              ),
                                                            ),
                                                        onPressed: () {
                                                          showEndSessionWithCouponDialog(
                                                            context,
                                                            premiumSession.id,
                                                            (sessionId,
                                                                discountCode,
                                                                manualDiscountAmount,
                                                                manualDiscountNote) {
                                                              context
                                                                  .read<
                                                                      FinishPremiumSessionBloc>()
                                                                  .add(
                                                                    FinishPreSession(
                                                                      id: sessionId,
                                                                      discountCode:
                                                                          discountCode,
                                                                      manualDiscountAmount:
                                                                          manualDiscountAmount,
                                                                      manualDiscountNote:
                                                                          manualDiscountNote,
                                                                    ),
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
                                          Expanded(
                                            child: state
                                                    .response
                                                    .body
                                                    .activeExpressSessions
                                                    .isEmpty
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.inbox_outlined,
                                                          size: 64,
                                                          color: Colors.white
                                                              .withOpacity(0.3),
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          "No express sessions"
                                                              .tr(),
                                                          style: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.6),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : GridView.builder(
                                                    gridDelegate:
                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: Responsive
                                                              .isDesktop(
                                                                  context)
                                                          ? (MediaQuery.of(
                                                                          context)
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
                                                          : (MediaQuery.of(
                                                                          context)
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
                                                      crossAxisSpacing: 16.0,
                                                      mainAxisSpacing: 16.0,
                                                      mainAxisExtent: 160,
                                                    ),
                                                    itemCount: state
                                                        .response
                                                        .body
                                                        .activeExpressSessions
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      ActiveExpressSession
                                                          expressSession = state
                                                                  .response
                                                                  .body
                                                                  .activeExpressSessions[
                                                              index];
                                                      return ExpressClientCardWidget(
                                                        context: context,
                                                        expressSession:
                                                            expressSession,
                                                        onTap: () => context
                                                            .read<
                                                                GetExpressSessionBloc>()
                                                            .add(GetExpressSession(
                                                                id: expressSession
                                                                    .id)),
                                                        onPressed: () {
                                                          showEndSessionWithCouponDialog(
                                                            context,
                                                            expressSession.id,
                                                            (sessionId,
                                                                discountCode,
                                                                manualDiscountAmount,
                                                                manualDiscountNote) {
                                                              context
                                                                  .read<
                                                                      FinishExpressSessionBloc>()
                                                                  .add(
                                                                      FinishExpSession(
                                                                    id: sessionId,
                                                                    discountCode:
                                                                        discountCode,
                                                                    manualDiscountAmount:
                                                                        manualDiscountAmount,
                                                                    manualDiscountNote:
                                                                        manualDiscountNote,
                                                                  ));
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
                                    return Center(
                                      child: const CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned.directional(
                        textDirection: context.locale.countryCode == 'en'
                            ? ui.TextDirection.ltr
                            : ui.TextDirection.rtl,
                        bottom: 30,
                        start: context.locale.languageCode == 'en' ? 30 : null,
                        end: context.locale.languageCode == 'en' ? null : 30,
                        child: SpeedDialFab(
                          icon: Icons.more_vert,
                          backgroundColor: lightGrey,
                          iconColor: orange,
                          tooltip: 'quick'.tr(),
                          children: [
                            SpeedDialChild(
                              icon: Icons.rocket_launch,
                              label: 'add_session'.tr(),
                              backgroundColor: orange,
                              iconColor: Colors.white,
                              onPressed: () {
                                startExpressSession(context, (fullName) {
                                  context.read<StartExpressSessionBloc>().add(
                                      StartExpressSession(fullName: fullName));
                                });
                              },
                            ),
                            SpeedDialChild(
                              icon: Icons.qr_code,
                              label: 'get_premium_session_by_qr'.tr(),
                              backgroundColor: orange,
                              iconColor: Colors.white,
                              onPressed: () {
                                showQrScannerDialog(
                                  context,
                                  'get_premium_session'.tr(),
                                  'scan_qr_code_to_get_premium_session_details'
                                      .tr(),
                                  (qrCode) {
                                    context.read<GetPremiumSessionBloc>().add(
                                        GetPremiumSessionByQrCode(
                                            qrCode: qrCode));
                                  },
                                );
                              },
                            ),
                            SpeedDialChild(
                              icon: Icons.qr_code,
                              label: 'get_express_session_by_qr'.tr(),
                              backgroundColor: orange,
                              iconColor: Colors.white,
                              onPressed: () {
                                showQrScannerDialog(
                                  context,
                                  'get_express_session'.tr(),
                                  'scan_qr_code_to_get_express_session_details'
                                      .tr(),
                                  (qrCode) {
                                    context.read<GetExpressSessionBloc>().add(
                                        GetExpressSessionByQrCode(
                                            qrCode: qrCode));
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
