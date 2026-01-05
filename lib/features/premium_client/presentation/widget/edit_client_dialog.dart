import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lighthouse/common/widget/drop_down_button_form_field_widget.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';
import 'package:lighthouse/features/premium_client/data/models/update_premium_client_model.dart';

void showEditClientDialog(BuildContext context, Body client,
    Function(UpdatePremiumClientModel) onUpdate) {
  TextEditingController firstName =
      TextEditingController(text: client.firstName);
  TextEditingController lastName = TextEditingController(text: client.lastName);
  TextEditingController email = TextEditingController(text: client.email ?? '');
  TextEditingController phoneNumber =
      TextEditingController(text: client.phoneNumber ?? '');
  TextEditingController study = TextEditingController(text: client.study ?? '');
  TextEditingController birthDate = TextEditingController(
      text: client.birthDate is String ? client.birthDate : '');
  TextEditingController password =
      TextEditingController(text: client.generatedPassword);
  String selectedGender = client.gender;
  DateTime? selectedDate;

  // Parse birth date if it's a string
  if (client.birthDate is String && (client.birthDate as String).isNotEmpty) {
    try {
      selectedDate = DateTime.parse(client.birthDate as String);
    } catch (e) {
      selectedDate = null;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: orange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: navy,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate = picked;
      birthDate.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.edit, color: orange, size: 24),
                const SizedBox(width: 12),
                Text(
                  "edit_client".tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: navy,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width > 500 ? 400 : 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyTextFieldDialog(
                      controller: firstName,
                      labelText: "first_name".tr(),
                      isPassword: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: lastName,
                      labelText: "last_name".tr(),
                      isPassword: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: email,
                      labelText: "email".tr(),
                      isPassword: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: phoneNumber,
                      labelText: "phone_number".tr(),
                      isPassword: false,
                    ),
                    const SizedBox(height: 12),
                    MyDropdownButtonFormField(
                      labelText: "gender".tr(),
                      selectedValue: selectedGender,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'MALE',
                          child: Text(
                            'male'.tr(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'FEMALE',
                          child: Text(
                            'female'.tr(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: study,
                      labelText: "study".tr(),
                      isPassword: false,
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: birthDate,
                      labelText: "birth_date".tr(),
                      isPassword: false,
                      readOnly: true,
                      onTap: () async {
                        await selectDate(context);
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    MyTextFieldDialog(
                      controller: password,
                      labelText: "password".tr(),
                      isPassword: false,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "cancel".tr(),
                  style: TextStyle(color: grey),
                ),
              ),
              MyButton(
                onPressed: () {
                  // Validate email format if provided
                  if (email.text.trim().isNotEmpty) {
                    final emailRegex = RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(email.text.trim())) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("invalid_email_format".tr()),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  final passwordValue = password.text.trim().isEmpty
                      ? null
                      : password.text.trim();
                  print("🔹 Password from dialog: '$passwordValue'");
                  print("🔹 Password text field value: '${password.text}'");

                  final updateModel = UpdatePremiumClientModel(
                    firstName: firstName.text.trim().isEmpty
                        ? null
                        : firstName.text.trim(),
                    lastName: lastName.text.trim().isEmpty
                        ? null
                        : lastName.text.trim(),
                    email: email.text.trim().isEmpty ? null : email.text.trim(),
                    phoneNumber: phoneNumber.text.trim().isEmpty
                        ? null
                        : phoneNumber.text.trim(),
                    gender: selectedGender.isEmpty ? null : selectedGender,
                    study: study.text.trim().isEmpty ? null : study.text.trim(),
                    birthDate: birthDate.text.trim().isEmpty
                        ? null
                        : birthDate.text.trim(),
                    password: passwordValue,
                  );

                  print(
                      "🔹 Update Model password field: ${updateModel.password}");
                  print("🔹 Update Model toMap: ${updateModel.toMap()}");

                  onUpdate(updateModel);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "save".tr(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
