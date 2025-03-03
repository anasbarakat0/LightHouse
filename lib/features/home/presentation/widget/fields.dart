
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Widget buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text("$title ", style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}

Widget buildProductDetailRow(String productName, int quantity, double price) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            productName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Qty: $quantity',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.blueGrey),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Price: ${price.toStringAsFixed(0)}',
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.green),
          ),
        ),
      ],
    ),
  );
}

Widget buildTotalPriceRow(double totalPrice) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${"total_price".tr()}: ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          "${totalPrice.toStringAsFixed(0)} ${"s.p".tr()}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.green,
          ),
        ),
      ],
    ),
  );
}
