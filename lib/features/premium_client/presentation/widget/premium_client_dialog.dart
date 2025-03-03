import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/drop_down_button_form_field_widget.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/premium_client_model.dart';

void AddPremiumClientDialog(BuildContext context, Function(PremiumClient) add) {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
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
            title: Text("add".tr(),style: const TextStyle(color: darkNavy),),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextFieldDialog(
                    controller: firstName,
                    labelText: "first_name".tr(),
                    isPassword: false,
                  ),
                  MyTextFieldDialog(
                    controller: lastName,
                    labelText: "last_name".tr(),
                    isPassword: false,
                  ),
                  MyTextFieldDialog(
                    controller: email,
                    labelText: "email".tr(),
                    isPassword: false,
                  ),
                  // MyTextFieldDialog(
                  //   controller: password,
                  //   labelText: "password".tr(),
                  //   isPassword: true,
                  // ),
                  MyTextFieldDialog(
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
                  MyTextFieldDialog(
                    controller: study,
                    labelText: "study".tr(),
                    isPassword: false,
                  ),
                  MyTextFieldDialog(
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
                          password: phoneNumber.text,
                          phoneNumber: phoneNumber.text,
                          gender: selectedRole,
                          study: study.text,
                          birthDate: birthDate.text,
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
