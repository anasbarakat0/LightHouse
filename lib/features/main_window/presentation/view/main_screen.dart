import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lighthouse/core/error/failure.dart';
import 'package:lighthouse/core/network/network_connection.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/utils/responsive.dart';
import 'package:lighthouse/core/utils/shared_preferences.dart';
import 'package:lighthouse/core/utils/app_shortcuts.dart';
import 'package:lighthouse/features/buffet/presentation/view/buffet_page.dart';
import 'package:lighthouse/features/coupons/presentation/view/coupons_page.dart';
import 'package:lighthouse/features/debts/presentation/view/debts_page.dart';
import 'package:lighthouse/features/home/presentation/view/home_screen.dart';
import 'package:lighthouse/features/login/data/models/login_model.dart';
import 'package:lighthouse/features/login/data/repository/login_repo.dart';
import 'package:lighthouse/features/login/data/sources/remote/login_service.dart';
import 'package:lighthouse/features/login/domain/usecase/login_usecase.dart';
import 'package:lighthouse/features/packages/presentation/view/packages_page.dart';
import 'package:lighthouse/features/premium_client/data/repository/admin_by_id_repo.dart';
import 'package:lighthouse/features/premium_client/data/source/remote/admin_by_id_service.dart';
import 'package:lighthouse/features/premium_client/domain/usecase/admin_by_id_usecase.dart';
import 'package:lighthouse/features/premium_client/presentation/view/premium_clients_page.dart';
import 'package:lighthouse/features/admin_management/presentation/view/admin_management.dart';
import 'package:lighthouse/features/login/presentation/view/login.dart';
import 'package:lighthouse/features/main_window/data/sources/menu_data.dart';
import 'package:lighthouse/features/main_window/presentation/widget/side_menu_bar.dart';
import 'package:lighthouse/features/main_window/presentation/widget/summary.dart';
import 'package:lighthouse/features/setting/presentation/view/settings_page.dart';
import 'package:lighthouse/features/statistics/presentation/view/statistics_page.dart';
import 'package:lighthouse/features/tasks/presentation/view/to_do_tasks.dart';
import 'package:lighthouse/features/dashboard/presentation/view/dashboard_page.dart';
import 'package:lighthouse/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const Set<int> _passwordProtectedPages = {0, 2, 4, 5, 6, 7, 9, 10};

  // GlobalKey to access HomeScreen's context
  final GlobalKey homeScreenKey = GlobalKey();
  // GlobalKey to access PremiumClientsPage's context
  final GlobalKey premiumClientsPageKey = GlobalKey();

  List<Widget> get selectedContentList => [
        const DashboardPage(),
        HomeScreen(key: homeScreenKey),
        const StatisticsPage(),
        PremiumClientsPage(key: premiumClientsPageKey),
        const DebtsPage(),
        const PackagesPage(),
        const CouponsPage(),
        const BuffetPage(),
        const ToDoTasks(),
        const AdminManagement(),
        const SettingsPage()
      ];

  int selectedIndex = 1;

  /// على الديسكتوب: هل لوحة الملخص مفتوحة (قابلة للفتح والإغلاق)
  bool _isSummaryOpen = false;
  bool _areProtectedPagesUnlocked = false;
  bool _isLockButtonHovered = false;

  @override
  void initState() {
    memory.get<SharedPreferences>().setInt("index", 1);
    super.initState();
  }

  void callFunction(int index) {
    onMenuItemSelected(index);
  }

  bool _isPasswordProtectedPage(int index) {
    return _passwordProtectedPages.contains(index);
  }

  // Helper function to check if user has access to a specific page
  bool _hasAccessToPage(int index) {
    final role =
        memory.get<SharedPreferences>().getString("userRole") ?? "USER";

    // Pages accessible only to SuperAdmin and MANAGER
    final restrictedPages = [
      0,
      2,
      5,
      6,
      9
    ]; // Dashboard, Statistics, Packages, Coupons, Admin Management

    if (restrictedPages.contains(index)) {
      return role == "SuperAdmin" || role == "MANAGER";
    }

    // Pages accessible to SuperAdmin, MANAGER, and ADMIN
    return role == "SuperAdmin" || role == "MANAGER" || role == "ADMIN";
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent[700],
        content: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Future<String?> _resolveCurrentUserEmail() async {
    final prefs = memory.get<SharedPreferences>();
    final storedEmail = prefs.getString("userEmail")?.trim();

    if (storedEmail != null && storedEmail.isNotEmpty) {
      return storedEmail;
    }

    final userId = prefs.getString("userId")?.trim();
    if (userId == null || userId.isEmpty) {
      return null;
    }

    final result = await AdminByIdUsecase(
      adminByIdRepo: AdminByIdRepo(
        adminByIdService: AdminByIdService(dio: Dio()),
        networkConnection: NetworkConnection.createDefault(
            timeout: const Duration(seconds: 10)),
      ),
    ).call(userId);

    return result.fold((failure) => null, (response) {
      final email = response.body.email?.trim();
      if (email == null || email.isEmpty) {
        return null;
      }

      prefs.setString("userEmail", email);
      return email;
    });
  }

  Future<String?> _verifyCurrentAccountPassword({
    required String email,
    required String password,
  }) async {
    final prefs = memory.get<SharedPreferences>();
    final currentUserId = prefs.getString("userId")?.trim();
    final normalizedEmail = email.trim().toLowerCase();

    final result = await LoginUsecase(
      loginRepo: LoginRepo(
        LoginService(dio: Dio()),
        NetworkConnection.createDefault(timeout: const Duration(seconds: 10)),
      ),
    ).call(
      LoginModel(
        email: email,
        password: password,
      ),
    );

    return result.fold((failure) {
      switch (failure) {
        case LoginFailure():
          return failure.message;
        case ServerFailure():
          return failure.message;
        case OfflineFailure():
          return "Check your network connection";
        default:
          return "account_verification_failed".tr();
      }
    }, (response) {
      final verifiedEmail = response.body.userInfo.email.trim().toLowerCase();
      final verifiedUserId = response.body.userInfo.id.trim();

      if (verifiedEmail != normalizedEmail) {
        return "account_mismatch".tr();
      }

      if (currentUserId != null &&
          currentUserId.isNotEmpty &&
          verifiedUserId != currentUserId) {
        return "account_mismatch".tr();
      }

      prefs.setString("userEmail", response.body.userInfo.email);
      return null;
    });
  }

  Future<bool> _showPasswordVerificationDialog(
    int index, {
    String? title,
  }) async {
    final currentEmail = await _resolveCurrentUserEmail();
    if (!mounted) {
      return false;
    }

    if (currentEmail == null || currentEmail.isEmpty) {
      _showErrorSnackBar("session_email_missing".tr());
      return false;
    }

    final passwordController = TextEditingController();
    String? errorMessage;
    bool obscurePassword = true;
    bool isSubmitting = false;
    final pageTitle = title ?? SideMenuData().menu[index].title;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future<void> submit(StateSetter setDialogState) async {
          final navigator = Navigator.of(dialogContext);
          final password = passwordController.text.trim();

          if (password.isEmpty) {
            setDialogState(() {
              errorMessage = "password_required".tr();
            });
            return;
          }

          setDialogState(() {
            isSubmitting = true;
            errorMessage = null;
          });

          final verificationError = await _verifyCurrentAccountPassword(
            email: currentEmail,
            password: password,
          );

          if (!mounted) {
            return;
          }

          if (verificationError == null) {
            navigator.pop(true);
            return;
          }

          setDialogState(() {
            isSubmitting = false;
            errorMessage = verificationError;
          });
        }

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Material(
                  color: Colors.white,
                  elevation: 22,
                  shadowColor: Colors.black.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 22, 16, 22),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [darkNavy, navy],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.18),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.admin_panel_settings_outlined,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "verify_access".tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Colors.white.withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        pageTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: "Cancel".tr(),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white70,
                                ),
                                onPressed: isSubmitting
                                    ? null
                                    : () =>
                                        Navigator.of(dialogContext).pop(false),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "enter_password_for_current_account".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: darkNavy.withValues(alpha: 0.82),
                                      fontSize: 14.5,
                                      height: 1.55,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F9FC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.black.withValues(alpha: 0.06),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: orange.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.person_outline_rounded,
                                        color: orange,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "current_account".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: grey,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currentEmail,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: darkNavy,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              TextField(
                                controller: passwordController,
                                obscureText: obscurePassword,
                                enabled: !isSubmitting,
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) {
                                  if (!isSubmitting) {
                                    submit(setDialogState);
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "password".tr(),
                                  hintText: "password".tr(),
                                  filled: true,
                                  fillColor: const Color(0xFFF7F9FC),
                                  prefixIcon: const Icon(
                                    Icons.lock_outline_rounded,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: isSubmitting
                                        ? null
                                        : () {
                                            setDialogState(() {
                                              obscurePassword =
                                                  !obscurePassword;
                                            });
                                          },
                                  ),
                                  labelStyle: TextStyle(
                                    color: darkNavy.withValues(alpha: 0.62),
                                  ),
                                  hintStyle: TextStyle(
                                    color: grey.withValues(alpha: 0.58),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.black.withValues(alpha: 0.08),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: orange,
                                      width: 1.5,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color:
                                          Colors.black.withValues(alpha: 0.06),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: errorMessage == null
                                    ? const SizedBox(height: 16)
                                    : Padding(
                                        key: ValueKey(errorMessage),
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: 4,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.red
                                                .withValues(alpha: 0.08),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.red
                                                  .withValues(alpha: 0.18),
                                            ),
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.error_outline_rounded,
                                                color: Colors.red.shade700,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  errorMessage!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color:
                                                            Colors.red.shade700,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () => Navigator.of(dialogContext)
                                              .pop(false),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: darkNavy,
                                        side: BorderSide(
                                          color:
                                              darkNavy.withValues(alpha: 0.14),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                      ),
                                      child: Text("Cancel".tr()),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: isSubmitting
                                          ? null
                                          : () => submit(setDialogState),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        backgroundColor: orange,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            orange.withValues(alpha: 0.62),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: isSubmitting
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.4,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.lock_open_rounded,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    "verify_and_open".tr(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Future<void>.delayed(
      const Duration(milliseconds: 300),
      passwordController.dispose,
    );
    return result ?? false;
  }

  void _openPage(int index) {
    memory.get<SharedPreferences>().setInt("index", index);
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _toggleProtectedPagesLock() async {
    if (_areProtectedPagesUnlocked) {
      setState(() => _areProtectedPagesUnlocked = false);
      _showErrorSnackBar("protected_pages_locked".tr());
      return;
    }

    final isVerified = await _showPasswordVerificationDialog(
      selectedIndex,
      title: "unlock_protected_pages".tr(),
    );

    if (!isVerified || !mounted) {
      return;
    }

    setState(() => _areProtectedPagesUnlocked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "protected_pages_unlocked".tr(),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  void onMenuItemSelected(int index) async {
    if (index == 11) {
      // Show confirmation dialog before signing out
      _showSignOutConfirmationDialog();
      return;
    }

    if (index == selectedIndex) {
      return;
    }

    if (!_hasAccessToPage(index)) {
      String message;
      if ([0, 2, 5, 6, 9].contains(index)) {
        message = "Only SuperAdmin and Manager Allowed";
      } else {
        message = "Only SuperAdmin, Manager, and Admin Allowed";
      }

      _showErrorSnackBar(message);
      return;
    }

    if (!_areProtectedPagesUnlocked && _isPasswordProtectedPage(index)) {
      final isVerified = await _showPasswordVerificationDialog(index);
      if (!isVerified || !mounted) {
        return;
      }
    }

    _openPage(index);
  }

  // Method to navigate to Home page (index 1)
  void navigateToHome() {
    onMenuItemSelected(1);
  }

  // Method to navigate to Clients page (index 3)
  void navigateToClients() {
    onMenuItemSelected(3);
  }

  // Check if currently on Home page
  bool isOnHomePage() {
    return selectedIndex == 1;
  }

  void _showSignOutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade800],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Sign Out".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Message
                Text(
                  "Are you sure you want to sign out?".tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: darkNavy,
                        fontSize: 16,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: grey.withValues(alpha: 0.5), width: 2),
                          ),
                        ),
                        child: Text(
                          "Cancel".tr(),
                          style: TextStyle(
                            color: grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          memory
                              .get<SharedPreferences>()
                              .setBool("auth", false);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginWindows(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Sign Out".tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  late String printerName = "XP-80C (copy 1)";
  late String printerAddress = "192.168.123.100";

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Builder(builder: (context) {
      return Shortcuts(
        shortcuts: getGlobalShortcuts(),
        child: Actions(
          actions: {
            NavigateToHomeIntent: CallbackAction<NavigateToHomeIntent>(
              onInvoke: (intent) {
                final mainScreenState =
                    mainScreenKey.currentState as _MainScreenState?;
                if (mainScreenState != null) {
                  mainScreenState.navigateToHome();
                }
                return null;
              },
            ),
            NavigateToClientsIntent: CallbackAction<NavigateToClientsIntent>(
              onInvoke: (intent) {
                final mainScreenState =
                    mainScreenKey.currentState as _MainScreenState?;
                if (mainScreenState != null) {
                  mainScreenState.navigateToClients();
                  // Wait for navigation and then focus on search field
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      final premiumClientsPageState =
                          mainScreenState.premiumClientsPageKey.currentState;
                      if (premiumClientsPageState != null) {
                        (premiumClientsPageState as dynamic).focusOnSearch();
                      }
                    });
                  });
                }
                return null;
              },
            ),
          },
          child: Focus(
            autofocus: true,
            child: Scaffold(
              backgroundColor: lightGrey,
              drawer: !isDesktop
                  ? SizedBox(
                      width: 250,
                      child: SideMenuWidget(changeindex: onMenuItemSelected),
                    )
                  : null,
              endDrawer: !Responsive.isDesktop(context)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SummaryWidget(),
                    )
                  : null,
              body: SafeArea(
                child: Row(
                  children: [
                    if (isDesktop)
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          child:
                              SideMenuWidget(changeindex: onMenuItemSelected),
                        ),
                      ),
                    Expanded(
                      flex: 7,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          selectedContentList[selectedIndex],
                          if (isDesktop)
                            PositionedDirectional(
                              top: 12,
                              end: 12,
                              child: _buildSummaryToggleButton(),
                            ),
                          PositionedDirectional(
                            bottom: 30,
                            end: 30,
                            child: _buildProtectedPagesLockButton(),
                          ),
                        ],
                      ),
                    ),
                    if (isDesktop && _isSummaryOpen)
                      const Expanded(
                        flex: 3,
                        child: SummaryWidget(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProtectedPagesLockButton() {
    final isUnlocked = _areProtectedPagesUnlocked;
    final iconColor = isUnlocked ? Colors.green.shade600 : grey;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isLockButtonHovered = true),
      onExit: (_) => setState(() => _isLockButtonHovered = false),
      child: Tooltip(
        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: navy),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        message: isUnlocked
            ? "lock_protected_pages".tr()
            : "unlock_protected_pages".tr(),
        child: Material(
          color: lightGrey,
          elevation: _isLockButtonHovered ? 3 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: _toggleProtectedPagesLock,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(
                isUnlocked
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                color: iconColor,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryToggleButton() {
    return Tooltip(
      textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: navy),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      message: _isSummaryOpen ? "close_summary".tr() : "open_summary".tr(),
      child: Material(
        color: lightGrey,
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() => _isSummaryOpen = !_isSummaryOpen);
          },
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Icon(
              _isSummaryOpen ? Icons.chevron_right : Icons.chevron_left,
              color: navy,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
