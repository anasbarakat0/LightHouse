import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/main_button.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/common/widget/header.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/add_premium_client_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_premium_clients_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_premium_user_by_name_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/start_premium_session_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/add_premium_client_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_premium_clients_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_premium_user_by_name_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/start_premium_session_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/add_premium_client_usecase.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/get_premium_clients_usecase.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/start_premium_session_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/add_premium_client_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_premium_clients_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_premium_user_by_name_bloc.dart';
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
  bool searchTest = true;
  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";
  List<Body> clients = [];

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
                NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
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
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
              ),
            ),
          )..add(GetPremiumClients(page: 1, size: 20)),
        ),
        BlocProvider(
          create: (context) => StartPremiumSessionBloc(
            StartPremiumSessionUsecase(
              startPremiumSessionRepo: StartPremiumSessionRepo(
                startPremiumSessionService:
                    StartPremiumSessionService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
              ),
            ),
          ),
        ),
        BlocListener<StartPremiumSessionBloc, StartPremiumSessionState>(
          listener: (context, state) {
            if (state is SuccessStartSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            } else if (state is ExceptionStartSession) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
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
                  backgroundColor: Colors.red[800],
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
          create: (context) => GetPremiumUserByNameBloc(
            GetPremiumUserByNameRepo(
              getPremiumUserByNameService:
                  GetPremiumUserByNameService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker.instance,
              ),
            ),
          ),
        ),
        BlocListener<GetPremiumUserByNameBloc, GetPremiumUserByNameState>(
          listener: (context, state) {
            if (state is SuccessGettingPremiumUserByName) {
              print("نجح البحث، البيانات: ${state.response.body}");
            } else if (state is ExceptionGettingPremiumUserByName) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
                  content: Text(state.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is ForbiddenGettingPremiumUserByName) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red[800],
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
              HeaderWidget(title: "admin_management".tr()),
              const SizedBox(height: 25),
              if (Responsive.isDesktop(context))
                Text(
                  "admin_management".tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              if (Responsive.isDesktop(context)) const SizedBox(height: 40),
              BlocConsumer<AddPremiumClientBloc, AddPremiumClientState>(
                listener: (context, state) {
                  if (state is ExceptionAddedClient) {
                    print(state.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
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
                        content: Text(state.response.message),
                      ),
                    );
                    context
                        .read<GetPremiumClientsBloc>()
                        .add(GetPremiumClients(page: 1, size: 20));
                  } else if (state is ForbiddenAdded) {
                    print(state.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
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
                            builder: (context) => const LoginWindows()));
                  } else {
                    print(state.runtimeType);
                  }
                },
                builder: (context, state) {
                  return MainButton(
                      onTap: () {
                        void client(PremiumClient client) {
                          print('client');
                          print(client.toMap());
                          context
                              .read<AddPremiumClientBloc>()
                              .add(AddPremiumClient(client: client));
                        }

                        AddPremiumClientDialog(context, client);
                      },
                      title: "add_client".tr(),
                      icon: const Icon(
                        Icons.person_add_sharp,
                        color: orange,
                      ));
                },
              ),
              const SizedBox(height: 20),
              SearchField(
                  controller: search,
                  onChanged: (name) {
                    setState(() {
                      if (search.text.isEmpty) {
                        searchTest = true;
                      } else {
                        searchTest = false;
                      }
                    });
                  },
                  onSubmitted: (name) {
                    context
                        .read<GetPremiumUserByNameBloc>()
                        .add(GetPremiumUserByName(name: name));
                  }),
              const SizedBox(height: 20),
              if (searchTest)
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
                      return Expanded(
                        child: ListView.builder(
                            itemCount: state.responseModel.body.length,
                            itemBuilder: (context, index) {
                              final client = state.responseModel.body[index];
                              clients.add(client);
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
                                      backgroundColor: navy,
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
                                          ?.copyWith(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      client.phoneNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: grey,
                                          ),
                                    ),
                                    trailing: FloatingActionButton.extended(
                                      backgroundColor: lightGrey,
                                      icon: const Icon(
                                        Icons.login,
                                        color: orange,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<StartPremiumSessionBloc>()
                                            .add(StartPreSession(
                                                id: client.uuid));
                                        printPremiumQr("USB", printerAddress,
                                            printerName, client);
                                      },
                                      label: Text(
                                        "add_session".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  if (index !=
                                      state.responseModel.body.length - 1)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Divider(thickness: 0.1),
                                    ),
                                ],
                              );
                            }),
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
              if (!searchTest)
                BlocBuilder<GetPremiumUserByNameBloc,
                    GetPremiumUserByNameState>(
                  builder: (context, state) {
                    if (state is ExceptionGettingPremiumUserByName) {
                      return Center(
                        child: Text(
                          state.message,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      );
                    } else if (state is SuccessGettingPremiumUserByName) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: state.response.body.length,
                            itemBuilder: (context, index) {
                              final client = state.response.body[index];
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClientProfile(
                                                      client: Body.fromMap(
                                                          client.toMap()))));
                                    },
                                    minTileHeight: 56,
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: navy,
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
                                          .bodyMedium,
                                    ),
                                    subtitle: Text(
                                      client.phoneNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: grey,
                                          ),
                                    ),
                                    trailing: FloatingActionButton.extended(
                                      backgroundColor: lightGrey,
                                      icon: const Icon(
                                        Icons.login,
                                        color: orange,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<StartPremiumSessionBloc>()
                                            .add(StartPreSession(
                                                id: client.uuid));
                                      },
                                      label: Text(
                                        "add_session".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  if (index != state.response.body.length - 1)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Divider(thickness: 0.1),
                                    ),
                                ],
                              );
                            }),
                      );
                    } else if (state is OfflineFailureState) {
                      return Center(
                        child: Text(
                          "There is no internet",
                          style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
