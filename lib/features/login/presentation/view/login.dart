import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/features/login/data/models/login_model.dart';
import 'package:lighthouse/features/login/data/repository/login_repo.dart';
import 'package:lighthouse/features/login/data/sources/remote/login_service.dart';
import 'package:lighthouse/features/login/domain/usecase/login_usecase.dart';
import 'package:lighthouse/features/login/presentation/bloc/login_bloc.dart';
import 'package:lighthouse/features/login/presentation/widget/password_text_field.dart';
import 'package:lighthouse/features/login/presentation/widget/textfield.dart';
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';

class LoginWindows extends StatefulWidget {
  const LoginWindows({super.key});

  @override
  State<LoginWindows> createState() => _LoginWindowsState();
}

class _LoginWindowsState extends State<LoginWindows> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        LoginUsecase(
          loginRepo: LoginRepo(
            LoginService(dio: Dio()),
            NetworkConnection(
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
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor:
                Responsive.isMobile(context) ? Colors.white : darkNavy,
            body: SingleChildScrollView(
              child: Responsive.isMobile(context)
                  ? _buildMobileView(context)
                  : _buildDesktopView(context),
            ),
          );
        },
      ),
    );
  }

  /// **🔹 Mobile Layout**
  Widget _buildMobileView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          _buildLogo(context, MediaQuery.of(context).size.width / 1.5),
          _buildLoginForm(context),
        ],
      ),
    );
  }

  /// **🔹 Desktop Layout**
  Widget _buildDesktopView(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: lightGrey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: SizedBox(
                width: 440,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(context, MediaQuery.of(context).size.width / 5),
                    _buildLoginForm(context),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width / 2,
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: SvgPicture.asset("assets/svg/lighthouse_ch.svg"),
          ),
        ),
      ],
    );
  }

  /// **🔹 Common: Login Form**
  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Text(
          "log_in".tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        if (!Responsive.isMobile(context))
          Text(
            "login_page_script".tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        const SizedBox(height: 45),
        _buildInputField("email".tr(), email, "Example@email.com"),
        const SizedBox(height: 10),
        _buildInputField("password".tr(), password, "Password",
            isPassword: true),
        const SizedBox(height: 45),
        _buildLoginButton(context),
      ],
    );
  }

  /// **🔹 Common: Logo Widget**
  Widget _buildLogo(BuildContext context, double width) {
    return SvgPicture.asset(
      width: width,
      context.locale.languageCode == "en"
          ? "assets/svg/dark-en-logo.svg"
          : "assets/svg/dark-ar-logo.svg",
    );
  }

  /// **🔹 Common: Input Field**
  Widget _buildInputField(
      String label, TextEditingController controller, String hint,
      {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 10),
        isPassword
            ? MyPasswordTextField(
                controller: controller, hint: hint, dark: true)
            : MyTextField(controller: controller, hint: hint, dark: true),
      ],
    );
  }

  /// **🔹 Common: Login Button**
  Widget _buildLoginButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MainScreen()));
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                backgroundColor: Colors.redAccent[700],
                content: Text(state.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white))),
          );
        }
      },
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<LoginBloc>().add(Login(
                user: LoginModel(email: email.text, password: password.text)));
          },
          child: Container(
            height: 69,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: orange),
            alignment: Alignment.center,
            child: Text(
              "log_in".tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }
}
