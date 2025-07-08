import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/finish_premium_session_response_model.dart';
import 'package:lighthouse/features/home/presentation/widget/detail_row.dart';
import 'package:lighthouse/features/home/presentation/widget/product_detail_row.dart';
import 'package:lighthouse/features/home/presentation/widget/total_price_row.dart';

void endSessionDialog(BuildContext context, Body sessionData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'session_info'.tr(),
          style:
              Theme.of(context).textTheme.labelLarge?.copyWith(color: darkNavy),
        ),
        backgroundColor: Colors.white,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DetailRow(
                title: "${"date".tr()}: ",
                value: sessionData.date,
              ),
              DetailRow(
                title: "${"started_at".tr()}: ",
                value: sessionData.startTime,
              ),
              DetailRow(
                title: "${"first_name".tr()}: ",
                value: sessionData.firstName,
              ),
              DetailRow(
                title: "${"last_name".tr()}: ",
                value: sessionData.lastName,
              ),
              // DetailRow(
              //   title: "${"created_by".tr()}: ",
              //   value: sessionData.createdBy.firstName,
              // ),
              DetailRow(
                title: "${"num_of_hours".tr()}: ",
                value:  
                    "${sessionData.sessionInvoice.hoursAmount.toString()} ${"hrs".tr()}",
              ),
              DetailRow(
                title: "${"sessionInvoicePrice".tr()}: ",
                value:  
                    "${sessionData.sessionInvoice.sessionPrice.toString()} ${"s.p".tr()}",
              ),
              DetailRow(
                title: "${"buffetInvoicePrice".tr()}: ",
                value:  
                    "${sessionData.buffetInvoicePrice.toString()} ${"s.p".tr()}",
              ),
              Divider(thickness: 0.5, color: navy),
              Text(
                "buffet_invoice".tr(),
                style: Theme.of(context).textTheme.bodyMedium,
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
                                    return ProductDetailRow(
                                      productName: order.productName,
                                      quantity: order.quantity,
                                      price: order.price,
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                    "${"invoice_price".tr()}: ${invoice.totalPrice}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium),
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
          TotalPriceRow(totalPrice: sessionData.totalPrice),
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: InkWell(
              onTap: () {
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
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
