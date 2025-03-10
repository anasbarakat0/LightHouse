import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';

void errorMessage(BuildContext context, String title, List<String> messages) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: darkNavy),
        ),
        backgroundColor: Colors.white,
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: List.generate(messages.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red[100]),
                      child: ListTile(
                        title: Text(
                          messages[index],
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: darkNavy),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child:  Text("back".tr()),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
