import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/common/widget/text_field_widget.dart';

void startExpressSession(BuildContext context, Function(String) add) {
  TextEditingController fullName = TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "add".tr(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MyTextFieldDialog(
                    controller: fullName,
                    labelText: "first_name".tr(),
                    isPassword: false,
                    onSubmitted: (fullName) {
                      add(fullName);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
          actions: [
            MyButton(
              onPressed: () {
                add(fullName.text);
                Navigator.of(context).pop();
              },
              child: Text(
                "add_session".tr(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        );
      });
}
