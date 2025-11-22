import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/core/resources/colors.dart' as AppColors;
import 'package:lighthouse/features/setting/data/models/change_password_model.dart';
import 'package:lighthouse/features/setting/presentation/bloc/change_password_bloc.dart';
import 'package:lighthouse/features/setting/presentation/widget/password_field_widget.dart';

void showChangePasswordDialog(BuildContext context) {
  // Get the bloc from the parent context
  final changePasswordBloc = context.read<ChangePasswordBloc>();

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.6),
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: changePasswordBloc,
        child: _ChangePasswordDialogContent(),
      );
    },
  );
}

class _ChangePasswordDialogContent extends StatefulWidget {
  @override
  State<_ChangePasswordDialogContent> createState() =>
      _ChangePasswordDialogContentState();
}

class _ChangePasswordDialogContentState
    extends State<_ChangePasswordDialogContent> {
  late final TextEditingController currentPassword;
  late final TextEditingController newPassword;
  late final TextEditingController confirmPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentPassword = TextEditingController();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state is SuccessChangePassword) {
          Navigator.of(context).pop();
          currentPassword.clear();
          newPassword.clear();
          confirmPassword.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[800],
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
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is ExceptionChangePassword) {
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
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is OfflineFailureChangePassword) {
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
                          .bodySmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (context, state) {
          final bool isLoading = state is LoadingChangePassword;
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.98),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: orange.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with gradient
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            orange,
                            orange.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.lock_reset,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "change_password".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Update your account password".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 13,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Form Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Current Password
                            _buildSectionTitle(
                                "current_password".tr(), Icons.lock_outline),
                            const SizedBox(height: 8),
                            PasswordFieldWidget(
                              controller: currentPassword,
                              label: "current_password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "current_password_required".tr();
                                }
                                if (value.length < 6) {
                                  return "password_min_length".tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            // New Password
                            _buildSectionTitle(
                                "new_password".tr(), Icons.lock_open),
                            const SizedBox(height: 8),
                            PasswordFieldWidget(
                              controller: newPassword,
                              label: "new_password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "new_password_required".tr();
                                }
                                if (value.length < 8) {
                                  return "password_must_be_at_least_8_characters"
                                      .tr();
                                }
                                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                                    .hasMatch(value)) {
                                  return "password_must_contain_uppercase_lowercase_and_number"
                                      .tr();
                                }
                                if (value == currentPassword.text) {
                                  return "new_password_must_be_different".tr();
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (confirmPassword.text.isNotEmpty) {
                                  _formKey.currentState?.validate();
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            // Password requirements hint
                            Padding(
                              padding: const EdgeInsets.only(left: 12, top: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 14, color: grey),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "Must contain uppercase, lowercase and number"
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Confirm Password
                            _buildSectionTitle(
                                "confirm_password".tr(), Icons.verified_user),
                            const SizedBox(height: 8),
                            PasswordFieldWidget(
                              controller: confirmPassword,
                              label: "confirm_password",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "confirm_password_required".tr();
                                }
                                if (value != newPassword.text) {
                                  return "passwords_do_not_match".tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            Navigator.of(context).pop();
                                            currentPassword.clear();
                                            newPassword.clear();
                                            confirmPassword.clear();
                                          },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      side: BorderSide(
                                          color: grey.withOpacity(0.3),
                                          width: 1.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      "cancel".tr(),
                                      style: TextStyle(
                                        color: isLoading ? grey : navy,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  // flex: 2,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? () {}
                                        : () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context
                                                  .read<ChangePasswordBloc>()
                                                  .add(
                                                    ChangePassword(
                                                      changePasswordModel:
                                                          ChangePasswordModel(
                                                        currentPassword:
                                                            currentPassword
                                                                .text,
                                                        newPassword:
                                                            newPassword.text,
                                                        confirmPassword:
                                                            confirmPassword
                                                                .text,
                                                      ),
                                                    ),
                                                  );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLoading
                                          ? orange.withOpacity(0.6)
                                          : orange,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      elevation: isLoading ? 0 : 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.navy),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.check_circle_outline,
                                                color: AppColors.navy,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                "change_password".tr(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge
                                                    ?.copyWith(
                                                      color: AppColors.navy,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
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
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: orange),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: navy,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
