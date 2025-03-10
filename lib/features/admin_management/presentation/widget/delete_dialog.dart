import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/common/widget/my_button.dart';
import 'package:lighthouse/core/resources/colors.dart';

void deleteMessage(
    BuildContext context, void Function() delet, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "delete".tr(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: darkNavy),
              ),
              const SizedBox(height: 20),
              
            ],
          ),
        ),
        // actionsOverflowButtonSpacing: 20,
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          
          MyButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
            side: const BorderSide(
              width: 1.5,
              color: orange,
            ),
            child: Text(
              "back".tr(),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: orange),
            ),
          ),
          MyButton(
            onPressed: () {
               delet();
                          Navigator.of(context).pop();
            },
            color: const Color.fromRGBO(183, 28, 28, 1),
            child: Text(
              "delete".tr(),
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
