import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/admin_managment/data/models/new_admin_model.dart';
import 'package:lighthouse_/common/widget/drop_down_button_form_field_widget.dart';
import 'package:lighthouse_/common/widget/text_field_widget.dart';

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
            style: const TextStyle(color: backgroundColor),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextField(
                controller: firstName,
                labelText: 'first_name'.tr(),
                isPassword: false,
              ),
              MyTextField(
                controller: lastName,
                labelText: 'last_name'.tr(),
                isPassword: false,
              ),
              MyTextField(
                controller: email,
                labelText: 'email'.tr(),
                isPassword: false,
              ),
              MyTextField(
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
                    child: Text('supper_admin'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'MANAGER',
                    child: Text('manager'.tr()),
                  ),
                  DropdownMenuItem(
                    value: 'ADMIN',
                    child: Text('admin'.tr()),
                  ),
                ],
              ),
              ElevatedButton(
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
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
        );
      });
}
