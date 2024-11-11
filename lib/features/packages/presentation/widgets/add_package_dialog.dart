import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse_/common/widget/text_field_widget.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/packages/data/models/edit_package_model.dart';

void createPackageDialog(BuildContext context, Function(PackageModel) add) {
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "add".tr(),
          style: TextStyle(color: backgroundColor),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: descriptionController,
                labelText: "description".tr(),
                isPassword: false,
              ),
              MyTextField(
                controller: hoursController,
                labelText: "num_of_hours".tr(),
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              MyTextField(
                controller: durationController,
                labelText: "packageDurationInDays".tr(),
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              MyTextField(
                controller: priceController,
                labelText: "Price".tr(),
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            onPressed: () {
              if (hoursController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  durationController.text.isNotEmpty) {
                add(PackageModel(
                    numOfHours: int.parse(hoursController.text),
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    packageDurationInDays: int.parse(durationController.text),
                    active: true));
              }
              Navigator.of(context).pop();
            },
            child: Text(
              "add_package".tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      );
    },
  );
}



// void AddPremiumClientDialog(BuildContext context, Function(PremiumClient) add) {
//   TextEditingController firstName = TextEditingController();
//   TextEditingController lastName = TextEditingController();
//   TextEditingController email = TextEditingController();
//   TextEditingController password = TextEditingController();
//   TextEditingController phoneNumber = TextEditingController();
//   TextEditingController study = TextEditingController();
//   TextEditingController birthDate = TextEditingController();
//   String selectedRole = "MALE";
//   DateTime selectedDate = DateTime.now();

//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(builder: (context, setState) {
//           Future<void> selectDate(BuildContext context) async {
//             final DateTime? pickedDate = await showDatePicker(
//               context: context,
//               initialDate: selectedDate, // Current date as initial date
//               firstDate: DateTime(2000), // Set the starting year
//               lastDate: DateTime(2101), // Set the ending year
//             );

//             if (pickedDate != null && pickedDate != selectedDate) {
//               setState(() {
//                 selectedDate = pickedDate; // Update the selected date
//                 birthDate.text = DateFormat('yyyy-MM-dd').format(selectedDate);
//               });
//             }
//           }

//           return AlertDialog(
//             title: Text("add".tr()),
//             backgroundColor: Colors.white,
//             content: SizedBox(
//               width: 300,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   MyTextField(
//                     controller: firstName,
//                     labelText: "first_name".tr(),
//                     isPassword: false,
//                   ),
//                   MyTextField(
//                     controller: lastName,
//                     labelText: "last_name".tr(),
//                     isPassword: false,
//                   ),
//                   MyTextField(
//                     controller: email,
//                     labelText: "email".tr(),
//                     isPassword: false,
//                   ),
//                   MyTextField(
//                     controller: password,
//                     labelText: "password".tr(),
//                     isPassword: true,
//                   ),
//                   MyTextField(
//                     controller: phoneNumber,
//                     labelText: "phone_number".tr(),
//                     isPassword: false,
//                   ),
//                   MyDropdownButtonFormField(
//                     labelText: "gender".tr(),
//                     selectedValue: selectedRole,
//                     onChanged: (String? newValue) {
//                       if (newValue != null) {
//                         selectedRole = newValue;
//                       }
//                     },
//                     items: [
//                       DropdownMenuItem(
//                         value: 'MALE',
//                         child: Text('male'.tr()),
//                       ),
//                       DropdownMenuItem(
//                         value: 'FEMALE',
//                         child: Text('female'.tr()),
//                       ),
//                     ],
//                   ),
//                   MyTextField(
//                     controller: study,
//                     labelText: "study".tr(),
//                     isPassword: false,
//                   ),
//                   MyTextField(
//                     controller: birthDate,
//                     labelText: "birth_date".tr(),
//                     isPassword: false,
//                     readOnly: true,
//                     onTap: () async {
//                       await selectDate(context);
//                     },
//                   ),
                  
//                 ],
//               ),
//             ),
//           );
//         });
//       });
// }
