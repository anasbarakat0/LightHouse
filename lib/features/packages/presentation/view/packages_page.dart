import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/header.dart';
import 'package:lighthouse_/common/widget/main_button.dart';
import 'package:lighthouse_/common/widget/pagination.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';
import 'package:lighthouse_/features/packages/data/repository/add_new_package_repo.dart';
import 'package:lighthouse_/features/packages/data/repository/edit_package_info_repo.dart';
import 'package:lighthouse_/features/packages/data/repository/get_all_active_packages_repo.dart';
import 'package:lighthouse_/features/packages/data/source/remote/add_new_package_service.dart';
import 'package:lighthouse_/features/packages/data/source/remote/edit_package_info_service.dart';
import 'package:lighthouse_/features/packages/data/source/remote/get_all_active_packages_service.dart';
import 'package:lighthouse_/features/packages/domain/usecase/add_new_package_usecase.dart';
import 'package:lighthouse_/features/packages/domain/usecase/edit_package_info_usecase.dart';
import 'package:lighthouse_/features/packages/domain/usecase/get_all_active_packages_usecase.dart';
import 'package:lighthouse_/features/packages/presentation/bloc/add_new_package_bloc.dart';
import 'package:lighthouse_/features/packages/presentation/bloc/edit_package_info_bloc.dart';
import 'package:lighthouse_/features/packages/presentation/bloc/get_all_active_packages_bloc.dart';
import 'package:lighthouse_/features/packages/presentation/widgets/add_package_dialog.dart';
import 'package:lighthouse_/features/packages/presentation/widgets/package_card.dart';

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
                  internetConnectionChecker: InternetConnectionChecker(),
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
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          ),
        ),
        BlocListener<EditPackageInfoBloc, EditPackageInfoState>(
            listener: (BuildContext context, state) {
          context
              .read<GetAllActivePackagesBloc>()
              .add(GetAllActivePackages(page: currentPage, size: perPage));
          if (state is PackageEdited) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[800],
                content: Text(state.editPackageInfoResponseModel.message),
              ),
            );
          } else if (state is ExceptionEditPackage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(state.message),
              ),
            );
          } else if (state is ForbiddenEditPackage) {
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
        }),
        BlocProvider(
          create: (context) => AddNewPackageBloc(
            AddNewPackageUsecase(
              addNewPackageRepo: AddNewPackageRepo(
                addNewPackageService: AddNewPackageService(dio: Dio()),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          ),
        ),
        BlocListener<AddNewPackageBloc, AddNewPackageState>(
            listener: (BuildContext context, state) {
          if (state is PackageAdded) {
            context.read<GetAllActivePackagesBloc>()
              ..add(GetAllActivePackages(page: currentPage, size: perPage));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[800],
                content: Text(state.editPackageInfoResponseModel.message),
              ),
            );
          } else if (state is ExceptionAddPackage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red[800],
                content: Text(state.message),
              ),
            );
          } else if (state is ForbiddenAddPackage) {
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
        }),
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
                "package_management".tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 40),
              MainButton(
                  onTap: () {
                    createPackageDialog(context, (package) {
                      context
                          .read<AddNewPackageBloc>()
                          .add(AddPackage(package: package));
                    });
                  },
                  title: "add_package".tr(),
                  icon: const Icon(Icons.add)),
                  const SizedBox(height: 10),
              BlocConsumer<GetAllActivePackagesBloc, GetAllActivePackagesState>(
                  builder: (BuildContext context, state) {
                if (state is ExceptionWhilePackages) {
                  return Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                } else if (state is ShowingAllPackages) {
                  return Expanded(
                      child: Stack(
                    children: [
                      
                      ListView.builder(
                        clipBehavior: Clip.antiAlias,
                        itemCount: state.activePackages.body.length,
                        itemBuilder: (context, index) {
                          PackageModel package = PackageModel.fromMap(
                              state.activePackages.body[index].toMap());

                          return Padding(
                            padding:index==state.activePackages.body.length-1? const EdgeInsets.only(bottom: 20):index==0? const EdgeInsets.only(top: 10): const EdgeInsets.only(),
                            child: PackageCard(
                              onChanged: (type) {
                                context.read<EditPackageInfoBloc>().add(
                                      EditPackageInfo(
                                        id: state.activePackages.body[index].id,
                                        package: PackageModel(
                                          numOfHours: package.numOfHours,
                                          price: package.price,
                                          description: package.description,
                                          packageDurationInDays:
                                              package.packageDurationInDays,
                                          active: type,
                                        ),
                                      ),
                                    );
                              },
                              package: package,
                            ),
                          );
                        },
                      ),
                       Positioned.fill(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 20, 
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  backgroundColor,
                                  Color.fromARGB(0, 21, 19, 28),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 20, 
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color.fromARGB(0, 21, 19, 28),
                                  backgroundColor,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ));
                } else {
                  return const CircularProgressIndicator();
                }
              }, listener: (BuildContext context, state) {
                if (state is ShowingAllPackages) {
                  setState(() {
                    currentPage = state.activePackages.pageable.page;
                    // perPage = state.activePackages.pageable.perPage;
                    total = state.activePackages.pageable.total;
                    totalPages = (total / perPage).ceil();
                  });
                }
              }),
              Column(
                children: [
                  const SizedBox(height: 20),
                  PaginationWidget(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      onPageChanged: (page) {
                        context.read<GetAllActivePackagesBloc>().add(
                            GetAllActivePackages(page: page, size: perPage));
                        setState(() {
                          currentPage = page;
                        });
                      }),
                  // const SizedBox(height: 20),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
