import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/get_express_session_response.dart';
import 'package:lighthouse/features/home/presentation/widget/fields.dart';

void expressSessionDialog(
    BuildContext context, ExpressSessionBody sessionData, void Function() onTap) {
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
              buildDetailRow("${"fullName".tr()}: ", sessionData.fullName),
              buildDetailRow(
                  "${"created_by".tr()}: ", sessionData.createdBy.firstName),
              buildDetailRow("${"buffetInvoicePrice".tr()}: ",
                  "${sessionData.buffetInvoicePrice.toString()} ${"s.p".tr()}"),
              // buildTotalPriceRow(sessionData.buffetInvoicePrice),
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
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 45,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: orange, width: 1),
                      ),
                      child: Text(
                        "edit".tr(),
                        style: TextStyle(
                          color: orange,
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
                  height: 45,
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: grey, width: 1),
                      ),
                      child: Text(
                        "back".tr(),
                        style: TextStyle(
                          color: grey,
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
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: InkWell(
              onTap: onTap,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: orange,
                ),
                child: Text(
                  "end_session".tr(),
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
