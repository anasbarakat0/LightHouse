import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart'
    as finish_model;
import 'package:lighthouse/features/home/presentation/widget/end_premium_session_dialog.dart';
import 'package:lighthouse/features/home/presentation/widget/print_invoice.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/add_premium_client_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_premium_clients_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/close_premium_session_by_qr_code_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_users_by_name_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/start_premium_session_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/add_premium_client_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/close_premium_session_by_qr_code_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_premium_clients_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_users_by_name_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/start_premium_session_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/add_premium_client_usecase.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/get_premium_clients_usecase.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/start_premium_session_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/add_premium_client_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/close_premium_session_by_qr_code_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_premium_clients_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_users_by_name_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/start_premium_session_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/view/client_profile.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/premium_client_dialog.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/print_function.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/search_field.dart';

class PremiumClientsPage extends StatefulWidget {
  const PremiumClientsPage({super.key});

  @override
  State<PremiumClientsPage> createState() => _PremiumClientsPageState();
}

class _PremiumClientsPageState extends State<PremiumClientsPage> {
  TextEditingController search = TextEditingController();
  TextEditingController qrScannerController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  String searchQuery = '';
  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";
  List<Body> clients = [];

  // Method to focus on search field
  void focusOnSearch() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    search.dispose();
    qrScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddPremiumClientBloc(
            AddPremiumClientUsecase(
              addPremiumClientRepo: AddPremiumClientRepo(
                AddPremiumClientService(
                  dio: Dio(),
                ),
                NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetPremiumClientsBloc(
            GetPremiumClientsUsecase(
              getAllPremiumClientsRepo: GetAllPremiumClientsRepo(
                getAllPremiumClientsService: GetAllPremiumClientsService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          )..add(
              GetPremiumClients(
                page: 1,
                size: 10000,
              ),
            ),
        ),
        BlocProvider(
          create: (context) => StartPremiumSessionBloc(
            StartPremiumSessionUsecase(
              startPremiumSessionRepo: StartPremiumSessionRepo(
                startPremiumSessionService:
                    StartPremiumSessionService(dio: Dio()),
                networkConnection: NetworkConnection.createDefault(),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => GetUsersByNameBloc(
            GetUsersByNameRepo(
              getUsersByNameService: GetUsersByNameService(dio: Dio()),
              networkConnection: NetworkConnection.createDefault(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ClosePremiumSessionByQrCodeBloc(
            ClosePremiumSessionByQrCodeRepo(
              closePremiumSessionByQrCodeService:
                  ClosePremiumSessionByQrCodeService(dio: Dio()),
              networkConnection: NetworkConnection.createDefault(),
            ),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<StartPremiumSessionBloc, StartPremiumSessionState>(
            listener: (context, state) {
              if (state is SuccessStartSession) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(state.response,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const MainScreen(),
                //   ),
                // );
              } else if (state is ExceptionStartSession) {
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
              } else if (state is ForbiddenStartSession) {
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
          BlocListener<GetUsersByNameBloc, GetUsersByNameState>(
            listener: (context, state) {
              if (state is SuccessGettingUsersByName) {
                print("نجح البحث، البيانات: ${state.response.body}");
              } else if (state is ExceptionGettingUsersByName) {
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
              } else if (state is ForbiddenGettingUsersByName) {
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
              } else if (state is NoUsersFound) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
              }
            },
          ),
          BlocListener<ClosePremiumSessionByQrCodeBloc,
              ClosePremiumSessionByQrCodeState>(
            listener: (context, state) {
              if (state is SuccessClosingPremiumSessionByQrCode) {
                print("✅ SuccessClosingPremiumSessionByQrCode");
                print("Response body: ${state.response.body}");
                try {
                  // Convert Body from close_premium_session to finish_premium_session format
                  final bodyMap = state.response.body.toMap();
                  print("Body map: $bodyMap");
                  final finishBody = finish_model.Body.fromMap(bodyMap);
                  print("✅ Converted Body successfully: $finishBody");
                  // Print first invoice (original)
                  print("🖨️ Starting to print first invoice...");
                  printDetailedInvoice(
                      true, printerAddress, printerName, finishBody);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        state.response.message,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  );
                  // Clear the QR scanner field after successful scan
                  qrScannerController.clear();
                  // Show the same dialog as finish premium session
                  // Use Future.delayed to ensure dialog shows after SnackBar
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      print(
                          "🔹 Showing endSessionDialog with context: $context");
                      endSessionDialog(context, finishBody);
                    } else {
                      print("❌ Context is not mounted");
                    }
                  });
                } catch (e, stackTrace) {
                  print("❌ Error in SuccessClosingPremiumSessionByQrCode: $e");
                  print("Stack trace: $stackTrace");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent[700],
                      content: Text(
                        "Error showing dialog: $e",
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
                    content: Text(state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white)),
                  ),
                );
                // Clear the QR scanner field after error
                qrScannerController.clear();
              } else if (state is ForbiddenClosingPremiumSessionByQrCode) {
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
        ],
        child: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                HeaderWidget(title: "clients".tr()),
                const SizedBox(height: 25),
                if (Responsive.isDesktop(context))
                  Text(
                    "clients".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: navy),
                  ),
                if (Responsive.isDesktop(context)) const SizedBox(height: 40),
                // QR Scanner Field for closing premium sessions
                // SizedBox(
                //   height: 65,
                //   child: TextField(
                //     controller: qrScannerController,
                //     textAlignVertical: TextAlignVertical.top,
                //     autofocus: false,
                //     decoration: InputDecoration(
                //       suffixIcon: Icon(
                //         Icons.qr_code_scanner,
                //         color: orange,
                //       ),
                //       filled: true,
                //       fillColor: navy,
                //       labelText: "Scan QR Code to Close Session",
                //       labelStyle: Theme.of(context)
                //           .textTheme
                //           .labelMedium
                //           ?.copyWith(color: Colors.white),
                //       contentPadding: const EdgeInsets.symmetric(
                //           vertical: 30.0, horizontal: 20),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: orange, width: 1.0),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       focusColor: darkNavy,
                //       disabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: Colors.grey),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderSide: const BorderSide(color: darkNavy),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       floatingLabelBehavior: FloatingLabelBehavior.never,
                //     ),
                //     style: Theme.of(context)
                //         .textTheme
                //         .bodyMedium
                //         ?.copyWith(color: Colors.white),
                //     onSubmitted: (qrCode) {
                //       if (qrCode.isNotEmpty) {
                //         // Trim whitespace and newlines that QR scanner might add
                //         final cleanedQrCode = qrCode.trim();
                //         print(
                //             "🔹 Scanned QR Code: '$cleanedQrCode' (length: ${cleanedQrCode.length})");
                //         context.read<ClosePremiumSessionByQrCodeBloc>().add(
                //             ClosePremiumSessionByQrCode(qrCode: cleanedQrCode));
                //       }
                //     },
                //   ),
                // ),
                // const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchField(
                            controller: search,
                            focusNode: searchFocusNode,
                            onChanged: (value) =>
                                setState(() => searchQuery = value),
                            onSubmitted: (value) =>
                                setState(() => searchQuery = value),
                          ),
                        ),
                        const SizedBox(width: 12),
                        BlocConsumer<AddPremiumClientBloc,
                            AddPremiumClientState>(
                          listener: (context, state) {
                            if (state is ExceptionAddedClient) {
                              print(state.message);
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
                            } else if (state is ClientAdded) {
                              print(state.response);
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
                              context
                                  .read<GetPremiumClientsBloc>()
                                  .add(GetPremiumClients(page: 1, size: 20));
                            } else if (state is ForbiddenAdded) {
                              print(state.message);
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
                                      builder: (context) =>
                                          const LoginWindows()));
                            } else {
                              print(state.runtimeType);
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 1,
                                backgroundColor: yellow,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                void client(PremiumClient client) {
                                  print('client');
                                  print(client.toMap());
                                  context
                                      .read<AddPremiumClientBloc>()
                                      .add(AddPremiumClient(client: client));
                                }

                                AddPremiumClientDialog(context, client);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(14),
                                child: Icon(
                                  Icons.person_add_sharp,
                                  color: navy,
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<GetPremiumClientsBloc, GetPremiumClientsState>(
                  builder: (context, state) {
                    if (state is ExceptionFetchingClients) {
                      return Center(
                        child: Text(
                          state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      );
                    } else if (state is NoClientsToShow) {
                      return Center(
                        child: Text(
                          state.message,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      );
                    } else if (state is SuccessFetchingClients) {
                      final query = searchQuery.trim().toLowerCase();
                      final filteredList = query.isEmpty
                          ? state.responseModel.body
                          : state.responseModel.body.where((c) {
                              final fullName =
                                  '${c.firstName} ${c.lastName}'.toLowerCase();
                              final matchesName = c.firstName
                                      .toLowerCase()
                                      .contains(query) ||
                                  c.lastName.toLowerCase().contains(query) ||
                                  fullName.contains(query);
                              final matchesPhone = (c.phoneNumber ?? '')
                                  .toLowerCase()
                                  .contains(query);
                              return matchesName || matchesPhone;
                            }).toList();
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 0),
                              child: Text(
                                query.isEmpty
                                    ? '${state.responseModel.pageable.total} clients'
                                    : '${filteredList.length} / ${state.responseModel.pageable.total} clients',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: filteredList.length,
                                  itemBuilder: (context, index) {
                                    final client = filteredList[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ClientProfile(
                                                            client: client)));
                                          },
                                          minTileHeight: 56,
                                          leading: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: grey,
                                            child: client.gender == "MALE"
                                                ? const Icon(
                                                    Icons.person,
                                                    color: lightGrey,
                                                    size: 35,
                                                  )
                                                : SvgPicture.asset(
                                                    "assets/svg/woman.svg",
                                                    width: 25,
                                                    color: lightGrey,
                                                  ),
                                          ),
                                          title: Text(
                                            "${client.firstName.replaceFirst(client.firstName[0], client.firstName[0].toUpperCase())} ${client.lastName.replaceFirst(client.lastName[0], client.lastName[0].toUpperCase())}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(color: navy),
                                          ),
                                          subtitle: Text(
                                            client.phoneNumber ?? 'N/A',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: grey,
                                                ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Tooltip(
                                                message: 'without_qr_code'.tr(),
                                                decoration: BoxDecoration(
                                                  color: lightGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: SizedBox(
                                                  width: 60,
                                                  height: 60,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              StartPremiumSessionBloc>()
                                                          .add(StartPreSession(
                                                              id: client.uuid));
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      backgroundColor:
                                                          lightGrey,
                                                      foregroundColor:
                                                          lightGrey,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12,
                                                          vertical: 12),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.print_disabled,
                                                      size: 22,
                                                      color: grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              FloatingActionButton.extended(
                                                heroTag:
                                                    'fab_add_session_${client.uuid}',
                                                elevation: 1,
                                                backgroundColor: Colors.white,
                                                foregroundColor: lightGrey,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  side: BorderSide(
                                                      color: yellow, width: 1),
                                                ),
                                                icon: const Icon(
                                                  Icons.login,
                                                  color: navy,
                                                ),
                                                onPressed: () async {
                                                  context
                                                      .read<
                                                          StartPremiumSessionBloc>()
                                                      .add(StartPreSession(
                                                          id: client.uuid));
                                                  try {
                                                    await printPremiumQr(
                                                      "USB",
                                                      printerAddress,
                                                      printerName,
                                                      client,
                                                    );
                                                  } catch (e) {
                                                    debugPrint(
                                                        "Error printing Premium QR: $e");
                                                  }
                                                },
                                                label: Text(
                                                  "add_session".tr(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                        if (index != filteredList.length - 1)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Divider(
                                                thickness: 0.1, color: navy),
                                          ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    } else if (state is OfflineFailureState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
