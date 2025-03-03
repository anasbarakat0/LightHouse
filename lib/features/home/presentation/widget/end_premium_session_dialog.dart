import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/presentation/widget/fields.dart';

void endSessionDialog(
    BuildContext context, Body sessionData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'session_info'.tr(),
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: darkNavy,
          ),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildDetailRow("${"date".tr()}: ", sessionData.date),
              buildDetailRow("${"started_at".tr()}: ", sessionData.startTime),
              buildDetailRow("${"first_name".tr()}: ", sessionData.firstName),
              buildDetailRow("${"last_name".tr()}: ", sessionData.lastName),
              // buildDetailRow(
              //     "${"created_by".tr()}: ", sessionData.createdBy.firstName),
              buildDetailRow("${"buffetInvoicePrice".tr()}: ",
                  "${sessionData.buffetInvoicePrice.toString()} ${"s.p".tr()}"),
              Divider(thickness: 0.5, color: navy),
              Text(
                "buffet_invoice".tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: sessionData.buffetInvoices.map((invoice) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: lightGrey,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Column(
                                  children: invoice.orders.map((order) {
                                    return buildProductDetailRow(
                                        order.productName,
                                        order.quantity,
                                        order.price);
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${"invoice_price".tr()}: ${invoice.totalPrice}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        actions: [
          buildTotalPriceRow(sessionData.totalPrice),
          
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: orange,
                ),
                child: Text(
                  "done".tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
