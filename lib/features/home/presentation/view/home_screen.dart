import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/header.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/home/data/models/active_sessions_response_model.dart';
import 'package:lighthouse_/features/home/data/repository/get_all_active_sessions_repo.dart';
import 'package:lighthouse_/features/home/data/source/remote/get_all_active_sessions_service.dart';
import 'package:lighthouse_/features/home/domain/usecase/get_all_active_sessions_usecase.dart';
import 'package:lighthouse_/features/home/presentation/bloc/get_all_active_sessions_bloc.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          )..add(GetActiveSessions()),
        )
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
                "home".tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              BlocConsumer<GetAllActiveSessionsBloc, GetAllActiveSessionsState>(
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
                            builder: (context) => const LoginWindows()));
                  }
                },
                builder: (context, state) {
                  if (state is SuccessGettingSessions) {
                    return Column(
                      children: [
                        Text(
                          "premium_clients".tr(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: state
                                  .response.body.activePremiumSessions.isEmpty
                              ? const Text("There is no data")
                              : ListView.builder(
                                  itemCount: state.response.body
                                      .activePremiumSessions.length,
                                  itemBuilder: (context, index) {
                                    ActivePremiumSession premiumSession = state
                                        .response
                                        .body
                                        .activePremiumSessions[index];
                                    return ListTile(
                                      title: Text(
                                        premiumSession.firstName,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(premiumSession.startTime),
                                    );
                                  }),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: grey),
                        const SizedBox(height: 20),
                        Text(
                          "premium_clients".tr(),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: navy,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: state
                                  .response.body.activeExpressSessions.isEmpty
                              ? const Text("There is no data")
                              : GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        4, // Adjust the number of columns
                                    crossAxisSpacing: 16.0,
                                    mainAxisSpacing: 16.0,
                                    childAspectRatio: 2,
                                  ),
                                  itemCount: state.response.body
                                      .activeExpressSessions.length,
                                  itemBuilder: (context, index) {
                                    ActiveExpressSession expressSession = state
                                        .response
                                        .body
                                        .activeExpressSessions[index];
                                    return Card(
                                      color: lightGrey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // const Icon(Icons.account_circle,
                                                //     size: 40, color: Colors.blue),
                                                // const SizedBox(height: 8),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      10,
                                                  child: Text(
                                                    expressSession.fullName,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    // overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'started_at'.tr() +
                                                      ': ${expressSession.startTime}',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '${'created_by'.tr()}: ${expressSession.createdBy.firstName} ${expressSession.createdBy.lastName}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            Icon(
                                              Icons.rocket_launch,
                                              color: orange,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        );
      }),
    );
  }
}
