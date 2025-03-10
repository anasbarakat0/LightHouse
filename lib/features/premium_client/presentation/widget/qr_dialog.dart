import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/premium_client/data/models/get_all_premiumClient_response_model.dart';

void premiumClientInfo(BuildContext context, Body client) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        
        title:  Text(
          'client_info'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
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
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      "last_name".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "email".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "phone_number".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "study".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "gender".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      "birth_date".tr(),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      client.firstName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.lastName,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.email,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.phoneNumber,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.study,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.gender,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Text(
                      client.birthDate.toString(),
                      style: Theme.of(context).textTheme.labelLarge,
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
                  colors: QrColors(dark: QrColorSolid(darkNavy)),
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
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(

                            color: Colors.red[900],
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
                              color: orange,
                              width: 1),
                        ),
                        child: Text(
                          "edit".tr(),
                          style:Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: orange,

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
                      color: orange),
                  child:  Text(
                    "done".tr(),
                    style: Theme.of(context).textTheme.labelLarge,
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
