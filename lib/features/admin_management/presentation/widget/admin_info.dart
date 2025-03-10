import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/data/models/admin_info_model.dart';

void showAdminInfo(BuildContext context, AdminInfoModel admin) {
  showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            "admin_info".tr(),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: darkNavy),
          ),
          backgroundColor: Colors.white,
          content: FittedBox(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "id".tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "first_name".tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "last_name".tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "email".tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      "role".tr(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      ":",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      ":",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      ":",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      ":",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      ":",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin.id,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      admin.firstName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      admin.lastName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      admin.email,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      admin.role == "SuperAdmin"
                          ? "supper_admin".tr()
                          : admin.role == "MANAGER"
                              ? "manager".tr()
                              : "admin".tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
