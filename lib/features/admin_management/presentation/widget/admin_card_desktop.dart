// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/data/models/admin_info_model.dart';
import 'package:lighthouse/features/admin_management/presentation/widget/admin_info.dart';

// ignore: must_be_immutable
class AdminCardDesktop extends StatelessWidget {
  final AdminInfoModel adminInfoModel;
  void Function() onPressedDelete;
  void Function() onPressedEdit;
  AdminCardDesktop({
    super.key,
    required this.adminInfoModel,
    required this.onPressedDelete,
    required this.onPressedEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => showAdminInfo(context, adminInfoModel),
              child: Container(
                height: 69,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: yellow),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "  ${adminInfoModel.firstName.replaceFirst(adminInfoModel.firstName[0], adminInfoModel.firstName[0].toUpperCase())} ${adminInfoModel.lastName.replaceFirst(adminInfoModel.lastName[0], adminInfoModel.lastName[0].toUpperCase())}",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 15),
                      Container(
                        height: 40,
                        width: 120,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: adminInfoModel.role == "SuperAdmin"
                              ? orange
                              : adminInfoModel.role == "MANAGER"
                                  ? yellow
                                  : navy,
                        ),
                        child: Text(
                          adminInfoModel.role == "SuperAdmin"
                              ? "supper_admin".tr()
                              : adminInfoModel.role == "MANAGER"
                                  ? "manager".tr()
                                  : "admin".tr(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onPressedDelete,
            child: Container(
              height: 69,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 1,
                  color: adminInfoModel.role == "ADMIN"
                      ? const Color.fromRGBO(183, 28, 28, 1)
                      : const Color.fromARGB(255, 99, 99, 99),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.delete),
                    const SizedBox(width: 10),
                    Text(
                      "delete".tr(),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
