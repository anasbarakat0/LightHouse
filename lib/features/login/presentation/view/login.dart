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
import 'package:lighthouse/features/main_window/presentation/view/main_screen.dart';

class LoginWindows extends StatefulWidget {
  const LoginWindows({super.key});

  @override
  State<LoginWindows> createState() => _LoginWindowsState();
}

class _LoginWindowsState extends State<LoginWindows>
    with SingleTickerProviderStateMixin {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHovered = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

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
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: Responsive.isMobile(context)
                      ? [
                          Colors.white,
                          lightGrey,
                        ]
                      : [
                          darkNavy,
                          const Color(0xFF0A1A2E),
                          darkNavy,
                        ],
                ),
              ),
              child: SafeArea(
                child: Responsive.isMobile(context)
                    ? _buildMobileView(context)
                    : Responsive.isTablet(context)
                        ? _buildTabletView(context)
                        : _buildDesktopView(context),
              ),
            ),
          );
        },
      ),
    );
  }

  /// **🔹 Mobile Layout**
  Widget _buildMobileView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildLogo(context, MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: 48),
              _buildLoginCard(context, isMobile: true),
            ],
          ),
        ),
      ),
    );
  }

  /// **🔹 Tablet Layout**
  Widget _buildTabletView(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(context, 280),
                  const SizedBox(height: 48),
                  _buildLoginCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// **🔹 Desktop Layout (1366x768 optimized)**
  Widget _buildDesktopView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallDesktop = screenWidth <= 1366 && screenHeight <= 768;

    return Row(
      children: [
        // Left side - Login Form
        Expanded(
          flex: isSmallDesktop ? 5 : (screenWidth > 1366 ? 5 : 4),
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lightGrey,
                  Colors.white,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallDesktop
                        ? 60
                        : (screenWidth > 1366 ? 120 : 80),
                    vertical: isSmallDesktop ? 20 : 40,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isSmallDesktop ? 450 : 500,
                      maxHeight: isSmallDesktop ? screenHeight - 40 : double.infinity,
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLogo(
                            context,
                            isSmallDesktop ? 250 : 300,
                          ),
                          SizedBox(height: isSmallDesktop ? 40 : 56),
                          _buildLoginCard(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Right side - Illustration
        Expanded(
          flex: isSmallDesktop ? 7 : (screenWidth > 1366 ? 7 : 6),
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  darkNavy,
                  const Color(0xFF0A1A2E),
                  navy,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Animated background elements - optimized for small screens
                Positioned(
                  top: isSmallDesktop ? -80 : -100,
                  right: isSmallDesktop ? -80 : -100,
                  child: Container(
                    width: isSmallDesktop ? 300 : 400,
                    height: isSmallDesktop ? 300 : 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          orange.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: isSmallDesktop ? -120 : -150,
                  left: isSmallDesktop ? -120 : -150,
                  child: Container(
                    width: isSmallDesktop ? 400 : 500,
                    height: isSmallDesktop ? 400 : 500,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          yellow.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // SVG Illustration - optimized for 1366x768
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallDesktop ? 40 : 60),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SvgPicture.asset(
                        "assets/svg/lighthouse_ch.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// **🔹 Modern Login Card**
  Widget _buildLoginCard(BuildContext context, {bool isMobile = false}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallDesktop = !isMobile && screenHeight <= 768;

    return Container(
      padding: EdgeInsets.all(
        isMobile
            ? 28
            : (isSmallDesktop ? 32 : 40),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "log_in".tr(),
              style: TextStyle(
                fontSize: isMobile
                    ? 32
                    : (isSmallDesktop ? 32 : 36),
                fontWeight: FontWeight.w800,
                color: darkNavy,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            if (!isMobile)
              Text(
                "login_page_script".tr(),
                style: TextStyle(
                  fontSize: isSmallDesktop ? 15 : 16,
                  color: Colors.grey[600],
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              ),
            if (!isMobile)
              SizedBox(height: isSmallDesktop ? 32 : 40),
            if (isMobile) const SizedBox(height: 32),
            // Email Field
            _buildModernInputField(
              context,
              "email".tr(),
              email,
              "Example@email.com",
              Icons.email_outlined,
            ),
            SizedBox(height: isSmallDesktop ? 16 : 20),
            // Password Field
            _buildModernInputField(
              context,
              "password".tr(),
              password,
              "Password",
              Icons.lock_outline,
              isPassword: true,
              onSubmitted: _performLogin,
            ),
            SizedBox(height: isSmallDesktop ? 24 : 32),
            // Login Button
            _buildModernLoginButton(context),
          ],
        ),
      ),
    );
  }

  /// **🔹 Modern Input Field**
  Widget _buildModernInputField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    VoidCallback? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: darkNavy,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: isPassword ? _obscurePassword : false,
            textInputAction: isPassword ? TextInputAction.done : TextInputAction.next,
            onSubmitted: isPassword && onSubmitted != null
                ? (_) => onSubmitted()
                : null,
            style: TextStyle(
              fontSize: 16,
              color: darkNavy,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.grey[500],
                size: 22,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[500],
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: orange,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// **🔹 Perform Login Action**
  void _performLogin() {
    if (_formKey.currentState?.validate() ?? true) {
      context.read<LoginBloc>().add(
            Login(
              user: LoginModel(
                email: email.text,
                password: password.text,
              ),
            ),
          );
    }
  }

  /// **🔹 Modern Login Button**
  Widget _buildModernLoginButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else if (state is LoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.redAccent[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              content: Text(
                state.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isHovered
                    ? [
                        orange,
                        Color(0xFFFF9500),
                      ]
                    : [
                        orange,
                        Color(0xFFEB8317),
                      ],
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: orange.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: orange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 0,
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading
                    ? null
                    : _performLogin,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "log_in".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// **🔹 Logo Widget**
  Widget _buildLogo(BuildContext context, double width) {
    return Hero(
      tag: 'logo',
      child: SvgPicture.asset(
        width: width,
        context.locale.languageCode == "en"
            ? "assets/svg/dark-en-logo.svg"
            : "assets/svg/dark-ar-logo.svg",
      ),
    );
  }
}
