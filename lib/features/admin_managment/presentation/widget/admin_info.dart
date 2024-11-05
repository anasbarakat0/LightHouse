import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/admin_managment/data/models/admin_info_model.dart';

void showAdminInfo(BuildContext context, AdminInfoModel admin) {
  showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title:  Text(
            "admin_info".tr(),
            style: const TextStyle(color: backgroundColor),
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "first_name".tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "last_name".tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "email".tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      "role".tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin.id,
                      style: const TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      admin.firstName,
                      style: const TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      admin.lastName,
                      style: const TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      admin.email,
                      style: const TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      admin.role,
                      style: const TextStyle(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}