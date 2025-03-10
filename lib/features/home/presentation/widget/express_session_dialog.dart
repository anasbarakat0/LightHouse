import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lighthouse/core/resources/colors.dart';
import 'package:lighthouse/features/home/data/models/get_express_session_response.dart';
import 'package:lighthouse/features/home/presentation/widget/detail_row.dart';
import 'package:lighthouse/features/home/presentation/widget/product_detail_row.dart';

void expressSessionDialog(BuildContext context, ExpressSessionBody sessionData,
    void Function() onTap) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'session_info'.tr(),
          style: Theme.of(context).textTheme.labelLarge,
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
                title: "${"fullName".tr()}: ",
                value: sessionData.fullName,
              ),
              DetailRow(
                title: "${"created_by".tr()}: ",
                value: sessionData.createdBy.firstName,
              ),
              DetailRow(
                title: "${"buffetInvoicePrice".tr()}: ",
                value:
                    "${sessionData.buffetInvoicePrice.toString()} ${"s.p".tr()}",
              ),
              // buildTotalPriceRow(sessionData.buffetInvoicePrice),
              Divider(thickness: 0.5, color: navy),
              Text(
                "buffet_invoice".tr(),
                style: Theme.of(context).textTheme.labelMedium,
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
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
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
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: orange),
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
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: grey),
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
