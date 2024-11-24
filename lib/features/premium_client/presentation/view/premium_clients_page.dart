import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/main_button.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/common/widget/header.dart';
import 'package:lighthouse_/features/premium_client/data/models/premium_client_model.dart';
import 'package:lighthouse_/features/premium_client/data/repository/add_premium_client_repo.dart';
import 'package:lighthouse_/features/premium_client/data/repository/get_all_premium_clients_repo.dart';
import 'package:lighthouse_/features/premium_client/data/source/remote/add_premium_client_service.dart';
import 'package:lighthouse_/features/premium_client/data/source/remote/get_all_premium_clients_service.dart';
import 'package:lighthouse_/features/premium_client/domain/usecase/add_premium_client_usecase.dart';
import 'package:lighthouse_/features/premium_client/domain/usecase/get_premium_clients_usecase.dart';
import 'package:lighthouse_/features/premium_client/presentation/bloc/add_premium_client_bloc.dart';
import 'package:lighthouse_/features/premium_client/presentation/bloc/get_premium_clients_bloc.dart';
import 'package:lighthouse_/features/premium_client/presentation/view/client_profile.dart';
import 'package:lighthouse_/features/premium_client/presentation/widget/premium_client_dialog.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';
import 'package:lighthouse_/features/premium_client/presentation/widget/search_field.dart';

class PremiumClientsPage extends StatefulWidget {
  const PremiumClientsPage({super.key});

  @override
  State<PremiumClientsPage> createState() => _PremiumClientsPageState();
}

class _PremiumClientsPageState extends State<PremiumClientsPage> {
  TextEditingController search = TextEditingController();

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
                  internetConnectionChecker: InternetConnectionChecker(),
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
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          )..add(GetPremiumClients(page: 1, size: 20)),
        ),
      ],
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 18),
              const HeaderWidget(),
              const SizedBox(height: 25),
              Text(
                "admin_management".tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              BlocConsumer<AddPremiumClientBloc, AddPremiumClientState>(
                listener: (context, state) {
                  if (state is ExceptionAddedClient) {
                    print(state.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red[800],
                        content: Text(state.message),
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
                        content: Text(state.message),
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
                      icon: const Icon(Icons.person_add_sharp,color: orange,));
                },
              ),
              const SizedBox(height: 20),
              SearchField(controller: search),
              const SizedBox(height: 20),
              BlocBuilder<GetPremiumClientsBloc, GetPremiumClientsState>(
                builder: (context, state) {
                  if (state is ExceptionFetchingClients) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is NoClientsToShow) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is SuccessFetchingClients) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: state.responseModel.body.length,
                          itemBuilder: (context, index) {
                            final client = state.responseModel.body[index];
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // premiumClientInfo(context, client);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClientProfile(client: client)));
                                  },
                                  child: ListTile(
                                    minTileHeight: 56,
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: navy,
                                      child: client.gender == "MALE"?Icon( Icons.person,color: lightGrey ,size: 35,):SvgPicture.asset("assets/svg/woman.svg",width: 25  ,color: lightGrey,),
                                    ),
                                    title: Text(
                                      "${client.firstName.replaceFirst(client.firstName[0], client.firstName[0].toUpperCase())} ${client.lastName.replaceFirst(client.lastName[0], client.lastName[0].toUpperCase())}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    subtitle: Text(
                                      client.phoneNumber,
                                      style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: navy),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                                if(index!= state.responseModel.body.length-1) const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                        style: Theme.of(context).textTheme.labelMedium,
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
