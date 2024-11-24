import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse_/common/widget/gradient_scaffold.dart';
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
          return GradientScaffold(
            body: Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: lightGrey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 140),
                      child: SizedBox(
                        width: 440,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              width: MediaQuery.of(context).size.width / 5,
                              context.locale.languageCode == "en"
                                  ? "assets/svg/dark-en-logo.svg"
                                  : "assets/svg/dark-ar-logo.svg",
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 80),
                                Text(
                                  "log_in".tr(),
                                  style: const TextStyle(
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                    color: navy,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "login_page_script".tr(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    color: navy,
                                  ),
                                ),
                                const SizedBox(height: 45),
                                Text(
                                  "email".tr(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: navy,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                MyTextField(
                                    controller: email,
                                    hint: "Example@email.com",
                                    dark: true,),
                                const SizedBox(height: 10),
                                Text(
                                  "password".tr(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                    color: navy,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                MyPasswordTextField(
                                    controller: password, hint: "Password",dark: true),
                                const SizedBox(height: 85),
                                BlocConsumer<LoginBloc, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginSuccess) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreen(),
                                        ),
                                      );
                                    } else if (state is LoginFailed) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                      child: Container(
                                        height: 69,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: orange,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "log_in".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Container(
                    padding: EdgeInsets.all(100),
                    child: SvgPicture.asset(
                      "assets/svg/lighthouse_ch.svg",
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
