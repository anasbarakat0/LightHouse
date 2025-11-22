// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/data/models/admin_info_model.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/admin_info.dart';

// ignore: must_be_immutable
class AdminCard extends StatelessWidget {
  final AdminInfoModel adminInfoModel;
  void Function(BuildContext) onPressedDelete;
  void Function(BuildContext) onPressedEdit;
  AdminCard({
    super.key,
    required this.adminInfoModel,
    required this.onPressedDelete,
    required this.onPressedEdit,
  });

  Color _getRoleColor(String role) {
    switch (role) {
      case "SuperAdmin":
        return orange;
      case "MANAGER":
        return yellow;
      default:
        return navy;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case "SuperAdmin":
        return "supper_admin".tr();
      case "MANAGER":
        return "manager".tr();
      default:
        return "admin".tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleColor = _getRoleColor(adminInfoModel.role);
    final fullName = "${adminInfoModel.firstName.replaceFirst(adminInfoModel.firstName[0], adminInfoModel.firstName[0].toUpperCase())} ${adminInfoModel.lastName.replaceFirst(adminInfoModel.lastName[0], adminInfoModel.lastName[0].toUpperCase())}";
    final canDelete = adminInfoModel.role == "ADMIN";

    return Slidable(
      key: ValueKey(adminInfoModel.id),
      startActionPane: canDelete
          ? ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: onPressedDelete,
                  label: "delete".tr(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  icon: Icons.delete_outline,
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ],
            )
          : null,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: onPressedEdit,
            label: "edit_password".tr(),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            icon: Icons.edit_outlined,
            backgroundColor: orange,
            foregroundColor: Colors.white,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            onTap: () => showAdminInfo(context, adminInfoModel),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          roleColor.withOpacity(0.3),
                          roleColor.withOpacity(0.15),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: roleColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: roleColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Name and Email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 12,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                adminInfoModel.email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          roleColor.withOpacity(0.25),
                          roleColor.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: roleColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getRoleLabel(adminInfoModel.role),
                      style: TextStyle(
                        color: roleColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
