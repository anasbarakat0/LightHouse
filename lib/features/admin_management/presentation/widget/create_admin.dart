import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/admin_management/data/models/new_admin_model.dart';
import 'package:lighthouse/common/widget/drop_down_button_form_field_widget.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';

void createAdmin(BuildContext context, Function(NewAdminModel) admin) {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String selectedRole = "ADMIN";
  showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            "create_admin".tr(),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: darkNavy),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFieldDialog(
                controller: firstName,
                labelText: 'first_name'.tr(),
                isPassword: false,
              ),
              MyTextFieldDialog(
                controller: lastName,
                labelText: 'last_name'.tr(),
                isPassword: false,
              ),
              MyTextFieldDialog(
                controller: email,
                labelText: 'email'.tr(),
                isPassword: false,
              ),
              MyTextFieldDialog(
                controller: password,
                labelText: 'password'.tr(),
                isPassword: true,
              ),
              MyDropdownButtonFormField(
                labelText: "role".tr(),
                selectedValue: selectedRole,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    selectedRole = newValue;
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'SuperAdmin',
                    child: Text(
                      'supper_admin'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'MANAGER',
                    child: Text(
                      'manager'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'ADMIN',
                    child: Text(
                      'admin'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            MyButton(
              onPressed: () {
                admin(
                  NewAdminModel(
                    firstName: firstName.text,
                    lastName: lastName.text,
                    email: email.text,
                    password: password.text,
                    role: selectedRole,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text(
                "create".tr(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        );
      });
}
