import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/core/utils/responsive.dart';
import 'package:lighthouse_/common/widget/header.dart';
import 'package:lighthouse_/features/admin_managment/data/models/admin_info_model.dart';
import 'package:lighthouse_/features/admin_managment/data/models/new_admin_model.dart';
import 'package:lighthouse_/features/admin_managment/data/repository/add_new_admin_repo.dart';
import 'package:lighthouse_/features/admin_managment/data/repository/all_admin_info_repo.dart';
import 'package:lighthouse_/features/admin_managment/data/repository/delete_admin_repo.dart';
import 'package:lighthouse_/features/admin_managment/data/source/add_new_admin_service.dart';
import 'package:lighthouse_/features/admin_managment/data/source/all_admin_info_service.dart';
import 'package:lighthouse_/features/admin_managment/data/source/delete_admin_service.dart';
import 'package:lighthouse_/features/admin_managment/domain/usecase/add_new_admin_usecase.dart';
import 'package:lighthouse_/features/admin_managment/domain/usecase/all_admin_info_usecase.dart';
import 'package:lighthouse_/features/admin_managment/domain/usecase/delete_admin_usecase.dart';
import 'package:lighthouse_/features/admin_managment/presentation/bloc/add_new_admin_bloc.dart';
import 'package:lighthouse_/features/admin_managment/presentation/bloc/all_admin_info_bloc.dart';
import 'package:lighthouse_/features/admin_managment/presentation/bloc/delete_admin_bloc.dart';
import 'package:lighthouse_/features/admin_managment/presentation/widget/admin_card_desktop.dart';
import 'package:lighthouse_/features/admin_managment/presentation/widget/admin_card_mobile.dart';
import 'package:lighthouse_/features/admin_managment/presentation/widget/create_admin.dart';
import 'package:lighthouse_/features/admin_managment/presentation/widget/delete_dialog.dart';
import 'package:lighthouse_/features/admin_managment/presentation/widget/error_messages.dart';
import 'package:lighthouse_/features/login/presentation/view/login.dart';

class AdminManagment extends StatelessWidget {
  const AdminManagment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AllAdminInfoBloc(
            AllAdminInfoUsecase(
              AllAdminInfoRepo(
                allAdminInfoService: AllAdminInfoService(
                  dio: Dio(),
                ),
                networkConnection: NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          )..add(GetAdmins(page: 1, size: 10)),
        ),
        BlocProvider(
          create: (context) => AddNewAdminBloc(
            AddNewAdminUsecase(
              addNewAdminRepo: AddNewAdminRepo(
                networkConnection: NetworkConnection(
                    internetConnectionChecker: InternetConnectionChecker()),
                addNewAdminService: AddNewAdminService(dio: Dio()),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteAdminBloc(
            DeleteAdminUsecase(
              deleteAdminRepo: DeleteAdminRepo(
                DeleteAdminService(
                  dio: Dio(),
                ),
                NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker(),
                ),
              ),
            ),
          ),
        ),
        BlocListener<DeleteAdminBloc, DeleteAdminState>(
          listener: (context, state) {
            if (state is AdminDeleted) {
              context
                  .read<AllAdminInfoBloc>()
                  .add(GetAdmins(page: 1, size: 10));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(state.response.message),
                ),
              );
            }
            if (state is ExceptionDeleteAdmin) {
              return errorMessage(context, "error".tr(), [state.message]);
            }
            if (state is ForbiddenDeleteState) {
              errorMessage(context, "unauthorized".tr(), [state.message]);
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
      child: Builder(builder: (context) {
        return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 18),
                const HeaderWidget(),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "admin_management".tr(),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 40),
                BlocListener<AddNewAdminBloc, AddNewAdminState>(
                  listener: (context, state) {
                    if (state is ErrorCreatingAdmin) {
                      return errorMessage(
                          context, "error".tr(), state.messages);
                    }
                    if (state is AdminCreated) {
                      context
                          .read<AllAdminInfoBloc>()
                          .add(GetAdmins(page: 1, size: 10));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(state.response.message),
                        ),
                      );
                    }
                  },
                  child: InkWell(
                    onTap: () {
                      void data(NewAdminModel admin) {
                        context
                            .read<AddNewAdminBloc>()
                            .add(AddAdmin(admin: admin));
                      }

                      createAdmin(context, data);
                    },
                    child: SizedBox(
                      height: 69,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              const Icon(Icons.person_add_sharp),
                              const SizedBox(width: 15),
                              Text(
                                "create_admin".tr(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocConsumer<AllAdminInfoBloc, AllAdminInfoState>(
                  listener: (context, state) {
                    if (state is ForbiddenFetching) {
                      errorMessage(
                          context, "unauthorized".tr(), [state.message]);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginWindows(),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ErrorFetchingAdmins) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      );
                    } else if (state is ForbiddenFetching) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      );
                    } else if (state is SucessFetchingAdmins) {
                      return Expanded(
                        child: Builder(builder: (context) {
                          final deleteAdminBloc =
                              context.read<DeleteAdminBloc>();
                          return ListView.builder(
                              itemCount: state.allAdminInfoResponse.body.length,
                              itemBuilder: (context, index) {
                                if (!Responsive.isDesktop(context)) {
                                  return AdminCard(
                                    adminInfoModel: AdminInfoModel.fromMap(state
                                        .allAdminInfoResponse.body[index]
                                        .toMap()),
                                    onPressedDelete: (context) {
                                      deleteMessage(
                                        context,
                                        () {
                                          deleteAdminBloc.add(
                                            DeleteAdmin(
                                              id: state.allAdminInfoResponse
                                                  .body[index].id,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    onPressedEdit: (context) {},
                                  );
                                } else {
                                  return AdminCardDesktop(
                                    adminInfoModel: AdminInfoModel.fromMap(state
                                        .allAdminInfoResponse.body[index]
                                        .toMap()),
                                    onPressedDelete: () {
                                      deleteMessage(
                                        context,
                                        () {
                                          context.read<DeleteAdminBloc>().add(
                                                DeleteAdmin(
                                                  id: state.allAdminInfoResponse
                                                      .body[index].id,
                                                ),
                                              );
                                        },
                                      );
                                    },
                                    onPressedEdit: () {},
                                  );
                                }
                              });
                        }),
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
