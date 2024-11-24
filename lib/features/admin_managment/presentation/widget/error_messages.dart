import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';

void errorMessage(BuildContext context, String titel, List<String> messages) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          titel,
          style: const TextStyle(color: darkNavy),
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
                          style: const TextStyle(
                            color: darkNavy,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
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
