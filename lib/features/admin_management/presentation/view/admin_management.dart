import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/admin_management/data/models/admin_info_model.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_model.dart';
import 'package:lighthouse/features/admin_management/data/repository/add_new_admin_repo.dart';
import 'package:lighthouse/features/admin_management/data/repository/all_admin_info_repo.dart';
import 'package:lighthouse/features/admin_management/data/repository/delete_admin_repo.dart';
import 'package:lighthouse/features/admin_management/data/source/add_new_admin_service.dart';
import 'package:lighthouse/features/admin_management/data/source/all_admin_info_service.dart';
import 'package:lighthouse/features/admin_management/data/source/delete_admin_service.dart';
import 'package:lighthouse/features/admin_management/domain/usecase/add_new_admin_usecase.dart';
import 'package:lighthouse/features/admin_management/domain/usecase/all_admin_info_usecase.dart';
import 'package:lighthouse/features/admin_management/domain/usecase/delete_admin_usecase.dart';
import 'package:lighthouse/features/admin_management/presentation/bloc/add_new_admin_bloc.dart';
import 'package:lighthouse/features/admin_management/presentation/bloc/all_admin_info_bloc.dart';
import 'package:lighthouse/features/admin_management/presentation/bloc/delete_admin_bloc.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/admin_card_desktop.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/admin_card_mobile.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/create_admin.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/delete_dialog.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/error_messages.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';

class AdminManagement extends StatelessWidget {
  const AdminManagement({super.key});

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
          )..add(GetAdmins(page: 1, size: 10)),
        ),
        BlocProvider(
          create: (context) => AddNewAdminBloc(
            AddNewAdminUsecase(
              addNewAdminRepo: AddNewAdminRepo(
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
                    ]
                  ),),
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
          BlocListener<DeleteAdminBloc, DeleteAdminState>(
            listener: (context, state) {
              if (state is AdminDeleted) {
                context
                    .read<AllAdminInfoBloc>()
                    .add(GetAdmins(page: 1, size: 10));

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
                                  Icons.manage_accounts,
                                  color: orange,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "admin_management".tr(),
                                style: TextStyle(
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
                      
                      // Create Admin Button
                      BlocListener<AddNewAdminBloc, AddNewAdminState>(
                        listener: (context, state) {
                          if (state is ErrorCreatingAdmin) {
                            return errorMessage(context, "error".tr(), state.messages);
                          }
                          if (state is AdminCreated) {
                            context
                                .read<AllAdminInfoBloc>()
                                .add(GetAdmins(page: 1, size: 10));

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  state.response.message,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white),
                                ),
                              ),
                            );
                          }
                        },
                        child: _buildCreateAdminButton(context, () {
                          void data(NewAdminModel admin) {
                            context
                                .read<AddNewAdminBloc>()
                                .add(AddAdmin(admin: admin));
                          }
                          createAdmin(context, data);
                        }),
                      ),
                      const SizedBox(height: 24),
                      
                      // Admins List
                      BlocConsumer<AllAdminInfoBloc, AllAdminInfoState>(
                        listener: (context, state) {
                          if (state is ForbiddenFetching) {
                            errorMessage(context, "unauthorized".tr(), [state.message]);
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
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (state is ForbiddenFetching) {
                            return Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          } else if (state is SucessFetchingAdmins) {
                            if (state.allAdminInfoResponse.body.isEmpty) {
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
                                      Icons.people_outline,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No admins found".tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            
                            return Builder(builder: (context) {
                              final deleteAdminBloc = context.read<DeleteAdminBloc>();
                              return Column(
                                children: List.generate(
                                  state.allAdminInfoResponse.body.length,
                                  (index) {
                                    final admin = AdminInfoModel.fromMap(
                                      state.allAdminInfoResponse.body[index].toMap(),
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12),
                                      child: !Responsive.isDesktop(context)
                                          ? AdminCard(
                                              adminInfoModel: admin,
                                              onPressedDelete: (context) {
                                                deleteMessage(context, () {
                                                  deleteAdminBloc.add(
                                                    DeleteAdmin(
                                                      id: state.allAdminInfoResponse
                                                          .body[index].id,
                                                    ),
                                                  );
                                                },
                                                    "Are_you_sure_you_want_to_delete_the_admin?"
                                                        .tr());
                                              },
                                              onPressedEdit: (context) {},
                                            )
                                          : AdminCardDesktop(
                                              adminInfoModel: admin,
                                              onPressedDelete: () {
                                                deleteMessage(context, () {
                                                  context.read<DeleteAdminBloc>().add(
                                                        DeleteAdmin(
                                                          id: state.allAdminInfoResponse
                                                              .body[index].id,
                                                        ),
                                                      );
                                                },
                                                    "Are_you_sure_you_want_to_delete_the_admin?"
                                                        .tr());
                                              },
                                              onPressedEdit: () {},
                                            ),
                                    );
                                  },
                                ),
                              );
                            });
                          } else {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
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

  Widget _buildCreateAdminButton(BuildContext context, VoidCallback onTap) {
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
          BoxShadow(
            color: orange.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: -2,
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
                    Icons.person_add_sharp,
                    color: orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "create_admin".tr(),
                  style: TextStyle(
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
