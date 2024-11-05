import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/core/network/network_connection.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/login/data/models/login_model.dart';
import 'package:lighthouse_/features/login/data/repository/login_repo.dart';
import 'package:lighthouse_/features/login/data/sources/remote/login_service.dart';
import 'package:lighthouse_/features/login/domain/usecase/login_usecase.dart';
import 'package:lighthouse_/features/login/presentation/bloc/login_bloc.dart';
import 'package:lighthouse_/features/login/presentation/widget/password_text_field.dart';
import 'package:lighthouse_/features/login/presentation/widget/textfield.dart';
import 'package:lighthouse_/features/mian_screen/presentation/view/mian_screen.dart';

class LoginWindows extends StatefulWidget {
  const LoginWindows({super.key});

  @override
  State<LoginWindows> createState() => _LoginWindowsState();
}

class _LoginWindowsState extends State<LoginWindows> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(LoginUsecase(
          loginRepo: LoginRepo(
              LoginService(dio: Dio()),
              NetworkConnection(
                  internetConnectionChecker: InternetConnectionChecker())))),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140),
                    child: SizedBox(
                      width: 440,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 205),
                          Text("log_in".tr(),
                              style: Theme.of(context).textTheme.headlineLarge),
                          const SizedBox(height: 10),
                          Text("login_page_script".tr(),
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 45),
                          Text("email".tr(),
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 10),
                          MyTextField(
                              controller: email, hint: "Example@email.com"),
                          const SizedBox(height: 10),
                          Text("password".tr(),
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 10),
                          MyPasswordTextField(
                              controller: password, hint: "Password"),
                          const SizedBox(height: 85),
                          BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                );
                              } else if (state is LoginFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red[800],
                                    content: Text(state.message),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return InkWell(
                                onTap: () {
                                  context.read<LoginBloc>().add(
                                        Login(
                                          user: LoginModel(
                                            email: email.text,
                                            password: password.text,
                                          ),
                                        ),
                                      );
                                },
                                child: Expanded(
                                  child: Container(
                                    height: 69,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primaryColor,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "log_in".tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}