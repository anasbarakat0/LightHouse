import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lighthouse_/common/widget/drop_down_button_form_field_widget.dart';
import 'package:lighthouse_/common/widget/text_field_widget.dart';
import 'package:lighthouse_/features/premium_client/data/models/premium_client_model.dart';

void AddPremiumClientDialog(BuildContext context, Function(PremiumClient) add) {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController study = TextEditingController();
  TextEditingController birthDate = TextEditingController();
  String selectedRole = "MALE";
  DateTime selectedDate = DateTime.now();

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          Future<void> selectDate(BuildContext context) async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate, // Current date as initial date
              firstDate: DateTime(2000), // Set the starting year
              lastDate: DateTime(2101), // Set the ending year
            );

            if (pickedDate != null && pickedDate != selectedDate) {
              setState(() {
                selectedDate = pickedDate; // Update the selected date
                birthDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
              });
            }
          }

          return AlertDialog(
            title: Text("add".tr()),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextField(
                    controller: firstName,
                    labelText: "first_name".tr(),
                    isPassword: false,
                  ),
                  MyTextField(
                    controller: lastName,
                    labelText: "last_name".tr(),
                    isPassword: false,
                  ),
                  MyTextField(
                    controller: email,
                    labelText: "email".tr(),
                    isPassword: false,
                  ),
                  MyTextField(
                    controller: password,
                    labelText: "password".tr(),
                    isPassword: true,
                  ),
                  MyTextField(
                    controller: phoneNumber,
                    labelText: "phone_number".tr(),
                    isPassword: false,
                  ),
                  MyDropdownButtonFormField(
                    labelText: "gender".tr(),
                    selectedValue: selectedRole,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedRole = newValue;
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'MALE',
                        child: Text('male'.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'FEMALE',
                        child: Text('female'.tr()),
                      ),
                    ],
                  ),
                  MyTextField(
                    controller: study,
                    labelText: "study".tr(),
                    isPassword: false,
                  ),
                  MyTextField(
                    controller: birthDate,
                    labelText: "birth_date".tr(),
                    isPassword: false,
                    readOnly: true,
                    onTap: () async {
                      await selectDate(context);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      add(
                        PremiumClient(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          email: email.text,
                          password: password.text,
                          phoneNumber: phoneNumber.text,
                          gender: selectedRole,
                          study: study.text,
                          birthDate: '',
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "add_client".tr(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      });
}
