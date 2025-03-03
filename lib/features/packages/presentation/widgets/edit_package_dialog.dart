import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/packages/data/models/edit_package_model.dart';

void editPackageDialog(BuildContext context,PackageModel package , Function(PackageModel) edit) {
  final TextEditingController hoursController = TextEditingController(text: package.numOfHours.toString());
  final TextEditingController priceController = TextEditingController(text: package.price.toString());
  final TextEditingController descriptionController = TextEditingController(text: package.description);
  final TextEditingController durationController = TextEditingController(text: package.packageDurationInDays.toString());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "edit".tr(),
          style: const TextStyle(color: darkNavy),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextFieldDialog(
                controller: descriptionController,
                labelText: "description".tr(),
                isPassword: false,
              ),
              MyTextFieldDialog(
                controller: hoursController,
                labelText: "num_of_hours".tr(),
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              MyTextFieldDialog(
                controller: durationController,
                labelText: "packageDurationInDays".tr(),
                isPassword: false,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              MyTextFieldDialog(
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
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
            ),
            onPressed: () {
              if (hoursController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  durationController.text.isNotEmpty) {
                edit(PackageModel(
                    numOfHours: int.parse(hoursController.text),
                    price: double.parse(priceController.text),
                    description: descriptionController.text,
                    packageDurationInDays: int.parse(durationController.text),
                    active: true));
              }
              Navigator.of(context).pop();
            },
            child: Text(
              "edit_package".tr(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      );
    },
  );
}


