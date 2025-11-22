import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/gradient_scaffold.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/scroll_behavior.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/admin_by_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_active_packages_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_all_packages_by_user_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/get_sessions_by_user_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/repository/subscribe_user_to_package_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/admin_by_id_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_active_packages_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_all_packages_by_user_id_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/get_sessions_by_user_id_service.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/subscribe_user_to_package_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/admin_by_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_all_active_packages_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_all_packages_by_user_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/get_sessions_by_user_id_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/subscribe_user_to_package_bloc.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/user_package_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/hero_header_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/profile_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/section_title_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/state_widgets.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/refresh_button_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/pagination_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/session_history_card_widget.dart';
import 'package:lighthouse/features/premium_client/presentation/widget/edit_client_dialog.dart';
import 'package:lighthouse/features/premium_client/data/repository/update_premium_client_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/update_premium_client_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/update_premium_client_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/update_premium_client_bloc.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';
import 'package:lighthouse/features/premium_client/data/repository/delete_premium_client_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/delete_premium_client_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/delete_premium_client_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/bloc/delete_premium_client_bloc.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/delete_dialog.dart';

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

class _ClientProfileState extends State<ClientProfile>
    with SingleTickerProviderStateMixin {
  late Color color;
  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";
  late PrintMode mode = PrintMode.USB;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late TextEditingController printNameCtrl =
      TextEditingController(text: printerName);
  late TextEditingController printAddressCtrl =
      TextEditingController(text: printerAddress);

  int currentPage = 1;
  int perPage = 5;
  int totalPages = 1;

  int sessionsCurrentPage = 1;
  int sessionsPerPage = 5;

  @override
  void initState() {
    color = orange;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    printNameCtrl.dispose();
    printAddressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AdminByIdBloc(
            AdminByIdUsecase(
              adminByIdRepo: AdminByIdRepo(
                adminByIdService: AdminByIdService(dio: Dio()),
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
          )..add(GetAdminById(id: widget.client.addedBy)),
        ),
        BlocProvider(
          create: (context) => GetAllPackagesByUserIdBloc(
            GetAllPackagesByUserIdRepo(
              getAllPackagesByUserIdService:
                  GetAllPackagesByUserIdService(dio: Dio()),
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
          )..add(GetAllPackagesByUserId(
              userId: widget.client.uuid,
              page: currentPage - 1,
              size: perPage)),
        ),
        BlocProvider(
          create: (context) => GetAllActivePackagesBloc(
            GetAllActivePackagesRepo(
              getAllActivePackagesService:
                  GetAllActivePackagesService(dio: Dio()),
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
          )..add(GetAllActivePackages(page: 1, size: 20)),
        ),
        BlocProvider(
          create: (context) => SubscribeUserToPackageBloc(
            SubscribeUserToPackageRepo(
              subscribeUserToPackageService:
                  SubscribeUserToPackageService(dio: Dio()),
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
          create: (context) => GetSessionsByUserIdBloc(
            GetSessionsByUserIdRepo(
              getSessionsByUserIdService:
                  GetSessionsByUserIdService(dio: Dio()),
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
          )..add(GetSessionsByUserId(
              userId: widget.client.uuid,
              page: sessionsCurrentPage - 1,
              size: sessionsPerPage)),
        ),
        BlocProvider(
          create: (context) => UpdatePremiumClientBloc(
            UpdatePremiumClientUsecase(
              updatePremiumClientRepo: UpdatePremiumClientRepo(
                updatePremiumClientService:
                    UpdatePremiumClientService(dio: Dio()),
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
          create: (context) => DeletePremiumClientBloc(
            DeletePremiumClientUsecase(
              deletePremiumClientRepo: DeletePremiumClientRepo(
                deletePremiumClientService:
                    DeletePremiumClientService(dio: Dio()),
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
          BlocListener<SubscribeUserToPackageBloc, SubscribeUserToPackageState>(
            listener: (context, state) {
              if (state is SuccessSubscribeUserToPackage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(state.response.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
                context.read<GetAllPackagesByUserIdBloc>().add(
                    GetAllPackagesByUserId(
                        userId: widget.client.uuid,
                        page: currentPage - 1,
                        size: perPage));
              } else if (state is ExceptionSubscribeUserToPackage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(state.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is OfflineFailureSubscribeUserToPackage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.wifi_off, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(state.message,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<UpdatePremiumClientBloc, UpdatePremiumClientState>(
            listener: (context, state) {
              if (state is SuccessUpdatePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.response.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                // Update the client data - keep existing qrCode since it's not returned in update response
                final updatedClient = widget.client.copyWith(
                  firstName: state.response.body.firstName,
                  lastName: state.response.body.lastName,
                  email: state.response.body.email,
                  phoneNumber: state.response.body.phoneNumber,
                  gender: state.response.body.gender,
                  study: state.response.body.study,
                  birthDate:
                      state.response.body.birthDate ?? widget.client.birthDate,
                );

                // Navigate back and then forward with updated data
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClientProfile(
                      client: updatedClient,
                    ),
                  ),
                );
              } else if (state is ExceptionUpdatePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is OfflineFailureUpdatePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.wifi_off, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<DeletePremiumClientBloc, DeletePremiumClientState>(
            listener: (context, state) {
              if (state is SuccessDeletePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                // Navigate back to premium clients page
                Navigator.of(context).pop();
              } else if (state is ExceptionDeletePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.redAccent[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is OfflineFailureDeletePremiumClient) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    content: Row(
                      children: [
                        const Icon(Icons.wifi_off, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            state.message,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(builder: (context) {
          return GradientScaffold(
            body: FadeTransition(
              opacity: _fadeAnimation,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Stunning Hero Header
                  HeroHeaderWidget(
                    client: widget.client,
                    isMobile: isMobile,
                    printerAddress: printerAddress,
                    printerName: printerName,
                  ),

                  // Main Content
                  SliverPadding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Client Profile Card with QR
                        ProfileCardWidget(
                          client: widget.client,
                          printerAddress: printerAddress,
                          printerName: printerName,
                          onEditTap: () {
                            showEditClientDialog(
                              context,
                              widget.client,
                              (UpdatePremiumClientModel updatedClient) {
                                context.read<UpdatePremiumClientBloc>().add(
                                      UpdatePremiumClient(
                                        userId: widget.client.uuid,
                                        client: updatedClient,
                                      ),
                                    );
                              },
                            );
                          },
                          onDeleteTap: () {
                            deleteMessage(
                              context,
                              () {
                                context.read<DeletePremiumClientBloc>().add(
                                      DeletePremiumClient(
                                        userId: widget.client.uuid,
                                      ),
                                    );
                              },
                              "Are_you_sure_you_want_to_delete_this_client?"
                                  .tr(),
                            );
                          },
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Available Packages Section
                        _buildAvailablePackagesSection(isMobile),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Active Packages Section
                        _buildActivePackagesSection(isMobile),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Sessions Section
                        _buildSessionsSection(isMobile),

                        const SizedBox(height: 40),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAvailablePackagesSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: "choose_package".tr(),
          icon: Icons.card_giftcard,
          isMobile: isMobile,
        ),
        const SizedBox(height: 16),
        Container(
          height: 290,
          child:
              BlocBuilder<GetAllActivePackagesBloc, GetAllActivePackagesState>(
            builder: (context, state) {
              if (state is LoadingFetchingActivePackages) {
                return const LoadingStateWidget();
              } else if (state is ExceptionFetchingActivePackages ||
                  state is OfflineFailureActivePackagesState) {
                final message = state is ExceptionFetchingActivePackages
                    ? state.message
                    : (state as OfflineFailureActivePackagesState).message;
                return ErrorStateWidget(message: message);
              } else if (state is SuccessFetchingActivePackages) {
                final packages = state.response.body;
                return ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    physics: const BouncingScrollPhysics(),
                    itemCount: packages.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 300,
                        child: PackageCardWidget(
                          packageData: packages[index],
                          onTap: () {
                            context.read<SubscribeUserToPackageBloc>().add(
                                  SubscribeUserToPackage(
                                    packageId: packages[index].id,
                                    userId: widget.client.uuid,
                                  ),
                                );
                          },
                        ),
                      );
                    },
                  ),
                );
              } else if (state is NoActivePackages) {
                return EmptyStateWidget(
                  message: "no_packages_available".tr(),
                  icon: Icons.inventory_2_outlined,
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivePackagesSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: "active_packages".tr(),
          icon: Icons.inventory_2,
          isMobile: isMobile,
        ),
        const SizedBox(height: 16),
        Container(
          height: 360,
          child: BlocBuilder<GetAllPackagesByUserIdBloc,
              GetAllPackagesByUserIdState>(
            builder: (context, state) {
              if (state is LoadingFetchingPackages) {
                return const LoadingStateWidget();
              } else if (state is NoPackages) {
                return Column(
                  children: [
                    Expanded(
                      child: EmptyStateWidget(
                        message: "no_active_packages".tr(),
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RefreshButtonWidget(
                      onPressed: () {
                        context.read<GetAllPackagesByUserIdBloc>().add(
                              GetAllPackagesByUserId(
                                userId: widget.client.uuid,
                                page: currentPage - 1,
                                size: perPage,
                              ),
                            );
                      },
                    ),
                  ],
                );
              } else if (state is SuccessFetchingPackages) {
                final packages = state.response.body.userPackage;
                return Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          physics: const BouncingScrollPhysics(),
                          itemCount: packages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return Container(
                              width: 300,
                              child: UserPackageCard(
                                packageData: packages[index],
                                color: color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (state.response.body.paginationResponse.total >
                        perPage) ...[
                      const SizedBox(height: 16),
                      PaginationCardWidget(
                        currentPage: currentPage,
                        totalPages:
                            (state.response.body.paginationResponse.total /
                                    perPage)
                                .ceil(),
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                          });
                          context.read<GetAllPackagesByUserIdBloc>().add(
                                GetAllPackagesByUserId(
                                  userId: widget.client.uuid,
                                  page: page - 1,
                                  size: perPage,
                                ),
                              );
                        },
                      ),
                    ],
                  ],
                );
              } else if (state is ExceptionFetchingPackages ||
                  state is OfflineFailureState) {
                final message = state is ExceptionFetchingPackages
                    ? state.message
                    : (state as OfflineFailureState).message;
                return ErrorStateWidget(message: message);
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitleWidget(
          title: "Sessions History".tr(),
          icon: Icons.history,
          isMobile: isMobile,
        ),
        const SizedBox(height: 16),
        BlocBuilder<GetSessionsByUserIdBloc, GetSessionsByUserIdState>(
          builder: (context, state) {
            if (state is LoadingFetchingSessions) {
              return Container(
                height: 400,
                child: const LoadingStateWidget(),
              );
            } else if (state is NoSessions) {
              return Container(
                height: 300,
                child: Column(
                  children: [
                    Expanded(
                      child: EmptyStateWidget(
                        message: "No sessions found".tr(),
                        icon: Icons.history_outlined,
                      ),
                    ),
                    const SizedBox(height: 16),
                    RefreshButtonWidget(
                      onPressed: () {
                        context.read<GetSessionsByUserIdBloc>().add(
                              GetSessionsByUserId(
                                userId: widget.client.uuid,
                                page: sessionsCurrentPage - 1,
                                size: sessionsPerPage,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              );
            } else if (state is SuccessFetchingSessions) {
              final sessions = state.response.body.sessions;
              final totalSessions =
                  state.response.body.paginationResponse.total;
              final hasPagination = totalSessions > sessionsPerPage;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sessions Grid/List
                  isMobile
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: sessions.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return SessionHistoryCardWidget(
                              session: sessions[index],
                              isMobile: true,
                            );
                          },
                        )
                      : Container(
                          height: 420,
                          child: ScrollConfiguration(
                            behavior: MyCustomScrollBehavior(),
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              physics: const BouncingScrollPhysics(),
                              itemCount: sessions.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                return SessionHistoryCardWidget(
                                  session: sessions[index],
                                  isMobile: false,
                                );
                              },
                            ),
                          ),
                        ),

                  // Pagination
                  if (hasPagination) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: PaginationCardWidget(
                        currentPage: sessionsCurrentPage,
                        totalPages: (totalSessions / sessionsPerPage).ceil(),
                        onPageChanged: (page) {
                          setState(() {
                            sessionsCurrentPage = page;
                          });
                          context.read<GetSessionsByUserIdBloc>().add(
                                GetSessionsByUserId(
                                  userId: widget.client.uuid,
                                  page: page - 1,
                                  size: sessionsPerPage,
                                ),
                              );
                          // Scroll to top of sessions section
                          if (isMobile) {
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              Scrollable.ensureVisible(
                                context,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ],
              );
            } else if (state is ExceptionFetchingSessions ||
                state is OfflineFailureSessionsState) {
              final message = state is ExceptionFetchingSessions
                  ? state.message
                  : (state as OfflineFailureSessionsState).message;
              return Container(
                height: 300,
                child: ErrorStateWidget(message: message),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
