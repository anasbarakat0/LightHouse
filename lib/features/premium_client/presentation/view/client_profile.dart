import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/gradient_scaffold.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/common/widget/pagination.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/scroll_behavior.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/admin_by_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_active_packages_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_packages_by_user_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/subscribe_user_to_package_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/admin_by_id_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_active_packages_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_packages_by_user_id_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/subscribe_user_to_package_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/admin_by_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_all_active_packages_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_all_packages_by_user_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/subscribe_user_to_package_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/client_info_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/no_package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/print_function.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/user_package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/qr_code_widget.dart';

enum PrintMode { USB, NETWORK }

class ClientProfile extends StatefulWidget {
  final Body client;
  const ClientProfile({
    super.key,
    required this.client,
  });

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  late Color color;
  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";
  late PrintMode mode = PrintMode.USB;

  late TextEditingController printNameCtrl =
      TextEditingController(text: printerName);
  late TextEditingController printAddressCtrl =
      TextEditingController(text: printerAddress);

  int currentPage = 1;
  int perPage = 5;
  int total = 1;
  int totalPages = 1;

  @override
  void initState() {
    color = orange;
    super.initState();
  }

  @override
  void dispose() {
    printNameCtrl.dispose();
    printAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminByIdBloc(
            AdminByIdUsecase(
              adminByIdRepo: AdminByIdRepo(
                adminByIdService: AdminByIdService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.instance,
                ),
              ),
            ),
          )..add(GetAdminById(id: widget.client.addedBy)),
        ),
        BlocProvider(
          create: (context) => GetAllPackagesByUserIdBloc(
            GetAllPackagesByUserIdRepo(
              getAllPackagesByUserIdService:
                  GetAllPackagesByUserIdService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker.instance,
              ),
            ),
          )..add(GetAllPackagesByUserId(
              userId: widget.client.uuid, page: currentPage, size: perPage)),
        ),
        BlocProvider(
          create: (context) => GetAllActivePackagesBloc(
            GetAllActivePackagesRepo(
              getAllActivePackagesService:
                  GetAllActivePackagesService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker.instance,
              ),
            ),
          )..add(GetAllActivePackages(page: 1, size: 20)),
        ),
        BlocProvider(
          create: (context) => SubscribeUserToPackageBloc(
            SubscribeUserToPackageRepo(
              subscribeUserToPackageService:
                  SubscribeUserToPackageService(dio: Dio()),
              networkConnection: NetworkConnection(
                internetConnectionChecker: InternetConnectionChecker.instance,
              ),
            ),
          ),
        ),
        BlocListener<SubscribeUserToPackageBloc, SubscribeUserToPackageState>(
          listener: (context, state) {
            if (state is SuccessSubscribeUserToPackage) {
              print("state is SuccessSubscribeUserToPackage");
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response.message),
                ),
              );
              // Refresh packages after subscription
              context.read<GetAllPackagesByUserIdBloc>().add(
                    GetAllPackagesByUserId(
                      userId: widget.client.uuid,
                      page: currentPage,
                      size: perPage,
                    ),
                  );
            } else if (state is ExceptionSubscribeUserToPackage) {
              print("state is ExceptionSubscribeUserToPackage");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
            } else if (state is OfflineFailureSubscribeUserToPackage) {
              print("state is OfflineFailureSubscribeUserToPackage");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(state.message,style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                ),
              );
            } else {
              print(state.runtimeType);
            }
          },
        ),
      ],
      child: Builder(builder: (context) {
        return GradientScaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    BackButton(color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 25),
                // Client Name (with capitalized first letters)
                Text(
                  "${widget.client.firstName.replaceFirst(widget.client.firstName[0], widget.client.firstName[0].toUpperCase())} ${widget.client.lastName.replaceFirst(widget.client.lastName[0], widget.client.lastName[0].toUpperCase())}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 40),

                LayoutBuilder(builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(7, 7),
                          color: Color.fromARGB(139, 0, 0, 0),
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [lightGrey, grey],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: !Responsive.isMobile(context)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 30),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 20),
                                        child: ClientInfoWidget(
                                          uuid: widget.client.uuid,
                                          email: widget.client.email,
                                          phoneNumber:
                                              widget.client.phoneNumber,
                                          study: widget.client.study,
                                          gender: widget.client.gender,
                                          birthDate: widget.client.birthDate,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        QrCodeWidget(
                                          qrData: widget.client.qrCode.qrCode,
                                        ),
                                        MyButton(
                                            onPressed: () async {
                                              await printPremiumQr(
                                                  "USB",
                                                  printerAddress,
                                                  printerName,
                                                  widget.client);
                                            },
                                            child: Icon(Icons.receipt_long,
                                                color: darkNavy)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      start: 8),
                                  child: ClientInfoWidget(
                                    uuid: widget.client.uuid,
                                    email: widget.client.email,
                                    phoneNumber: widget.client.phoneNumber,
                                    study: widget.client.study,
                                    gender: widget.client.gender,
                                    birthDate: widget.client.birthDate,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    QrCodeWidget(
                                      qrData: widget.client.qrCode.qrCode,
                                    ),
                                    MyButton(
                                        onPressed: () async {
                                          await printPremiumQr(
                                              "USB",
                                              printerAddress,
                                              printerName,
                                              widget.client);
                                        },
                                        child: Icon(Icons.receipt_long,
                                            color: darkNavy)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                  );
                }),

                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: const Divider(thickness: 0.5),
                ),
                const SizedBox(height: 20),

                Text(
                  "Choose_a_package_to_activate".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 270,
                  child: BlocBuilder<GetAllActivePackagesBloc,
                      GetAllActivePackagesState>(
                    builder: (context, state) {
                      if (state is LoadingFetchingActivePackages) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ExceptionFetchingActivePackages) {
                        return Center(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.red[800]),
                          ),
                        );
                      } else if (state is OfflineFailureActivePackagesState) {
                        return Center(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.red[800]),
                          ),
                        );
                      } else if (state is SuccessFetchingActivePackages) {
                        final activePackages = state.response.body;
                          return ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: activePackages.map((pkg) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: PackageCardWidget(
                                      packageData: pkg,
                                      onTap: () {
                                        print("Activate package: ${pkg.id}");
                                        context
                                            .read<SubscribeUserToPackageBloc>()
                                            .add(
                                              SubscribeUserToPackage(
                                                packageId: pkg.id,
                                                userId: widget.client.uuid,
                                              ),
                                            );
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                      } else if (state is NoActivePackages) {
                        return Center(
                          child: Text(
                            state.message,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: const Divider(thickness: 0.5),
                ),
                const SizedBox(height: 20),
                Text(
                  "Packages".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: grey),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 268,
                  child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: BlocBuilder<GetAllPackagesByUserIdBloc,
                          GetAllPackagesByUserIdState>(
                        builder: (context, state) {
                          if (state is LoadingFetchingPackages) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is NoPackages) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 23),
                                  child: NoPackagesCard(),
                                ),
                                MyButton(
                                  onPressed: () {
                                    context
                                        .read<GetAllPackagesByUserIdBloc>()
                                        .add(
                                          GetAllPackagesByUserId(
                                            userId: widget.client.uuid,
                                            page: currentPage,
                                            size: perPage,
                                          ),
                                        );
                                  },
                                  child: FittedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Refresh".tr(),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.refresh,
                                          color: darkNavy,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (state is ExceptionFetchingPackages) {
                            return Center(
                              child: Text(
                                state.message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.red[800]),
                              ),
                            );
                          } else if (state is OfflineFailureState) {
                            return Center(
                              child: Text(
                                state.message,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.red[800]),
                              ),
                            );
                          } else if (state is SuccessFetchingPackages) {
                            final packages = state.response.body.userPackage;
                            return Column(
                              children: [
                                if (packages.length <= 3)
                                  ScrollConfiguration(
                                    behavior: MyCustomScrollBehavior(),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: packages.map((package) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: UserPackageCard(
                                              packageData: package,
                                              color: color,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                if (packages.length > 3)
                                  ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: packages.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: UserPackageCard(
                                          packageData: packages[index],
                                          color: color,
                                        ),
                                      );
                                    },
                                  ),
                                const SizedBox(height: 20),
                                PaginationWidget(
                                    currentPage: currentPage,
                                    totalPages: totalPages,
                                    onPageChanged: (page) {
                                      context
                                          .read<GetAllPackagesByUserIdBloc>()
                                          .add(GetAllPackagesByUserId(
                                            userId: widget.client.uuid,
                                            page: currentPage,
                                            size: perPage,
                                          ));
                                      setState(() {
                                        currentPage = page;
                                      });
                                    }),
                              ],
                            );
                          }
                          return Container();
                        },
                      )),
                ),

                const SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 25,
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  child: const Divider(thickness: 0.5),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "added_by".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: color),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "adding_time".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: color),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "lastModifiedBy".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: color),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "updatedAt".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: color),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BlocBuilder<AdminByIdBloc, AdminByIdState>(
                          builder: (context, state) {
                            if (state is SuccessGettingAdmin) {
                              return Text(
                                "${state.response.body.firstName} ${state.response.body.lastName}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              );
                            } else {
                              return const Text("Waiting...");
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('yyyy/MM/dd').format(
                              DateTime.parse(widget.client.addingDateTime)),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        widget.client.qrCode.lastModifiedBy == null
                            ? Text(
                                "Null",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              )
                            : Text(
                                widget.client.qrCode.lastModifiedBy,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                        const SizedBox(height: 20),
                        Text(
                          DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                      widget.client.qrCode.updatedAt)) ==
                                  DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(
                                          widget.client.addingDateTime))
                              ? "Null"
                              : DateFormat('yyyy/MM/dd').format(
                                  DateTime.parse(
                                    widget.client.qrCode.updatedAt,
                                  ),
                                ),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      }),
    );
  }
}
