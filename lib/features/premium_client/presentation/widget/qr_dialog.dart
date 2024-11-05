import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse_/core/resources/colors.dart';
import 'package:lighthouse_/features/premium_client/data/models/get_all_premiumClient_response_model.dart';

void premiumClientInfo(BuildContext context, Body client) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        title:  Text(
          'client_info'.tr(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: backgroundColor,
          ),
        ),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          
          children: [
            Row(
              children: [
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "first_name".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "last_name".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "email".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "phone_number".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "study".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "gender".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                    Text(
                      "birth_date".tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.firstName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.lastName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.email,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.phoneNumber,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.study,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.gender,
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      client.birthDate.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomPaint(
              painter: QrPainter(
                data: client.qrCode.qrCode,
                options: const QrOptions(
                  colors: QrColors(dark: QrColorSolid(backgroundColor)),
                ),
              ),
              size: const Size(200, 200),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromRGBO(183, 28, 28, 1),
                              width: 1),
                        ),
                        child: Text(
                          "delete".tr(),
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromRGBO(255, 111, 0, 1),
                              width: 1),
                        ),
                        child: Text(
                          "edit".tr(),
                          style: TextStyle(
                            color: Colors.amber[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
           const  SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 56,
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor),
                  child:  Text(
                    "done".tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
