import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/common/widget/pagination.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse/features/packages/data/repository/add_new_package_repo.dart';
import 'package:lighthouse/features/packages/data/repository/edit_package_info_repo.dart';
import 'package:lighthouse/features/packages/data/repository/get_all_active_packages_repo.dart';
import 'package:lighthouse/features/packages/data/source/remote/add_new_package_service.dart';
import 'package:lighthouse/features/packages/data/source/remote/edit_package_info_service.dart';
import 'package:lighthouse/features/packages/data/source/remote/get_all_active_packages_service.dart';
import 'package:lighthouse/features/packages/domain/usecase/add_new_package_usecase.dart';
import 'package:lighthouse/features/packages/domain/usecase/edit_package_info_usecase.dart';
import 'package:lighthouse/features/packages/domain/usecase/get_all_active_packages_usecase.dart';
import 'package:lighthouse/features/packages/presentation/bloc/add_new_package_bloc.dart';
import 'package:lighthouse/features/packages/presentation/bloc/edit_package_info_bloc.dart';
import 'package:lighthouse/features/packages/presentation/bloc/get_all_active_packages_bloc.dart';
import 'package:lighthouse/features/packages/presentation/widgets/add_package_dialog.dart';
import 'package:lighthouse/features/packages/presentation/widgets/edit_package_dialog.dart';
import 'package:lighthouse/features/packages/presentation/widgets/package_card.dart';

class PackagesPage extends StatefulWidget {
  const PackagesPage({super.key});

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  int currentPage = 1;
  int perPage = 5;
  int total = 1;
  int totalPages = 1;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllActivePackagesBloc(
            GetAllActivePackagesUsecase(
              getAllActivePackagesRepo: GetAllActivePackagesRepo(
                getAllActivePackagesService:
                    GetAllActivePackagesService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
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
          )..add(GetAllActivePackages(page: currentPage, size: perPage)),
        ),
        BlocProvider(
          create: (context) => EditPackageInfoBloc(
            EditPackageInfoUsecase(
              editPackageInfoRepo: EditPackageInfoRepo(
                editPackageInfoService: EditPackageInfoService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
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
          create: (context) => AddNewPackageBloc(
            AddNewPackageUsecase(
              addNewPackageRepo: AddNewPackageRepo(
                addNewPackageService: AddNewPackageService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker.createInstance(
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
          BlocListener<EditPackageInfoBloc, EditPackageInfoState>(
            listener: (BuildContext context, state) {
              context
                  .read<GetAllActivePackagesBloc>()
                  .add(GetAllActivePackages(page: currentPage, size: perPage));
              if (state is PackageEdited) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[800],
                    content: Text(
                      state.editPackageInfoResponseModel.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is ExceptionEditPackage) {
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
              } else if (state is ForbiddenEditPackage) {
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
          BlocListener<AddNewPackageBloc, AddNewPackageState>(
            listener: (BuildContext context, state) {
              if (state is PackageAdded) {
                context
                    .read<GetAllActivePackagesBloc>()
                    .add(GetAllActivePackages(page: currentPage, size: perPage));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green[800],
                    content: Text(
                      state.editPackageInfoResponseModel.message,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                );
              } else if (state is ExceptionAddPackage) {
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
              } else if (state is ForbiddenAddPackage) {
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
        child: Builder(builder: (context) {
          final isMobile = Responsive.isMobile(context);

          return Scaffold(
            backgroundColor: darkNavy,
            body: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                                  Icons.inventory_2,
                                  color: orange,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "package_management".tr(),
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
                      const SizedBox(height: 16),

                      // Add Package Button
                      _buildAddPackageButton(context, () {
                        createPackageDialog(context, (package) {
                          context
                              .read<AddNewPackageBloc>()
                              .add(AddPackage(package: package));
                        });
                      }),
                      const SizedBox(height: 24),

                      // Packages List
                      BlocConsumer<GetAllActivePackagesBloc,
                          GetAllActivePackagesState>(
                        builder: (BuildContext context, state) {
                          if (state is ExceptionWhilePackages) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (state is ShowingAllPackages) {
                            if (state.activePackages.body.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF1A2F4A),
                                      const Color(0xFF0F1E2E),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No packages found".tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Add your first package to get started".tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Column(
                              children: [
                                ...List.generate(
                                  state.activePackages.body.length,
                                  (index) {
                                    PackageModel package = PackageModel.fromMap(
                                        state.activePackages.body[index].toMap());

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: PackageCard(
                                        onTap: () {
                                          bool type = state
                                                  .activePackages.body[index].active
                                              ? false
                                              : true;
                                          context.read<EditPackageInfoBloc>().add(
                                                EditPackageInfo(
                                                  id: state.activePackages
                                                      .body[index].id,
                                                  package: PackageModel(
                                                    numOfHours:
                                                        package.numOfHours,
                                                    price: package.price,
                                                    description:
                                                        package.description,
                                                    packageDurationInDays:
                                                        package
                                                            .packageDurationInDays,
                                                    active: type,
                                                  ),
                                                ),
                                              );
                                        },
                                        onPressed: () {
                                          editPackageDialog(
                                              context, package, (package) {
                                            context
                                                .read<EditPackageInfoBloc>()
                                                .add(EditPackageInfo(
                                                    id: state.activePackages
                                                        .body[index].id,
                                                    package: package));
                                          });
                                        },
                                        package: package,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                                PaginationWidget(
                                  currentPage: currentPage,
                                  totalPages: totalPages,
                                  onPageChanged: (page) {
                                    context
                                        .read<GetAllActivePackagesBloc>()
                                        .add(GetAllActivePackages(
                                            page: page, size: perPage));
                                    setState(() {
                                      currentPage = page;
                                    });
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                        listener: (BuildContext context, state) {
                          if (state is ShowingAllPackages) {
                            setState(() {
                              currentPage = state.activePackages.pageable.page;
                              total = state.activePackages.pageable.total;
                              totalPages = (total / perPage).ceil();
                            });
                          }
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddPackageButton(BuildContext context, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            orange.withOpacity(0.2),
            orange.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        orange.withOpacity(0.25),
                        orange.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: orange.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "add_package".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
